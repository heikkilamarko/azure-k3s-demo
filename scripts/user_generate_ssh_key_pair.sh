#!/bin/bash
set -euo pipefail

FILENAME=$1

ssh-keygen -t rsa -b 4096 -f "$FILENAME"
