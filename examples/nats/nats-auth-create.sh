#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

nats_server="$(terraform -chdir=../../infra output -raw vm_public_ip):4222"

nats auth operator add example

nats auth account add \
    --operator example \
    --bearer \
    --jetstream \
    --js-disk 1GB \
    --js-memory 1GB \
    --payload 1MB \
    --defaults \
    example

nats auth user add \
    --operator example \
    --bearer \
    --payload=-1 \
    --defaults \
    example example

nats auth user add \
    --operator example \
    --defaults \
    system SYSTEM

nats auth user credential \
    --operator example \
    system.cred system SYSTEM

nats ctx add azure-k3s-demo-system \
    --server $nats_server \
    --tlsca "$PWD/certs/ca.crt" \
    --creds "$PWD/system.cred"

nats auth user credential \
    --operator example \
    example.cred example example

nats ctx add azure-k3s-demo-example \
    --server $nats_server \
    --tlsca "$PWD/certs/ca.crt" \
    --creds "$PWD/example.cred"
