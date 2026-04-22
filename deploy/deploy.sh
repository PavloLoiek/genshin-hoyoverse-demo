#!/bin/bash
set -e

# Render API key — embedded so salespeople never need to configure credentials
export RENDER_API_KEY="rnd_dpmybFPmJfiyWvU99GpBlXadVIzU"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -f "$SCRIPT_DIR/.env" ]; then
  source "$SCRIPT_DIR/.env"
fi

APP_NAME="${1:-genshin-hoyoverse}"

echo "=== Deploying $APP_NAME to Render ==="

# Create a Render web service via API
echo "Creating Render web service..."
RESPONSE=$(curl -s -X POST "https://api.render.com/v1/services" \
  -H "Authorization: Bearer $RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"web_service\",
    \"name\": \"$APP_NAME\",
    \"runtime\": \"docker\",
    \"plan\": \"free\",
    \"region\": \"oregon\",
    \"rootDir\": \".\",
    \"dockerfilePath\": \"./Dockerfile\",
    \"envVars\": [],
    \"autoDeploy\": \"no\"
  }")

SERVICE_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('service',{}).get('id',''))" 2>/dev/null || echo "")

if [ -z "$SERVICE_ID" ]; then
  echo "Could not create service (may already exist). Searching..."
  SEARCH=$(curl -s "https://api.render.com/v1/services?name=$APP_NAME&limit=1" \
    -H "Authorization: Bearer $RENDER_API_KEY")
  SERVICE_ID=$(echo "$SEARCH" | python3 -c "import sys,json; data=json.load(sys.stdin); print(data[0]['service']['id'] if data else '')" 2>/dev/null || echo "")

  if [ -z "$SERVICE_ID" ]; then
    echo "Error creating or finding service. Response:"
    echo "$RESPONSE"
    exit 1
  fi
  echo "Found existing service: $SERVICE_ID"
fi

echo "Service ID: $SERVICE_ID"

# Trigger a deploy
echo "Triggering deployment..."
curl -s -X POST "https://api.render.com/v1/services/$SERVICE_ID/deploys" \
  -H "Authorization: Bearer $RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{}'

echo ""
echo "=== Deployment initiated ==="
echo "Render will build from the Dockerfile. First deploy may take 2-5 minutes."
echo "Check status at https://dashboard.render.com"
echo ""
echo "Demo deployed! Access at:"
echo "  FAQ Website:  https://$APP_NAME.onrender.com/"
echo "  Mock APIs:    https://$APP_NAME.onrender.com/docs"
echo "  Documents:    https://$APP_NAME.onrender.com/documents"
echo "  Health Check: https://$APP_NAME.onrender.com/health"
echo ""
echo "==> Full demo URL: https://$APP_NAME.onrender.com/"
