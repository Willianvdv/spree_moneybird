require 'spec_helper'

describe SpreeMoneybird::Contact do
  let(:order) do
    order = create :order
    # Prevent 422 (duplicate customer id)
    order.user.stub(:id) { SecureRandom.uuid }
    order
  end

  before do
    SpreeMoneybird::Contact.class_eval do
      self.site = "https://#{ENV['MONEYBIRD_COMPANY']}.moneybird.nl"
      self.user = ENV['MONEYBIRD_USER']
      self.password = ENV['MONEYBIRD_PASSWORD']
      if ENV['PROXY']
        self.proxy = ENV['PROXY']
      end


    end
  end

  let(:contact) { SpreeMoneybird::Contact.from_order(order) }

  describe 'create an contact object from an order' do
    subject { contact }

    it 'has the email address of the order\'s user' do
      expect(subject.email).to eql(order.email)
    end
  end

  describe 'saving a contact' do
    subject { puts contact; }

    it 'saved the contact' do
      puts contact.new?
      puts contact.errors.inspect
      puts contact.save
      puts contact.errors.inspect
      #subject
    end
  end
end
