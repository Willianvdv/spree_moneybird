Deface::Override.new(:virtual_path => "spree/admin/tax_rates/_form",
                     :name => "moneybird_id_to_tax_rate",
                     :insert_bottom => ".omega.six",
                     :text => '
                     <div class="field">
                       <%= f.label :moneybird_id, Spree.t(:moneybird_id) %>
                       <%= f.text_field :moneybird_id, :class => "fullwidth" %>
                     </div>
                     ')
