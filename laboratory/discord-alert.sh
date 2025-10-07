#!/bin/bash
THRESHOLD=10
WEBHOOK_URL="https://discord.com/api/webhooks/1422619848894058689/ocp6jj__o3hgdNSHh5GEbM2ueYUDfxjHwoRlQD3etwBIPKQbQqqqwk6WKQyTuRxkbUH3"

USAGE=$(df --output=pcent,target / | tail -n1 | awk '{print $1}' | tr -d '%')

CPU_USAGE=$(top -bn1 | awk -F'id,' '{split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); print 100 - v}')

RAM_USAGE=$(free | awk '/Mem/{printf("%.0f", ($3/$2)*100)}')


send_alert() {
  local message="$1"
  curl -s -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\": \"$message\"}" \
       "$WEBHOOK_URL" > /dev/null
}
if (( ${CPU_USAGE%.*} > THRESHOLD )); then
  send_alert "⚠ **CPU Alert!** Usage is at ${CPU_USAGE}% (threshold: ${THRESHOLD}%)"
fi

if (( RAM_USAGE > THRESHOLD )); then
  send_alert "⚠ **RAM Alert!** Memory usage is at ${RAM_USAGE}% (threshold: ${THRESHOLD}%)"
fi

if (( USAGE > THRESHOLD )); then
  send_alert "⚠ **Disk Alert!** Root partition '/' usage is at ${USAGE}% (threshold: ${THRESHOLD}%)"
fi