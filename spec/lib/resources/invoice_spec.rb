require 'spec_helper'

describe SpreeMoneybird::Invoice do
  subject do
    order = create :order_ready_to_ship
    order.user.stub(:id) { SecureRandom.uuid } # Prevents 422 (duplicate customer id)
    order
  end

  describe 'saving an invoice' do
    before do
      SpreeMoneybird::Invoice.create_invoice_from_order(subject)
    end

    it 'assigns the moneybird id' do
      expect(subject.moneybird_id).not_to be_nil
    end
  end
end
