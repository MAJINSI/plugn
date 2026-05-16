#!/usr/bin/env bash
set -euo pipefail

# Pattern-only guards: do not encode the historical token value in this test.
if rg -n "mashkor_secret_token\\s*={2,3}\\s*['\"][^'\"]{20,}['\"]" api docs common; then
  echo "Mashkor webhook tokens must not be hardcoded in controller code." >&2
  exit 1
fi

if rg -n "\"webhook_token\"\\s*=>\\s*\"[0-9a-f]{32,}\"" api/tests; then
  echo "Mashkor webhook tests must not commit real-looking token fixtures." >&2
  exit 1
fi

rg -n "getenv\\('MASHKOR_WEBHOOK_TOKEN'\\)" api/modules/v1/controllers/OrderController.php >/dev/null
rg -n "getenv\\('MASHKOR_WEBHOOK_TOKEN'\\)" api/modules/v2/controllers/OrderController.php >/dev/null
rg -n 'hash_equals\(\$configured_mashkor_token' api/modules/v1/controllers/OrderController.php >/dev/null
rg -n 'hash_equals\(\$configured_mashkor_token' api/modules/v2/controllers/OrderController.php >/dev/null
rg -n "seeResponseContainsJson\\(\\[" api/tests/functional/v1/OrderCest.php >/dev/null
rg -n "seeResponseContainsJson\\(\\[" api/tests/functional/v2/OrderCest.php >/dev/null
rg -n "dontSeeResponseContains\\('Failed to authorize the request\\.'" api/tests/functional/v1/OrderCest.php >/dev/null
rg -n "dontSeeResponseContains\\('Failed to authorize the request\\.'" api/tests/functional/v2/OrderCest.php >/dev/null

echo "Mashkor webhook token is runtime-configured and compared safely."
