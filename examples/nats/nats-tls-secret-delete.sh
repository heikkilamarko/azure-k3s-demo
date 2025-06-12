#!/bin/bash
set -euo pipefail

kubectl delete secret nats-tls --namespace examples
