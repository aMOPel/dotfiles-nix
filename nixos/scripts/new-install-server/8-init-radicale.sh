#!/usr/bin/env bash
# shellcheck disable=SC2162

FILE_NAME=/var/lib/radicale/users

default_value="$(cat /etc/passwd | grep 'home' | awk -F: '{print $1}')"
read -p "set radicale password for user [$default_value] "
REPLY=${REPLY:-"$default_value"}
sudo htpasswd -5 -c "$FILE_NAME" "$REPLY"
sudo chmod 600 "$FILE_NAME"
sudo chown radicale:radicale "$FILE_NAME"
