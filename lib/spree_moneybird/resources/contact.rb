module SpreeMoneybird
  class Contact < BaseResource
    def self.create_contact_from_order(order)
      contact = from_order(order)
      contact.save

      order.user.moneybird_id = contact.id
      order.user.save!

      contact
    end

    def self.from_order(order)
      # Override this method if you want to update the contact attributes
      self.base_from_order order
    end

    def self.base_from_order(order)

      # This is one big hack. If a contact is created in the webapp or using a
      # guest checkout a new contact is created. Moneybird assigns automatically a
      # new customer_id for this contact. This causes a id conflict where our user.id is
      # already used for another contact
      user_id = SecureRandom.uuid

      attrs = { contact: { customer_id: user_id,
                           contact_name_search: order.billing_address.company,
                           company_name: order.billing_address.company,
                           firstname: order.billing_address.firstname,
                           lastname: order.billing_address.lastname,
                           address1: order.billing_address.address1,
                           address2: order.billing_address.address2,
                           zipcode: order.billing_address.zipcode,
                           city: order.billing_address.city,
                           country: order.billing_address.country.iso_name } }
      self.new attrs
    end

  end
end
