#!/usr/bin/env bash

# TODO: in a clean pki, the root key is backed up multiple times, encrypted and kept offline
# see https://github.com/badele/nix-homelab/blob/main/modules/features/step-ca/default.nix

# DIR=./.
# root ca password
step crypto rand --format upper 32 >"$DIR"/root-password.txt

# root ca
step certificate create "homelab-one Root CA" \
  "$DIR"/root-ca.crt "$DIR"/root-ca.key \
  --profile root-ca \
  --password-file "$DIR"/root-password.txt

# intermediate-ca password
step crypto rand --format upper 32 >"$DIR"/intermediate-password.txt

# Intermediate keypair
step crypto keypair \
  "$DIR"/intermediate.pub \
  "$DIR"/intermediate-ca.key \
  --password-file "$DIR"/intermediate-password.txt

# Intermedia CA signed by root
step certificate create "homelab-one Intermediate CA" \
  "$DIR"/intermediate-ca.crt "$DIR"/intermediate-ca.key \
  --profile intermediate-ca \
  --ca "$DIR"/root-ca.crt \
  --ca-key "$DIR"/root-ca.key \
  --password-file "$DIR"/intermediate-password.txt \
  --ca-password-file "$DIR"/root-password.txt \
  --force

# root ca password
# head -c 40 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | sudo tee ./smallstep-password >/dev/null
# # initialize step-ca
# sudo HOME=/var/lib/step-ca step ca init \
#   --name "homelab-one CA" \
#   --dns "homelab-one,localhost" \
#   --address "127.0.0.1:8443" \
#   --provisioner "acme" \
#   --password-file /var/lib/private/step-ca/smallstep-password \
#   --acme \
#   --deployment-type standalone
#
# # distribute this certificate to clients
# sudo cp /var/lib/step-ca/.step/certs/root_ca.crt "$HOME"/root_ca.crt
# sudo chown "$USER":users "$HOME"/root_ca.crt
#
# # give step-ca permissions for the files
# sudo chown -R step-ca:step-ca /var/lib/private/step-ca
