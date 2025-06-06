#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

USERNAME="$1"
SSH_KEY="$(echo -n "$2" | base64)"

cat user_add_script.sh | ssh azureuser@$(terraform -chdir=../infra output -raw vm_public_ip) 'sudo bash -s' -- "$USERNAME" "$SSH_KEY"
