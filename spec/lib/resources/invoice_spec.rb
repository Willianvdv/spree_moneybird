require 'spec_helper'

describe SpreeMoneybird::Invoice, vcr: true do
  before do
    Spree::Order.any_instance.stub(:sync_with_moneybird)
  end

  let(:order) { create :order_ready_to_ship }

  describe 'create an invoice' do
    context 'without contact syncronisation (guest access)' do
      before { order.stub(:user).and_return(nil) }

      subject! do
        VCR.use_cassette 'SpreeMoneyBird::Invoice#create_invoice_without_contact' do
          SpreeMoneybird::Invoice.create_invoice_from_order(order)
        end

        order
      end

      it 'stores the moneybird id' do
        expect(subject.moneybird_id).not_to be_nil
      end

      it 'stores the moneybird invoice id' do
        expect(subject.moneybird_invoice_url).not_to be_nil
      end
    end

    context 'with contact syncronisation' do
      before do
        user = create :user
        order.user = user
        order.save!

        Spree::User.any_instance.stub(:id) { SecureRandom.uuid } # Prevents 422 (duplicate customer id)
      end

      let(:moneybird_contact) do
        SpreeMoneybird::Contact.create_contact_from_order(order)
      end

      let(:moneybird_invoice) do
        SpreeMoneybird::Invoice.create_invoice_from_order(order)
      end

      # Reload so we get the actual contact_id and not our assigned one
      subject do
        VCR.use_cassette 'SpreeMoneyBird::Invoice#find_invoice' do
          moneybird_contact
          moneybird_invoice

          SpreeMoneybird::Invoice.find(moneybird_invoice.id)
        end
      end

      it 'invoice has the moneybird contact id' do
        expect(subject.contact_id).to eql(moneybird_contact.id)
      end
    end
  end

  describe 'send an invoice' do
    before do
      VCR.use_cassette 'SpreeMoneyBird::Invoice#create_invoice' do
        SpreeMoneybird::Invoice.create_invoice_from_order(order)
      end

      order.stub(:email) { 'mrwhite@example.com' }
    end

    subject do
      VCR.use_cassette 'SpreeMoneyBird::Invoice#send_invoice' do
        SpreeMoneybird::Invoice.send_invoice(order)
      end
    end

    it 'sends the invoice' do
      expect(subject.email).not_to be_nil
    end
  end
end
