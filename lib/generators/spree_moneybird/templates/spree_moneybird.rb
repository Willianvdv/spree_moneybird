SpreeMoneybird.setup do |config|
  config.company = 'your_moneybird_company' # the company in company.moneybird.nl
  config.api = 'your_moneybird_username'
  config.password = 'your_moneybird_password'

  # Verkoopfacturen > BTW verlegd Geen BTW op factuur NL/1e
  config.reversed_charge_tax_id = 'your_moneybird_reversed_charge_tax_id'

  # Used for discounts
  config.discount_tax_id = 'your_moneybird_nil_charge_tax_id'
end
