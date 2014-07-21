#Spree Moneybird

We <3 Moneybird & Spree

## Todo's
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
