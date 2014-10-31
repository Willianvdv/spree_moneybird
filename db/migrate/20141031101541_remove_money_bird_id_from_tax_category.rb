class RemoveMoneyBirdIdFromTaxCategory < ActiveRecord::Migration
  def change
    remove_column :spree_tax_categories, :moneybird_id
  end
end
