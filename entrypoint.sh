#!/bin/bash

# Exit on errors
set -e

# Ensure Scrapy is installed
if ! command -v scrapy &>/dev/null; then
  echo "Error: Scrapy is not installed or not in PATH. Exiting."
  exit 1
fi

if [[ "$1" == "start-crawl" || "$1" == "shub-image-info" ]]; then
  exec "$@"
fi

for arg in "$@"; do
  if [[ "$arg" == "my_tailscale_spider" ]]; then
    if [ -z "$TS_AUTHKEY" ]; then
      echo "Error: TS_AUTHKEY environment variable is not set. Exiting."
      exit 1
    fi

    echo "Starting Tailscale for spider my_tailscale_spider..."
    tailscaled --tun=userspace-networking &
    sleep 5

    # Start Tailscale with authkey
    echo "Using Tailscale Authkey: $TS_AUTHKEY"
    tailscale up --authkey="$TS_AUTHKEY" --advertise-tags=tag:scrapers --exit-node=100.111.26.96 --accept-routes --shields-up
    break
  fi
done

# Pass all arguments to Scrapy
exec scrapy "$@"
