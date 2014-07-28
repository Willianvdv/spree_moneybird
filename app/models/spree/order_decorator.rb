Spree::Order.class_eval do
  after_save :sync_with_moneybird, if: :complete?
  after_save :send_moneybird_invoice

  private

  def send_moneybird_invoice
    return unless self.shipment_state == 'shipped'

    SpreeMoneybird::Invoice.send_invoice(self)
    SpreeMoneybird::Payment.create_payment_from_payment(payments.last)
  rescue Exception => e
    Appsignal.add_exception(e) if defined? Appsignal
    raise e
  end

  def sync_with_moneybird
    sync_moneybird_contact
    sync_moneybird_invoice
  end

  def sync_moneybird_contact
    return unless user && user.moneybird_id.nil?
    SpreeMoneybird::Contact.create_contact_from_order(self)
  rescue Exception => e
    Rails.logger.error e
    Appsignal.add_exception(e) if defined? Appsignal
  end

  def sync_moneybird_invoice
    return unless moneybird_id.nil?
    SpreeMoneybird::Invoice.create_invoice_from_order(self)
  rescue Exception => e
    Rails.logger.error e
    Appsignal.add_exception(e) if defined? Appsignal
  end
end
