#!/bin/bash -e

# v1.4.0 moved the DIMP anonymization config to services.dimp.anonymization_config
# (see data-node/example-dup-project/example-project-pipeline.yml) - v1.3.0 ignores that key.
VERSION="1.4.0"

curl -sLO "https://github.com/medizininformatik-initiative/aether/releases/download/v$VERSION/aether-$VERSION-linux-amd64.tar.gz"
tar xzf "aether-$VERSION-linux-amd64.tar.gz"
rm "aether-$VERSION-linux-amd64.tar.gz"
chmod +x ./aether-linux-amd64
sudo mv ./aether-linux-amd64 /usr/local/bin/aether
