#!/usr/bin/env bash

# TODO: in a clean pki, the root key is backed up multiple times, encrypted and kept offline
# see https://github.com/badele/nix-homelab/blob/main/modules/features/step-ca/default.nix

# generate encryption password for certificates
head -c 40 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | sudo tee /var/lib/private/step-ca/smallstep-password >/dev/null

# initialize step-ca
sudo HOME=/var/lib/step-ca step ca init \
  --name "homelab-one CA" \
  --dns "homelab-one,localhost" \
  --address "127.0.0.1:8443" \
  --provisioner "acme" \
  --password-file /var/lib/private/step-ca/smallstep-password \
  --acme \
  --deployment-type standalone

# distribute this certificate to clients
sudo cp /var/lib/step-ca/.step/certs/root_ca.crt "$HOME"/root_ca.crt
sudo chown "$USER":users "$HOME"/root_ca.crt

# give step-ca permissions for the files
sudo chown -R step-ca:step-ca /var/lib/private/step-ca
