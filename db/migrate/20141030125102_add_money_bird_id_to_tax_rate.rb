class AddMoneyBirdIdToTaxRate < ActiveRecord::Migration
  def change
    add_column :spree_tax_rates, :moneybird_id, :integer
  end
end
