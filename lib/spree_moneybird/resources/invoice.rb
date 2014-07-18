module SpreeMoneybird
  class Invoice < BaseResource
    def self.create_invoice_from_order(order)
      invoice = from_order(order)
      invoice.save

      order.moneybird_id = invoice.id
      order.save!

      invoice
    end

    def self.from_order(order)
      tax_rate = SpreeMoneybird::TaxRate.all.first # TODO: Fix hardcode tax setting

      details = order.line_items.map do |line_item|
        { description: line_item.variant.name,
          amount: line_item.quantity,
          created_at: line_item.created_at,
          tax_rate_id: tax_rate.id,
          price: line_item.price }
      end

      attrs = { invoice: { company_name: 'xxx',
                           details_attributes: details } }

      self.new attrs
    end

  end
end
