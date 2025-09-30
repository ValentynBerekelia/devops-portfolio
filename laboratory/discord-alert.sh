#!/bin/bash
THRESHOLD=10
WEBHOOK_URL="https://discord.com/api/webhooks/1422619848894058689/ocp6jj__o3hgdNSHh5GEbM2ueYUDfxjHwoRlQD3etwBIPKQbQqqqwk6WKQyTuRxkbUH3"
USAGE=$(df --output=pcent,target / | tail -n1 | awk '{print $1}' | tr -d '%')

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | \
sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
awk '{print 100 - $1}') 

RAM_USAGE=$(free | grep Mem | \
awk '{printf("%.0f", ($3/$2) * 100.0)}')

df -h | awk '$6 == "/" {
 gsub(/%/, "", $5)
 print $6 ": " $5 "%"
}'

if (( CPU_USAGE > THRESHOLD )); then
 MESSAGE="⚠ Disk Alert! Root partition '/' usage is at ${USAGE}% (threshold: ${THRESHOLD}%)"
curl -H "Content-Type: application/json" \
 -X POST \
 -d "{\"content\": \"$MESSAGE\"}" \
 "$WEBHOOK_URL"
fi

if (( RAM_USAGE > THRESHOLD )); then
 MESSAGE="⚠ Disk Alert! Root partition '/' usage is at ${USAGE}% (threshold: ${THRESHOLD}%)"
curl -H "Content-Type: application/json" \
 -X POST \
 -d "{\"content\": \"$MESSAGE\"}" \
 "$WEBHOOK_URL"
fi

if (( USAGE > THRESHOLD )); then
 MESSAGE="⚠ Disk Alert! Root partition '/' usage is at ${USAGE}% (threshold: ${THRESHOLD}%)"
curl -H "Content-Type: application/json" \
 -X POST \
 -d "{\"content\": \"$MESSAGE\"}" \
 "$WEBHOOK_URL"
fi
