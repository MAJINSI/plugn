#!/usr/bin/env bash
set -euo pipefail

legacy_token_pattern="2125bf59e5af2b8c8b5e8b3b19f13e""1221"

if rg -n "$legacy_token_pattern" api docs common --glob '!tests/check-mashkor-webhook-token.sh'; then
  echo "Mashkor webhook token must not be committed." >&2
  exit 1
fi

rg -n "getenv\\('MASHKOR_WEBHOOK_TOKEN'\\)" api/modules/v1/controllers/OrderController.php >/dev/null
rg -n "getenv\\('MASHKOR_WEBHOOK_TOKEN'\\)" api/modules/v2/controllers/OrderController.php >/dev/null
rg -n 'hash_equals\(\$configured_mashkor_token' api/modules/v1/controllers/OrderController.php >/dev/null
rg -n 'hash_equals\(\$configured_mashkor_token' api/modules/v2/controllers/OrderController.php >/dev/null

echo "Mashkor webhook token is runtime-configured and compared safely."
