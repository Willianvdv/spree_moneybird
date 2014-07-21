require 'spec_helper'

describe Spree::Order do
  describe 'completed order' do
    subject { build :order_ready_to_ship }

    before do
      SpreeMoneybird::Contact.stub(:create_contact_from_order)
      SpreeMoneybird::Invoice.stub(:create_invoice_from_order)
    end

    it 'syncronizes contact' do
      SpreeMoneybird::Contact.should_receive(:create_contact_from_order)
                             .with(subject)
      subject.save!
    end

    it 'syncronizes invoice' do
      SpreeMoneybird::Invoice.should_receive(:create_invoice_from_order)
                             .with(subject)
      subject.save!
    end
  end

  describe 'uncompleted order' do
    subject { build :order_with_totals }

    it 'doesn\'t call the sync_with_moneybird method' do
      subject.should_not_receive(:sync_with_moneybird)
      subject.save!
    end
  end
end
