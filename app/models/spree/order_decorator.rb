Spree::Order.class_eval do
  after_save :sync_with_moneybird, if: :complete?
  after_save :send_moneybird_invoice, if: proc { |o| o.shipment_state == 'shipped' }

  private

  def send_moneybird_invoice
    SpreeMoneybird::Invoice.send_invoice(self)
  end

  def sync_with_moneybird
    sync_moneybird_contact
    sync_moneybird_invoice
    sync_moneybird_payment
  end

  def sync_moneybird_payment
    return unless moneybird_id.nil?
    return unless payment = payments.last
    SpreeMoneybird::Payment.create_payment_from_payment(payment)

  rescue Exception => e
    Rails.logger.error e
    Appsignal.add_exception(e) if defined? Appsignal
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
