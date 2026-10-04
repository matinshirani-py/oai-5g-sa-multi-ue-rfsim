#!/usr/bin/env bash
# Show the PDU-session IP of each UE (interface oaitun_ue1)
set -uo pipefail

UES=(oai-nr-ue oai-nr-ue2 oai-nr-ue3)

for ue in "${UES[@]}"; do
  echo "=== rfsim5g-${ue} ==="
  if ! docker exec "rfsim5g-${ue}" ip -4 addr show oaitun_ue1 2>/dev/null | grep -w inet; then
    echo "  ❌ no IP on oaitun_ue1 (is the UE running and attached?)"
  fi
done
