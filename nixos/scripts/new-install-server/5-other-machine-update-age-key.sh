#!/usr/bin/env bash

pubkey="$(ssh root@homelab-one "age-keygen -y /root/.config/sops/age/keys.txt")"
sed -i 's/&homelab-one-age .*$/\&homelab-one-age '"$pubkey"'/g' ./.sops.yaml
sops updatekeys secrets/*.yaml
