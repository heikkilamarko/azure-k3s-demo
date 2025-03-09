#!/bin/bash
set -euo pipefail

image_tag="$1"

db_login="$(terraform -chdir=infra output -raw postgresql_administrator_login)"
db_password="$(terraform -chdir=infra output -raw postgresql_administrator_password)"
db_fqdn="$(terraform -chdir=infra output -raw postgresql_fqdn)"
db_port="5432"
db_name="$(terraform -chdir=infra output -raw postgresql_database_name)"

db_connection_string="postgres://$db_login:$db_password@$db_fqdn:$db_port/$db_name?sslmode=require"

kubectl create secret generic tasks-app-secret \
    --from-literal=DB_CONNECTION_STRING="$db_connection_string"

export IMAGE_TAG="$image_tag"
cat k8s/tasks-app.yaml | envsubst | kubectl apply -f -

sudo sed -i '' '/tasks-app.com/d' /etc/hosts
sudo sh -c 'echo "$(terraform -chdir=../infra output -raw vm_public_ip) tasks-app.com" >> /etc/hosts'
