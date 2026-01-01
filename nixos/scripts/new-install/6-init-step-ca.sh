#!/usr/bin/env bash

# generate encryption password for certificates
sudo mkdir -p /run/keys
head -c 40 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | sudo tee /run/keys/smallstep-password >/dev/null

# initialize step-ca
sudo HOME=/var/lib/step-ca step ca init --name "homelab-one CA" --dns "homelab-one,localhost" --address "127.0.0.1:8443" --provisioner "acme" --password-file /run/keys/smallstep-password
