require 'spec_helper'

describe Spree::Order do
  describe 'a completed order' do
    subject { build :order_ready_to_ship }

    before do
      SpreeMoneybird::Contact.stub :create_contact_from_order
      SpreeMoneybird::Invoice.stub :create_invoice_from_order
      SpreeMoneybird::Invoice.stub :send_invoice
    end

    it 'syncronizes contact' do
      SpreeMoneybird::Contact.should_receive(:create_contact_from_order)
                             .with(subject)
      subject.sync_with_moneybird
    end

    it 'syncronizes invoice' do
      SpreeMoneybird::Invoice.should_receive(:create_invoice_from_order)
                             .with(subject)
      subject.sync_with_moneybird
    end

    it 'does not send the moneybird invoice' do
      subject.should_not_receive(:send_moneybird_invoice)
      subject.sync_with_moneybird
    end

    describe 'order is a guest checkout (it has no user)' do
      before do
        subject.user = nil
      end

      it 'does not sync the contact' do
        subject.should_not_receive(:send_moneybird_invoice)
        subject.sync_with_moneybird
      end
    end

    describe 'once shipped' do
      before do
        subject.update_attributes(shipment_state: 'shipped') # Set shipment state
        subject.stub(:email) { 'mrwhite@example.com' }
      end

      it 'sends the moneybird invoice' do
        SpreeMoneybird::Invoice.should_receive(:send_invoice).with(subject)
        subject.sync_with_moneybird
      end

      context 'with payments' do
        let(:payment) { create :payment, order: subject, state: :completed }

        it 'creates the the moneybird payment' do
          SpreeMoneybird::Payment.should_receive(:create_payment_from_payment)
                                 .with(payment)
          subject.sync_with_moneybird
        end
      end
    end
  end

  describe 'discounted order' do
    it 'creates the moneybird invoice' do
      order = create :order_with_line_items, line_items_count: 1
      line_item = order.line_items.first

      line_item.price = 20
      # line_item.tax_category = tax_rate.tax_category
      line_item.save

      calculator = Spree::Calculator::FlatRate.new(preferred_amount: 10)

      promotion = Spree::Promotion.create(name: 'beetje korting')
      promotion_action = Spree::Promotion::Actions::CreateItemAdjustments.create \
        calculator: calculator,
        promotion: promotion

      create :adjustment, source: promotion_action, adjustable: order

      Spree::ItemAdjustments.new(line_item)

      binding.pry
    end
  end

  describe 'uncompleted order' do
    subject { build :order_with_totals }

    it 'does not call the sync_with_moneybird method' do
      subject.should_not_receive(:sync_with_moneybird)
      subject.save!
    end
  end
end
