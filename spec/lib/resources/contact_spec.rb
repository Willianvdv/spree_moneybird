require 'spec_helper'

describe SpreeMoneybird::Contact do
  let(:order) do
    order = create :order
    order.user.stub(:id) { SecureRandom.uuid } # Prevent 422 (duplicate customer id)
    order
  end

  describe 'saving a contact' do
    subject { order.user }
    
    before do
      SpreeMoneybird::Contact.create_contact_from_order(order)
    end

    it 'assigns the moneybird id' do
      expect(subject.moneybird_id).not_to be_nil
    end
  end
end
