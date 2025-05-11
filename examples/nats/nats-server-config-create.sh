#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

nats server generate nats-server.conf
