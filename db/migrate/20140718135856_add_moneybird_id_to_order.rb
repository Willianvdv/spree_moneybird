class AddMoneybirdIdToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :moneybird_id, :integer
  end
end
