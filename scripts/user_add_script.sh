#!/bin/bash
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <username> <public_ssh_key>"
  exit 1
fi

USERNAME="$1"
SSH_KEY="$(echo "$2" | base64 --decode)"

if id "$USERNAME" &>/dev/null; then
  echo "[!] User $USERNAME already exists. Aborting."
  exit 1
fi

echo "[*] Creating user $USERNAME"
adduser --disabled-password --gecos "" "$USERNAME"

echo "[*] Adding $USERNAME to sudo group"
usermod -aG sudo "$USERNAME"

echo "[*] Setting up SSH for $USERNAME"
USER_HOME="/home/$USERNAME"
SSH_DIR="$USER_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

mkdir -p "$SSH_DIR"
echo "$SSH_KEY" > "$AUTHORIZED_KEYS"
chmod 700 "$SSH_DIR"
chmod 600 "$AUTHORIZED_KEYS"
chown -R "$USERNAME":"$USERNAME" "$SSH_DIR"

echo "[*] Configuring passwordless sudo for $USERNAME"
SUDOERS_FILE="/etc/sudoers.d/$USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | EDITOR='tee' visudo -f "$SUDOERS_FILE"
chmod 440 "$SUDOERS_FILE"

echo "[*] $USERNAME created and configured with passwordless sudo and SSH access."
