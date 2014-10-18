namespace :moneybird do
  task sync: :environment do
    # TODO: Filter out fully synced orders
    syncable_orders = Spree::Order.complete.limit(10)

    syncable_orders.each do |order|
      begin
        order.sync_with_moneybird
      rescue Exception => e
        Appsignal.add_exception(e) if defined? Appsignal
        Rails.logger.error e
      end
    end
  end
end
