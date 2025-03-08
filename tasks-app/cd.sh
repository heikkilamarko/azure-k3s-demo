#!/bin/bash
set -euo pipefail

k8s/secrets.sh \
    "$(terraform -chdir=infra output -raw postgresql_administrator_login)" \
    "$(terraform -chdir=infra output -raw postgresql_administrator_password)" \
    "$(terraform -chdir=infra output -raw postgresql_fqdn)"

kubectl apply -f k8s/tasks-app.yaml

sudo sed -i '' '/tasks-app.com/d' /etc/hosts
sudo sh -c 'echo "$(terraform -chdir=../infra output -raw vm_public_ip) tasks-app.com" >> /etc/hosts'
