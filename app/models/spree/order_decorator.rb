Spree::Order.class_eval do
  after_save :sync_with_moneybird, if: :complete?
  after_save :send_moneybird_invoice, if: proc { |o| o.shipment_state == 'shipped' }

  private

  def send_moneybird_invoice
    SpreeMoneybird::Invoice.send_invoice(self)
  end

  def sync_with_moneybird
    SpreeMoneybird::Contact.create_contact_from_order(self) if user.moneybird_id.nil?
    SpreeMoneybird::Invoice.create_invoice_from_order(self) if moneybird_id.nil?
  end
end
