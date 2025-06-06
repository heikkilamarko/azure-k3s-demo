#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

USERNAME="$1"

cat user_remove_script.sh | ssh azureuser@$(terraform -chdir=../infra output -raw vm_public_ip) 'sudo bash -s' -- "$USERNAME"
