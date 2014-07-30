class AddMoneyBirdIdToTaxCategory < ActiveRecord::Migration
  def change
    add_column :spree_tax_categories, :moneybird_id, :integer
  end
end
