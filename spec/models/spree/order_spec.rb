require 'spec_helper'

describe Spree::Order do
  subject { build :order_with_totals }

  before do
    SpreeMoneybird::Contact.stub(:create_contact_from_order)
    SpreeMoneybird::Invoice.stub(:create_invoice_from_order)
  end

  it 'syncronizes contact' do
    SpreeMoneybird::Contact.should_receive(:create_contact_from_order).with(subject)
    subject.save!
  end

  it 'syncronizes invoice' do
    SpreeMoneybird::Invoice.should_receive(:create_invoice_from_order).with(subject)
    subject.save!
  end
end
