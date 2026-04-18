#!/usr/bin/env bash

DIR="/root/.config/sops/age"
FILE_NAME="$DIR/keys.txt"

mkdir -p "$DIR"
rm -i "$FILE_NAME"
nix-shell -p age --run "sudo age-keygen -o ""$FILE_NAME"
sudo chmod 600 "$FILE_NAME"
sudo chown root:root "$FILE_NAME"
