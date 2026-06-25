#!/bin/bash

namespaces=(
  "example-project-my-dic-encounter-vn-namespace"
  "example-project-my-dic-patient-mr-namespace"
  "example-project-my-dic-patient-pseuded-namespace"
  "example-project-my-dic-patient-anonyed-namespace"
)

for name in "${namespaces[@]}"; do
  curl --request POST \
    --url http://localhost:8089/v1/namespaces \
    --header 'content-type: application/json' \
    --data "{
  \"name\": \"$name\",
  \"pseudonymGenerationMethod\": \"PSEUDONYM_GENERATION_METHOD_UNSPECIFIED\",
  \"pseudonymLength\": 32,
  \"pseudonymPrefix\": \"string\",
  \"pseudonymSuffix\": \"string\",
  \"description\": \"string\"
}"
done
