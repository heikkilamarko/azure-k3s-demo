#!/bin/bash
set -e

USERNAME=$1

if [ -z "$USERNAME" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

if ! id "$USERNAME" &>/dev/null; then
  echo "[!] User $USERNAME does not exist."
  exit 1
fi

echo "[*] Removing user $USERNAME"
deluser --remove-home "$USERNAME"

echo "[*] Removing sudoers file for user $USERNAME"
rm -f /etc/sudoers.d/"$USERNAME"

echo "[*] $USERNAME removed."
