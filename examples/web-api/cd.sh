#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

export IMAGE="crk3sdemo.azurecr.io/web-api:$1"
export IMAGE_MIGRATIONS="crk3sdemo.azurecr.io/web-api-migrations:$1"

db_login="$(terraform -chdir=infra output -raw postgresql_administrator_login)"
db_password="$(terraform -chdir=infra output -raw postgresql_administrator_password)"
db_fqdn="$(terraform -chdir=infra output -raw postgresql_fqdn)"
db_port="5432"
db_name="$(terraform -chdir=infra output -raw postgresql_database_name)"
db_connection_string="postgres://$db_login:$db_password@$db_fqdn:$db_port/$db_name?sslmode=require"

export DB_CONNECTION_STRING="$db_connection_string"

envsubst < k8s/web-api.yaml | kubectl apply -f -

sudo sed -i '' '/web-api.local/d' /etc/hosts
sudo sh -c 'echo "$(terraform -chdir=../../infra output -raw vm_public_ip) web-api.local" >> /etc/hosts'
