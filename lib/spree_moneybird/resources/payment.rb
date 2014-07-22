module SpreeMoneybird
  class Payment < BaseResource
    self.prefix = "/invoices/:invoice_id/"

    def self.create_payment_from_payment(payment)
      moneybird_payment = self.from_payment(payment)
      moneybird_payment.save

      payment.moneybird_id = moneybird_payment.id
      payment.save!

      moneybird_payment
    end

    def self.from_payment(payment)
      attrs = { payment: { payment_date: payment.created_at,
                           payment_method: 'bank_transfer', # TODO: Hard code payment method
                           price: payment.amount,
                           send_email: false } }

      moneybird_payment = self.new attrs
      moneybird_payment.prefix_options[:invoice_id] = payment.order.moneybird_id
      moneybird_payment
    end
  end
end
