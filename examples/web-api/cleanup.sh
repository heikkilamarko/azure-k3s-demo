#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

kubectl delete -f k8s/web-api.yaml

sudo sed -i '' '/web-api.test/d' /etc/hosts
