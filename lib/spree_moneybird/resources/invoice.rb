module SpreeMoneybird
  class Invoice < BaseResource
    def self.send_invoice(order)
      invoice = self.from_order order
      invoie_send_data = { invoice: { email: order.email,
                                      send_method: 'hand' } }
      invoice.put :send_invoice, nil, invoie_send_data.to_json # There must be a nicer way to do this
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

      # The normal line items
      order.line_items.each do |line_item|
        moneybird_line_items << {
          description: line_item.variant.name,
          amount: line_item.quantity,
          created_at: line_item.created_at,
          tax_rate_id: line_item.product.tax_category.moneybird_id,
          price: line_item.price }
      end

      # The shipments
      order.shipments.shipped.each do |shipment|
        moneybird_line_items << { description: shipment.shipping_method.name,
                                  price: order.ship_total,
                                  tax_rate_id: shipment.shipping_method.tax_rate.id }
      end

      attrs = { invoice: { contact_id: (order.user.moneybird_id if order.user),
                           contact_name_search: order.billing_address.company,
                           company_name: order.billing_address.company,
                           firstname: order.billing_address.firstname,
                           lastname: order.billing_address.lastname,
                           address1: order.billing_address.address1,
                           address2: order.billing_address.address2,
                           zipcode: order.billing_address.zipcode,
                           city: order.billing_address.city,
                           country: order.billing_address.country.iso_name,
                           details_attributes: moneybird_line_items } }

      self.new attrs
    end
  end
end

# A shipment looks like:
# <Spree::Shipment:0x007fc3ecc09bc8> {
#                       :id => 29,
#                 :tracking => nil,
#                   :number => "H15171705805",
#                     :cost => 17.5,
#               :shipped_at => Mon, 28 Jul 2014 13:40:10 UTC +00:00,
#                 :order_id => 84,
#               :address_id => nil,
#                    :state => "shipped",
#               :created_at => Mon, 28 Jul 2014 13:38:46 UTC +00:00,
#               :updated_at => Mon, 28 Jul 2014 13:54:30 UTC +00:00,
#        :stock_location_id => 1,
#         :adjustment_total => 0.0,
#     :additional_tax_total => 0.0,
#              :promo_total => 0.0,
#       :included_tax_total => 0.0,
#           :pre_tax_amount => nil,
#          :synced_to_paazl => false,
#               :printed_at => nil
# }
