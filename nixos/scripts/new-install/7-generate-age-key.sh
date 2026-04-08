#!/usr/bin/env bash

FILE_NAME="/root/.config/sops/age/keys.txt"

nix-shell -p age --run "sudo age-keygen -o ""$FILE_NAME"
sudo chmod 600 "$FILE_NAME"
sudo chown root:root "$FILE_NAME"
