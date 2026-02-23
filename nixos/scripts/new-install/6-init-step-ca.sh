#!/usr/bin/env bash

# TODO: in a clean pki, the root key is backed up multiple times, encrypted and kept offline
# see https://github.com/badele/nix-homelab/blob/main/modules/features/step-ca/default.nix

# CA_OUTDIR=./ca-out
# SOPS_DIR=./secrets/
# SOPS_FILE=./temp.yaml
TEMP_SOPS_FILE=$SOPS_DIR/temp.yaml

mkdir -p "$CA_OUTDIR"

# root ca password
step crypto rand --format upper 32 >"$CA_OUTDIR"/root-password.txt

# root ca
step certificate create "homelab-one Root CA" \
  "$CA_OUTDIR"/root-ca.crt "$CA_OUTDIR"/root-ca.key \
  --profile root-ca \
  --password-file "$CA_OUTDIR"/root-password.txt

# intermediate-ca password
step crypto rand --format upper 32 >"$CA_OUTDIR"/intermediate-password.txt

# Intermediate keypair
step crypto keypair \
  "$CA_OUTDIR"/intermediate.pub \
  "$CA_OUTDIR"/intermediate-ca.key \
  --password-file "$CA_OUTDIR"/intermediate-password.txt

# Intermedia CA signed by root
step certificate create "homelab-one Intermediate CA" \
  "$CA_OUTDIR"/intermediate-ca.crt "$CA_OUTDIR"/intermediate-ca.key \
  --profile intermediate-ca \
  --ca "$CA_OUTDIR"/root-ca.crt \
  --ca-key "$CA_OUTDIR"/root-ca.key \
  --password-file "$CA_OUTDIR"/intermediate-password.txt \
  --ca-password-file "$CA_OUTDIR"/root-password.txt \
  --force

mkdir -p "$SOPS_DIR"
touch "$TEMP_SOPS_FILE"

yq eval '.root-ca.private-password = load_str("'"$CA_OUTDIR"'/root-password.txt")' -i "$TEMP_SOPS_FILE"
yq eval '.root-ca.private-key = load_str("'"$CA_OUTDIR"'/root-ca.key")' -i "$TEMP_SOPS_FILE"
yq eval '.root-ca.public-cert = load_str("'"$CA_OUTDIR"'/root-ca.crt")' -i "$TEMP_SOPS_FILE"

yq eval '.intermediate-ca.private-password = load_str("'"$CA_OUTDIR"'/intermediate-password.txt")' -i "$TEMP_SOPS_FILE"
yq eval '.intermediate-ca.public-key = load_str("'"$CA_OUTDIR"'/intermediate.pub")' -i "$TEMP_SOPS_FILE"
yq eval '.intermediate-ca.private-key = load_str("'"$CA_OUTDIR"'/intermediate-ca.key")' -i "$TEMP_SOPS_FILE"
yq eval '.intermediate-ca.public-cert = load_str("'"$CA_OUTDIR"'/intermediate-ca.crt")' -i "$TEMP_SOPS_FILE"

sops encrypt "$TEMP_SOPS_FILE" >"$SOPS_DIR"/"$SOPS_FILE"

rm "$TEMP_SOPS_FILE"
rm "$CA_OUTDIR"/root-ca.key
rm "$CA_OUTDIR"/root-password.txt
rm "$CA_OUTDIR"/intermediate-ca.key
rm "$CA_OUTDIR"/intermediate-password.txt

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
