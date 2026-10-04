#!/usr/bin/env bash
# Concurrent iperf3 test: UE1 and UE3 -> UE2
# Two server instances on separate ports so both tests really run at the same time.
set -uo pipefail

DURATION="${1:-20}"
STREAMS="${2:-2}"
SERVER=rfsim5g-oai-nr-ue2
SERVER_IP=12.1.1.2

cleanup() {
  docker exec "$SERVER" pkill iperf3 2>/dev/null || true
}
trap cleanup EXIT

# Start two servers on UE2 (detached)
docker exec -d "$SERVER" iperf3 -s -p 5201
docker exec -d "$SERVER" iperf3 -s -p 5202
sleep 2

echo "▶ Running UE1 -> UE2 and UE3 -> UE2 for ${DURATION}s (${STREAMS} streams each)..."

docker exec rfsim5g-oai-nr-ue  iperf3 -c "$SERVER_IP" -p 5201 -t "$DURATION" -P "$STREAMS" > /tmp/iperf_ue1.txt 2>&1 &
pid1=$!
docker exec rfsim5g-oai-nr-ue3 iperf3 -c "$SERVER_IP" -p 5202 -t "$DURATION" -P "$STREAMS" > /tmp/iperf_ue3.txt 2>&1 &
pid3=$!

wait "$pid1" "$pid3"

echo
echo "=== UE1 -> UE2 ==="
grep -E "SUM.*(sender|receiver)" /tmp/iperf_ue1.txt
echo
echo "=== UE3 -> UE2 ==="
grep -E "SUM.*(sender|receiver)" /tmp/iperf_ue3.txt
