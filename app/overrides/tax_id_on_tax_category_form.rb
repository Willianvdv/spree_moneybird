Deface::Override.new(:virtual_path => "spree/admin/tax_categories/_form",
                     :name => "add_tax_id_to_tax_category_form",
                     :insert_bottom => "[data-hook='admin_tax_category_form_fields']",
                     :text => '
                      <div class="alpha four columns">
                        <%= f.field_container :moneybird_id do %>
                          <%= f.label :moneybird_id, "Moneybird ID" %>
                          <%= f.text_field :moneybird_id, :class => "fullwidth" %>
                        <% end %>
                      </div>
                     ')
