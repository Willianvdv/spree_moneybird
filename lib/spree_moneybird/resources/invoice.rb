module SpreeMoneybird
  class Invoice < BaseResource
    def self.send_invoice(order)
      invoice = self.from_order order

      # There must be a nicer way to do this
      invoie_send_data = ({ invoice: { email: order.email } }).to_json
      invoice.put :send_invoice, nil, invoie_send_data


      invoice
    end

    def self.create_invoice_from_order(order)
      invoice = from_order(order)
      invoice.save

      order.moneybird_id = invoice.id
      order.save!

      invoice
    end

    def self.from_order(order)
      return self.find(order.moneybird_id) unless order.moneybird_id.nil?

      tax_rate = SpreeMoneybird::TaxRate.all.first # TODO: Fix hardcode tax setting

      details_attributes = order.line_items.map do |line_item|
        { description: line_item.variant.name,
          amount: line_item.quantity,
          created_at: line_item.created_at,
          tax_rate_id: tax_rate.id,
          price: line_item.price }
      end

      # This will add a shipment rule to the invoice
      details_attributes << { description: "Verzending",
                              price: order.ship_total,
                              tax_rate_id: tax_rate.id }

      attrs = { invoice: { contact_id: order.user.moneybird_id,
                           contact_name_search: order.billing_address.company,
                           company_name: order.billing_address.company,
                           firstname: order.billing_address.firstname,
                           lastname: order.billing_address.lastname,
                           address1: order.billing_address.address1,
                           address2: order.billing_address.address2,
                           zipcode: order.billing_address.zipcode,
                           city: order.billing_address.city,
                           country: order.billing_address.country.iso_name,
                           details_attributes: details_attributes } }

      self.new attrs
    end
  end
end

# invoice[original_invoice_id]:
# invoice[original_estimate_id]:
# invoice[invoice_profile_id]:1

# invoice[contact_id]:
# invoice[contact_name_search]:testbedrijf3
# invoice[company_name]:Test
# invoice[firstname]:XX
# invoice[lastname]:BEDRIJF
# invoice[attention]:
# invoice[address1]:cc
# invoice[address2]:cc
# invoice[zipcode]:1231
# invoice[city]:ads
# invoice[country]:asdasd

# invoice[copy_contact_information]:0
# invoice_due_date_interval_select:14
# invoice[due_date_interval]:14
# invoice[po_number]:
# invoice[language]:nl
# invoice[show_customer_id]:false
# invoice[show_tax_number]:false
# invoice[currency]:EUR

# invoice[prices_are_incl_tax]:false
# invoice[details_attributes][0][amount]:1 x
# invoice[details_attributes][0][description]:123
# invoice[details_attributes][0][price]:123
# invoice[details_attributes][0][tax_rate_id]:411954
# invoice[details_attributes][0][ledger_account_id]:
# invoice[details_attributes][0][_destroy]:0
# invoice[details_attributes][0][row_order]:0
# invoice[details_attributes][1][amount]:1 x
# invoice[details_attributes][1][description]:Klik hier om een nieuwe regel toe te voegen
# invoice[details_attributes][1][price]:0,00
# invoice[details_attributes][1][tax_rate_id]:411954
# invoice[details_attributes][1][ledger_account_id]:
# invoice[details_attributes][1][_destroy]:0
# invoice[details_attributes][1][row_order]:
# invoice[discount]:0,00
