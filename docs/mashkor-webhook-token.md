# Mashkor webhook token

The v1/v2 order status webhook handlers require a runtime token in:

- `MASHKOR_WEBHOOK_TOKEN`

Do not commit the Mashkor webhook token to controller code, test fixtures, or config files.

When the variable is missing, Mashkor webhook requests fail closed with the existing authorization error response and log a server-side configuration warning.
