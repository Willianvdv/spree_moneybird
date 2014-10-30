module SpreeMoneybird
  class Invoice < BaseResource
    def self.send_invoice(order)
      invoice = self.from_order order
      invoie_send_data = { invoice: { email: order.email,
                                      send_method: 'hand' } }

      invoice.put :send_invoice, nil, invoie_send_data.to_json # There must be a nicer way to do this

      order.touch :moneybird_invoice_sent_at

      invoice
    end

    def self.create_invoice_from_order(order)
      invoice = from_order(order)
      invoice.save # Move this save to self.from_order

      order.moneybird_id = invoice.id
      order.moneybird_invoice_url = invoice.url
      order.save!

      invoice
    end

    def self.from_order(order)
      return self.find(order.moneybird_id) unless order.moneybird_id.nil?

      moneybird_line_items = []
      tax_rate_ids = []

      # The normal line items
      order.line_items.each do |line_item|
        tax_rate_id = line_item.adjustments.where(source_type: 'Spree::TaxRate').first.source_id

        if tax_rate_id
          moneybird_tax_rate_id = Spree::TaxRates.find(tax_category_id).moneybird_id
        else
          # reverse charge or 0% tax
          # if there is no tax on the line items Spree doesn't create an adjustment
          # we can not get the moneybird_id from the adjustment
          moneybird_tax_rate_id = SpreeMoneybird.reversed_charge_tax_id
        end

        line_item_tax_id = moneybird_tax_rate_id
        # add the id to an array to calculate the most used layer
        tax_rate_ids << moneybird_tax_rate_id

        moneybird_line_items << {
          description: line_item.variant.name,
          amount: line_item.quantity,
          created_at: line_item.created_at,
          tax_rate_id: line_item_tax_id,
          price: line_item.price }
      end

      # for the shipment tax id pick the most used tax rate on the invoice
      # https://www.paazl.com/btw-verzendkosten-hoe-zit-het/
      shipment_tax_id = tax_rate_ids.group_by(&:to_s).values.max_by(&:size).try(:first)

      # The shipments
      order.shipments.shipped.each do |shipment|
        moneybird_line_items << {
          description: shipment.shipping_method.name,
          price: order.ship_total,
          tax_rate_id: shipment_tax_id }
      end

      invoice_attrs = {
        contact_name_search: order.billing_address.company,
        company_name: order.billing_address.company,
        firstname: order.billing_address.firstname,
        lastname: order.billing_address.lastname,
        address1: order.billing_address.address1,
        address2: order.billing_address.address2,
        zipcode: order.billing_address.zipcode,
        city: order.billing_address.city,
        country: order.billing_address.country.name,
        details_attributes: moneybird_line_items
      }

      # Guest checkout
      invoice_attrs[:contact_id] = order.user.moneybird_id unless order.user.nil?

      self.new({ invoice: invoice_attrs })
    end
  end
end
