#!/bin/bash
set -euo pipefail

export IMAGE="crk3sdemo.azurecr.io/postgresql:$1"

envsubst < postgresql.yaml | kubectl delete -f -
