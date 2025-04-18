#!/bin/bash
set -euo pipefail

kubectl delete -f keycloak.yaml

sudo sed -i '' '/keycloak.local/d' /etc/hosts
