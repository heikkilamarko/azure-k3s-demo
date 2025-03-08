#!/bin/bash
set -euo pipefail

kubectl delete -f k8s/tasks-app.yaml
kubectl delete secret tasks-app-secret

sudo sed -i '' '/tasks-app.com/d' /etc/hosts
