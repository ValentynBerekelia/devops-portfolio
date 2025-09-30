#!/bin/bash
THRESHOLD=10
WEBHOOK_URL="https://discord.com/api/webhooks/1422619848894058689/ocp6jj__o3hgdNSHh5GEbM2ueYUDfxjHwoRlQD3etwBIPKQbQqqqwk6WKQyTuRxkbUH3"
USAGE=$(df --output=pcent,target / | tail -n1 | awk '{print $1}' | tr -d '%')
if (( USAGE > THRESHOLD )); then
 MESSAGE="⚠ Disk Alert! Root partition '/' usage is at ${USAGE}% (threshold: ${THRESHOLD}%)"
curl -H "Content-Type: application/json" \
 -X POST \
 -d "{\"content\": \"$MESSAGE\"}" \
 "$WEBHOOK_URL"
fi
