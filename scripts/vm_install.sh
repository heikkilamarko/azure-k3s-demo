#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

export ACR_LOGIN_SERVER=$(terraform -chdir=../infra output -raw container_registry_login_server)
export ACR_USERNAME=$(terraform -chdir=../infra output -raw container_registry_username)
export ACR_PASSWORD=$(terraform -chdir=../infra output -raw container_registry_password)

envsubst < vm_install_script.sh | ssh azureuser@$(terraform -chdir=../infra output -raw vm_public_ip) 'sudo bash -s' -
