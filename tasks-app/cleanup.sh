#!/bin/bash
set -euo pipefail

kubectl delete -f k8s/tasks-app.yaml

sudo sed -i '' '/tasks-app.com/d' /etc/hosts
