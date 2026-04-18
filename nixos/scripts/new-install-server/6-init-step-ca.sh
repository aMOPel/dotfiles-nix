#!/usr/bin/env bash

# TODO: in a clean pki, the root key is backed up multiple times, encrypted and kept offline
# see https://github.com/badele/nix-homelab/blob/main/modules/features/step-ca/default.nix

# CA_OUTDIR=./ca-out
# SOPS_DIR=./secrets/
# SOPS_FILE=./temp.yaml
# ROTATE_INTERMEDIATE=true
TEMP_SOPS_FILE=$SOPS_DIR/temp.yaml
ROOT_LIFETIME_YEARS=10
INTERMEDIATE_LIFETIME_YEARS=1

ca_pre_setup() {
  rm -rI "$CA_OUTDIR"
  rm -I "$TEMP_SOPS_FILE"
  mkdir -p "$CA_OUTDIR"
}

ca_get_root() {
  sops decrypt --extract '["root-ca"]["public-cert"]' "$SOPS_DIR"/"$SOPS_FILE" >"$CA_OUTDIR"/root-ca.crt
  sops decrypt --extract '["root-ca"]["private-key"]' "$SOPS_DIR"/"$SOPS_FILE" >"$CA_OUTDIR"/root-ca.key
  sops decrypt --extract '["root-ca"]["private-password"]' "$SOPS_DIR"/"$SOPS_FILE" >"$CA_OUTDIR"/root-password.txt
}

ca_setup_root() {
  # root ca password
  step crypto rand --format upper 32 >"$CA_OUTDIR"/root-password.txt

  # root ca
  step certificate create "homelab-one Root CA" \
    "$CA_OUTDIR"/root-ca.crt "$CA_OUTDIR"/root-ca.key \
    --profile root-ca \
    --password-file "$CA_OUTDIR"/root-password.txt \
    --not-after "$(("24" * "365" * ROOT_LIFETIME_YEARS))"h
}

ca_generate_der_format() {
  # also generate DER format for android
  openssl x509 -in "$CA_OUTDIR"/root-ca.crt -outform der -out "$CA_OUTDIR"/root-ca.der
}

ca_setup_intermediate() {
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
    --not-after "$(("24" * "365" * INTERMEDIATE_LIFETIME_YEARS))"h \
    --force
}

sops_pre_setup() {
  mkdir -p "$SOPS_DIR"
  touch "$TEMP_SOPS_FILE"
}

sops_setup_root() {
  yq eval '.root-ca.private-password = load_str("'"$CA_OUTDIR"'/root-password.txt")' -i "$TEMP_SOPS_FILE"
  yq eval '.root-ca.private-key = load_str("'"$CA_OUTDIR"'/root-ca.key")' -i "$TEMP_SOPS_FILE"
  yq eval '.root-ca.public-cert = load_str("'"$CA_OUTDIR"'/root-ca.crt")' -i "$TEMP_SOPS_FILE"
}

sops_setup_intermediate() {
  yq eval '.intermediate-ca.private-password = load_str("'"$CA_OUTDIR"'/intermediate-password.txt")' -i "$TEMP_SOPS_FILE"
  yq eval '.intermediate-ca.public-key = load_str("'"$CA_OUTDIR"'/intermediate.pub")' -i "$TEMP_SOPS_FILE"
  yq eval '.intermediate-ca.private-key = load_str("'"$CA_OUTDIR"'/intermediate-ca.key")' -i "$TEMP_SOPS_FILE"
  yq eval '.intermediate-ca.public-cert = load_str("'"$CA_OUTDIR"'/intermediate-ca.crt")' -i "$TEMP_SOPS_FILE"
}

sops_encrypt() {
  sops encrypt "$TEMP_SOPS_FILE" >"$SOPS_DIR"/"$SOPS_FILE"
}

sops_cleanup() {
  rm "$TEMP_SOPS_FILE"
}

ca_cleanup_root() {
  rm "$CA_OUTDIR"/root-ca.key
  rm "$CA_OUTDIR"/root-password.txt
}

ca_cleanup_intermediate() {
  rm "$CA_OUTDIR"/intermediate-ca.key
  rm "$CA_OUTDIR"/intermediate-password.txt
  rm "$CA_OUTDIR"/intermediate.pub
  rm "$CA_OUTDIR"/intermediate-ca.crt
}

ca_pre_setup
if [[ -v ROTATE_INTERMEDIATE && $ROTATE_INTERMEDIATE ]]; then
  # get the current root-ca instead of generating a new one
  ca_get_root
else
  ca_setup_root
fi
ca_generate_der_format
ca_setup_intermediate

sops_pre_setup
sops_setup_root
sops_setup_intermediate

sops_encrypt

sops_cleanup
ca_cleanup_root
ca_cleanup_intermediate
