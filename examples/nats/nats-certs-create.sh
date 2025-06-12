#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

IP_1=$(terraform -chdir=../../infra output -raw vm_public_ip)
CERTS_DIR="certs"

rm -rf "$CERTS_DIR"
mkdir -p "$CERTS_DIR"

cd "$CERTS_DIR"

openssl req -x509 -newkey rsa:2048 -nodes -keyout ca.key -out ca.crt -days 36500 -subj "/CN=NATS-CA"

openssl req -newkey rsa:2048 -nodes -keyout tls.key -out tls.csr -subj "/CN=nats.test"

cat > ext.cnf <<EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth

subjectAltName = @alt_names

[alt_names]
DNS.1 = *.nats-headless.examples.svc.cluster.local
DNS.2 = nats-headless.examples.svc.cluster.local
DNS.3 = nats.examples.svc.cluster.local
DNS.4 = nats.test
IP.1 = $IP_1
EOF

openssl x509 -req -in tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out tls.crt -days 36500 -extfile ext.cnf

rm -f tls.csr ext.cnf
