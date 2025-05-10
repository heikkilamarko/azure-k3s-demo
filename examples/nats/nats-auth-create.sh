#!/bin/bash
set -euo pipefail

nats_server="$(terraform -chdir=../../infra output -raw vm_public_ip):4222"

nats auth operator add example

nats auth account add \
    --operator=example \
    --bearer \
    --jetstream \
    --js-disk=1GB \
    --js-memory=1GB \
    --payload=2MB \
    --defaults \
    example

nats auth user add \
    --operator=example \
    --bearer \
    --payload=-1 \
    --defaults \
    example example

nats auth user add \
    --operator=example \
    --defaults \
    system SYSTEM

nats auth user cred system.cred system SYSTEM

nats ctx add azure-k3s-demo-system \
    --server $nats_server \
    --creds "$PWD/system.cred"

nats auth user cred example.cred example example

nats ctx add azure-k3s-demo-example \
    --server $nats_server \
    --creds "$PWD/example.cred"
