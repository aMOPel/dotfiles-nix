#!/usr/bin/env bash
# shellcheck disable=SC2162

default_value="$(cat /etc/passwd | grep 'home' | awk -F: '{print $1}')"
read -p "set smb password for user [$default_value] "
REPLY=${REPLY:-"$default_value"}
sudo smbpasswd -a "$REPLY"
