require 'spec_helper'

describe SpreeMoneybird::Contact do
  let(:order) do
    order = create :order
    # Prevent 422 (duplicate customer id)
    order.user.stub(:id) { SecureRandom.uuid }
    order
  end

  subject { SpreeMoneybird::Contact.from_order(order) }

  describe 'create an contact object from an order' do
    it 'has the email address of the order\'s user' do
      expect(subject.email).to eql(order.email)
    end
  end

  describe 'saving a contact' do
    before do
      subject.save
    end

    it 'assigns the id' do
      expect(subject.id).not_to be_nil
    end
  end
end
