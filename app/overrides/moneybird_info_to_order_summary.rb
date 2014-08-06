Deface::Override.new(:virtual_path => "spree/admin/shared/_order_summary",
                     :name => "add_moneybird_info_to_order_summary",
                     :insert_after => "#date_complete",
                     :text => "
                     <% if @order.moneybird_id %>
                       <dt>Moneyb ID:</dt>
                       <dd><%= @order.moneybird_id %></dd>
                       <dt>Moneyb URL:</dt>
                       <dd><%= link_to 'Bekijk', @order.moneybird_invoice_url %></dd>
                     <% end %>
                     ")
