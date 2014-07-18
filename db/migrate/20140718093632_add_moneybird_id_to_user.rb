class AddMoneybirdIdToUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :moneybird_id, :integer
  end
end
