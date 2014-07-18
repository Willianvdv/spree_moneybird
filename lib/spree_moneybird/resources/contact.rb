module SpreeMoneybird
  class Contact < BaseResource
    def self.from_order(order)
      attrs = { contact: { customer_id: order.user.id,
                           email: order.email,
                           company_name: 'xxx',
                           firstname: 'willian',
                           lastname: 'vdv' } }
      self.new attrs
    end

  end
end
