#!/usr/bin/env bash
# Stop the setup in reverse order (UEs -> gNB -> core)
set -euo pipefail

cd ~/openairinterface5g/ci-scripts/yaml_files/5g_rfsimulator

docker compose stop oai-nr-ue oai-nr-ue2 oai-nr-ue3
docker compose stop oai-gnb
docker compose stop oai-ext-dn oai-upf oai-smf oai-amf mysql
docker compose ps
