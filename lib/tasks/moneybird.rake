namespace :moneybird do
  task sync: :environment do
    # TODO: Filter out fully synced orders
    syncable_orders = Spree::Order.complete

    syncable_orders.each do |order|
      begin
        order.sync_with_moneybird
      rescue Exception => e
        p e
      end
    end
  end
end
