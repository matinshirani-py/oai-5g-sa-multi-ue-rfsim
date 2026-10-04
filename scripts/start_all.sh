#!/usr/bin/env bash
# Start the OAI 5G SA multi-UE setup (core -> gNB -> 3 UEs)
set -euo pipefail

cd ~/openairinterface5g/ci-scripts/yaml_files/5g_rfsimulator

docker compose up -d mysql oai-amf oai-smf oai-upf oai-ext-dn
sleep 10
docker compose up -d oai-gnb
sleep 5
docker compose up -d oai-nr-ue oai-nr-ue2 oai-nr-ue3
docker compose ps
