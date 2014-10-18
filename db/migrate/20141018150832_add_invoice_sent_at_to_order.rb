class AddInvoiceSentAtToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :moneybird_invoice_sent_at, :datetime
  end
end
