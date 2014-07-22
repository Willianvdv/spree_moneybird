class AddMoneybirdIdToPayment < ActiveRecord::Migration
  def change
    add_column :spree_payments, :moneybird_id, :integer
  end
end
