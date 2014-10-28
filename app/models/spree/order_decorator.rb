Spree::Order.class_eval do

  def sync_with_moneybird
    if moneybird_id.nil?
      sync_moneybird_contact if complete?
      sync_moneybird_invoice if complete?
    end

    if shipment_state == 'shipped'
      send_moneybird_invoice
      sync_payments_with_moneybird
    end
  end

  private

  def sync_payments_with_moneybird
    payments.completed.each do |payment|
      next unless payment.moneybird_id.nil?
      SpreeMoneybird::Payment.create_payment_from_payment(payment)
    end
  end

  def send_moneybird_invoice
    SpreeMoneybird::Invoice.send_invoice(self)
  end

  def sync_moneybird_contact
    return if user.nil? # For guest checkouts
    return unless user.moneybird_id.nil?

    SpreeMoneybird::Contact.create_contact_from_order(self)
  end

  def sync_moneybird_invoice
    SpreeMoneybird::Invoice.create_invoice_from_order(self)
  end
end
