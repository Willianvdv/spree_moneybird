require 'spec_helper'

describe SpreeMoneybird::Contact, vcr: true do
  before do
    Spree::Order.any_instance.stub(:sync_with_moneybird)
  end

  let(:order) do
    order = create :order
    order.stub(:sync_with_moneybird)
    order.user.stub(:id) { SecureRandom.uuid } # Prevent 422 (duplicate customer id)
    order
  end

  describe 'saving a contact' do
    subject { order.user }

    before do
      VCR.use_cassette 'SpreeMoneyBird#create_contact' do
        SpreeMoneybird::Contact.create_contact_from_order(order)
      end
    end

    it 'assigns the moneybird id' do
      expect(subject.moneybird_id).not_to be_nil
    end
  end
end
