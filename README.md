Nog niet klaar :)


#Spree Moneybird

We <3 Moneybird & Spree

## Todo's
- VCR for tests
- Async moneybird post
- Set the right tax setting
- Discounts
- Shipping costs?
- Register payments
- Sync state (cancel / pending / etc)
- Credit note
- Email the invoice to the customer

## Tests

**Don't use your production moneybird credentials!**

```
MONEYBIRD_COMPANY=mycompany MONEYBIRD_USER='info@mycompany.com' MONEYBIRD_PASSWORD=ilikekittensverymuchy bundle exec rspec
```

For debugging the API I use charles proxy. Simply add `PROXY` to env:
```
PROXY='http://127.0.0.1:8888' MONEYBIRD_COMPANY=mycompany MONEYBIRD_USER='info@mycompany.com' MONEYBIRD_PASSWORD=ilikekittensverymuchy bundle exec rspec
```

## Eigenschappen

- Voor elke completed order wordt een factuur gemaakt
- Completed payments worden als payment onder het factuur geboekt
- Maakt een factuur definitief aan op het moment dat alle producten verzonden zijn. Hierdoor zijn er geen creditnota's nodig als er producten niet geleverd kunnen worden en uit de order gehaald worden.
