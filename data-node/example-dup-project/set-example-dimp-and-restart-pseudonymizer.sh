#!/bin/bash

YAML_PATH="${1:-../example-dup-project/example-project_dimp_dup_base.yaml}"
ENV_FILE="${2:-../fhir-pseudonymizer/.env}"

if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s|DIMP_DUP_YAML_PATH=.*|DIMP_DUP_YAML_PATH=\"$YAML_PATH\"|" "$ENV_FILE"
else
  sed -i "s|DIMP_DUP_YAML_PATH=.*|DIMP_DUP_YAML_PATH=\"$YAML_PATH\"|" "$ENV_FILE"
fi


cd ../fhir-pseudonymizer
docker compose -p dataportal down fhir-pseudonymizer
docker compose -p dataportal up -d