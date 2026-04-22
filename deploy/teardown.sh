#!/bin/bash
set -e

# Render API key — embedded so salespeople never need to configure credentials
export RENDER_API_KEY="rnd_dpmybFPmJfiyWvU99GpBlXadVIzU"

APP_NAME="${1:-genshin-hoyoverse}"

echo "Destroying $APP_NAME demo on Render..."

SEARCH=$(curl -s "https://api.render.com/v1/services?name=$APP_NAME&limit=1" \
  -H "Authorization: Bearer $RENDER_API_KEY")
SERVICE_ID=$(echo "$SEARCH" | python3 -c "import sys,json; data=json.load(sys.stdin); print(data[0]['service']['id'] if data else '')" 2>/dev/null || echo "")

if [ -z "$SERVICE_ID" ]; then
  echo "Service '$APP_NAME' not found on Render. It may have already been deleted."
  exit 0
fi

echo "Found service: $SERVICE_ID — Deleting..."
curl -s -X DELETE "https://api.render.com/v1/services/$SERVICE_ID" \
  -H "Authorization: Bearer $RENDER_API_KEY"

echo ""
echo "Done. Demo has been removed from Render."
