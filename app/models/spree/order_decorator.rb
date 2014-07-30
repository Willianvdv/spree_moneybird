Spree::Order.class_eval do
  after_save :sync_with_moneybird, if: :complete?
  after_save :send_moneybird_invoice, if: proc { |o| o.shipment_state == 'shipped' }

  private

  def sync_with_moneybird
    sync_moneybird_contact
    sync_moneybird_invoice
  end

  def send_moneybird_invoice
    try do
      SpreeMoneybird::Invoice.send_invoice(self)
      SpreeMoneybird::Payment.create_payment_from_payment(payments.last)
    end
  end

  def sync_moneybird_contact
    return unless user && user.moneybird_id.nil?
    try { SpreeMoneybird::Contact.create_contact_from_order(self) }
  end

  def sync_moneybird_invoice
    return unless moneybird_id.nil?
    try { SpreeMoneybird::Invoice.create_invoice_from_order(self) }
  end

  def try
    yield
  rescue Exception => e
    Rails.logger.error e
    Appsignal.add_exception(e) if defined? Appsignal
  end
end
