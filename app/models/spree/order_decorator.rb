Spree::Order.class_eval do
  after_save :sync_with_moneybird, if: :complete?

  private

  def sync_with_moneybird
    SpreeMoneybird::Contact.create_contact_from_order(self) if user.moneybird_id.nil?
    SpreeMoneybird::Invoice.create_invoice_from_order(self) if moneybird_id.nil?
  end
end
