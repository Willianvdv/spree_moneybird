
describe SpreeMoneybird::Invoice do
  let(:order) do
    order = create :order_ready_to_ship
    order.user.stub(:id) { SecureRandom.uuid  }# Prevents 422 (duplicate customer id)
    order
  end

  subject { SpreeMoneybird::Invoice.from_order(order) }

  describe 'saving an invoice' do
    before do
      subject.save
    end

    it 'assigns the id' do
      expect(subject.id).not_to be_nil
    end
  end
end
