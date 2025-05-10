#!/bin/bash
set -euo pipefail

nats auth account push \
    --operator=example \
    --context azure-k3s-demo-system \
    example
