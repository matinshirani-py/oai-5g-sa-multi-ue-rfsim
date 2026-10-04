#!/usr/bin/env bash
# Ping test between all 6 directional UE pairs
set -uo pipefail

COUNT="${1:-3}"

declare -A IP=(
  [oai-nr-ue]=12.1.1.3
  [oai-nr-ue2]=12.1.1.2
  [oai-nr-ue3]=12.1.1.4
)
declare -A NAME=(
  [oai-nr-ue]=UE1
  [oai-nr-ue2]=UE2
  [oai-nr-ue3]=UE3
)

fail=0
printf "%-8s %-8s %s\n" "SOURCE" "DEST" "RESULT"

for src in oai-nr-ue oai-nr-ue2 oai-nr-ue3; do
  for dst in oai-nr-ue oai-nr-ue2 oai-nr-ue3; do
    [[ "$src" == "$dst" ]] && continue
    out=$(docker exec "rfsim5g-${src}" ping -c "$COUNT" -W 2 "${IP[$dst]}" 2>&1)
    loss=$(echo "$out" | grep -oE '[0-9]+(\.[0-9]+)?% packet loss' | head -1)
    if [[ "$loss" == "0% packet loss" ]]; then
      printf "%-8s %-8s ✅ %s\n" "${NAME[$src]}" "${NAME[$dst]}" "$loss"
    else
      printf "%-8s %-8s ❌ %s\n" "${NAME[$src]}" "${NAME[$dst]}" "${loss:-no reply}"
      fail=1
    fi
  done
done

exit $fail
