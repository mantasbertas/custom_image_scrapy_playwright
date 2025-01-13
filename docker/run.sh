#!/usr/bin/env sh
set -e
set -o errexit

# Check if required environment variables are set
if [ -z "$TAILSCALE_CLIENT_ID" ] || [ -z "$TAILSCALE_CLIENT_SECRET" ]; then
  echo "Error: TAILSCALE_CLIENT_ID and TAILSCALE_CLIENT_SECRET must be set."
  exit 1
fi

# Obtain Tailscale access token
export TS_ACCESS_TOKEN="$(curl -s -d "client_id=$TAILSCALE_CLIENT_ID" \
   -d "client_secret=$TAILSCALE_CLIENT_SECRET" \
   "https://api.tailscale.com/api/v2/oauth/token" | jq -r '.access_token')"

# Obtain Tailscale auth key
export TAILSCALE_AUTHKEY="$(curl --request POST \
  --silent \
  --url 'https://api.tailscale.com/api/v2/tailnet/-/keys?all=true' \
  --header "Authorization: Bearer ${TS_ACCESS_TOKEN}" \
  --header 'Content-Type: application/json' \
  --data '{
  "capabilities": {
    "devices": {
      "create": {
        "reusable": false,
        "ephemeral": true,
        "preauthorized": true,
        "tags": [
          "tag:scrapers"
        ]
      }
    }
  },
  "expirySeconds": 3600,
  "description": "scrapers"
}' | jq -r '.key')"

echo "Tailscale access token: ${TS_ACCESS_TOKEN}"
echo "Tailscale authkey: ${TAILSCALE_AUTHKEY}"

echo "Starting tailscaled"
tailscaled --state=mem: --tun=userspace-networking --socks5-server=localhost:1055 &

sleep 5

tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=scrapers-experiment  --accept-routes --shields-up --exit-node=100.111.26.96 &
echo "Tailscale started"

tailscale status

echo "Testing connectivity via Tailscale"
curl -x socks5://localhost:1055 https://ifconfig.me
