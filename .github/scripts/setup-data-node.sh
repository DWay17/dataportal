#!/bin/bash -e

# Brings up a data node with its base/default service configuration, wired for a CI
# runner (localhost domains + self-signed cert instead of a real reverse-proxy setup).
# Used as shared setup for e2e test jobs - it does not enable/disable individual
# services, tests are expected to wait for whatever services they specifically need.

BASE_DIR="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 || exit 1 ; pwd -P )"
DATA_NODE_DIR="$BASE_DIR/data-node"

"$DATA_NODE_DIR/initialise-node-env-files.sh"

# rev-proxy/docker-compose.yml reads these through ${VAR:-default} interpolation, and
# compose gives the shell environment precedence over rev-proxy/.env - so exporting them
# is enough and no edit of the generated .env is needed. This does not work for
# fhir-server, whose compose files use env_file:.
export FHIR_SERVER_HOSTNAME="fhir.localhost"
export FLARE_HOSTNAME="flare.localhost"
export KEYCLOAK_HOSTNAME="auth.localhost"
export DATA_NODE_REV_PROXY_NGINX_CONFIG="./subdomains.nginx.conf"

CERT_DOMAINS="localhost, fhir.localhost, auth.localhost, flare.localhost, torch.localhost, terminology.localhost, dimp.localhost, flattener.localhost, validator.localhost" \
  "$DATA_NODE_DIR/generate-cert.sh"

# fhir-flattener needs a flatteningLookup.json - not checked into git, has to be fetched
(cd "$DATA_NODE_DIR/aether" && ./get_flattening_lookup.sh)

"$DATA_NODE_DIR/start-node.sh"
