#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

CERTS_DIR="certs"

kubectl create secret generic nats-tls \
  --from-file=tls.crt="$CERTS_DIR/tls.crt" \
  --from-file=tls.key="$CERTS_DIR/tls.key" \
  --from-file=ca.crt="$CERTS_DIR/ca.crt" \
  --namespace examples
