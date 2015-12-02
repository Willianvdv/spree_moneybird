#Spree Moneybird

Creates Moneybrid invoices for orders placed in your Spree webshop.

## Todo's
- Discounts
- Sync state (cancel / pending / etc)

## Tests

**Don't use your production moneybird credentials for tests!**

```
MONEYBIRD_COMPANY=mycompany MONEYBIRD_USER='info@mycompany.com' MONEYBIRD_PASSWORD=ilikekittensverymuchy MONEYBIRD_REVERSED_CHARGE_TAX_ID=my_tax_free_or_reversed_id MONEYBIRD_DISCOUNT_TAX_ID=my_nil_tax_id bundle exec rspec
```

For debugging the API I use charles proxy. Simply add `PROXY` to env:
```
PROXY='http://127.0.0.1:8888' MONEYBIRD_COMPANY=mycompany MONEYBIRD_USER='info@mycompany.com' MONEYBIRD_PASSWORD=ilikekittensverymuchy MONEYBIRD_REVERSED_CHARGE_TAX_ID=my_tax_free_or_reversed_id MONEYBIRD_DISCOUNT_TAX_ID=my_nil_tax_id bundle exec rspec
```

## BTW verlegd

Verstuur je facturen waarbij de btw is verlegd?
Configureer dan de `reversed_charge_tax_id` in de initializer.
Hier dien je de ID van het BTW tarief "Verkoopfacturen > BTW verlegd" in te vullen.

## Eigenschappen

- Voor elke completed order wordt een (concept) factuur gemaakt
- Completed payments worden als payment onder het factuur geboekt
- Maakt een factuur definitief aan op het moment dat alle producten verzonden zijn. Hierdoor zijn er geen creditnota's nodig als er producten niet geleverd kunnen worden en uit de order gehaald worden.
