class AddMoneybirdInvoiceUrlToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :moneybird_invoice_url, :string
  end
end
