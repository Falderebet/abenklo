#!/usr/bin/env bash
# ============================================================
# Åbenklo – Coolify deploy script
# Usage:  ./deploy.sh
# Requires: COOLIFY_TOKEN and COOLIFY_WEBHOOK_URL in .env.deploy
# ============================================================
set -euo pipefail

ENV_FILE=".env.deploy"

if [[ ! -f "$ENV_FILE" ]]; then
  cat <<MSG
ERROR: $ENV_FILE not found.
Create it with:

  COOLIFY_TOKEN=your_api_token_here
  COOLIFY_WEBHOOK_URL=https://your-coolify.example.com/api/v1/deploy?uuid=YOUR_APP_UUID&force=false

You can find these in your Coolify dashboard under:
  Application → Configuration → Webhooks & API
MSG
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

echo "→ Triggering Coolify deployment…"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  -X GET \
  -H "Authorization: Bearer ${COOLIFY_TOKEN}" \
  "${COOLIFY_WEBHOOK_URL}")

if [[ "$HTTP_STATUS" == "200" || "$HTTP_STATUS" == "201" ]]; then
  echo "✓ Deployment triggered (HTTP $HTTP_STATUS)"
  echo "  Monitor progress in your Coolify dashboard."
else
  echo "✗ Deployment failed (HTTP $HTTP_STATUS)"
  echo "  Check your COOLIFY_TOKEN and COOLIFY_WEBHOOK_URL."
  exit 1
fi
