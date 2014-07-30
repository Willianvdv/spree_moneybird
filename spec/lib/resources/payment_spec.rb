require 'spec_helper'

describe SpreeMoneybird::Payment, vcr: true do
  before do
    Spree::Order.any_instance.stub(:sync_with_moneybird)
  end

  let(:order) do
    order = create :order_ready_to_ship
    order.user.stub(:id) { SecureRandom.uuid } # Prevent 422 (duplicate customer id)

    VCR.use_cassette 'SpreeMoneyBird::Payment#create_and_send_invoice' do
      SpreeMoneybird::Invoice.create_invoice_from_order(order)
      SpreeMoneybird::Invoice.send_invoice(order)
    end

    order
  end

  subject { create :payment,
                   order: order,
                   amount: order.total * 1.21 }

  describe 'saving a payment' do
    before do
      VCR.use_cassette 'SpreeMoneyBird::Payment#create_payment' do
        SpreeMoneybird::Payment.create_payment_from_payment(subject)
      end
    end

    it 'assigns the moneybird id' do
      expect(subject.moneybird_id).not_to be_nil
    end
  end
end
