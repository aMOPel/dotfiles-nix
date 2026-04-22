#!/usr/bin/env bash

# OUTDIR=./out
# SOPS_DIR=./secrets/
# SOPS_FILE=./temp.yaml
TEMP_SOPS_FILE=$SOPS_DIR/temp.yaml

pre_setup() {
  rm -rI "$OUTDIR"
  rm -I "$TEMP_SOPS_FILE"
  mkdir -p "$OUTDIR"
}

jwt_secret_setup() {
  LENGTH=128
  tr -cd '[:alnum:]' </dev/urandom | fold -w "${LENGTH}" | head -n 1 | tr -d '\n' >"$OUTDIR"/jwt.key
}

storage_encryption_key_setup() {
  LENGTH=128
  tr -cd '[:alnum:]' </dev/urandom | fold -w "${LENGTH}" | head -n 1 | tr -d '\n' >"$OUTDIR"/storage.key
}

session_secret_setup() {
  LENGTH=128
  tr -cd '[:alnum:]' </dev/urandom | fold -w "${LENGTH}" | head -n 1 | tr -d '\n' >"$OUTDIR"/session.key
}

sops_pre_setup() {
  mkdir -p "$SOPS_DIR"
  touch "$TEMP_SOPS_FILE"
}

sops_setup() {
  yq eval '.authelia.jwt_secret = load_str("'"$OUTDIR"'/jwt.key")' -i "$TEMP_SOPS_FILE"
  yq eval '.authelia.storage.encryption_key = load_str("'"$OUTDIR"'/storage.key")' -i "$TEMP_SOPS_FILE"
  yq eval '.authelia.session.secret = load_str("'"$OUTDIR"'/session.key")' -i "$TEMP_SOPS_FILE"
}

sops_encrypt() {
  sops encrypt "$TEMP_SOPS_FILE" >"$SOPS_DIR"/"$SOPS_FILE"
}

cleanup() {
  rm -rf "$OUTDIR"
  rm "$TEMP_SOPS_FILE"
}

pre_setup
jwt_secret_setup
storage_encryption_key_setup
session_secret_setup
sops_pre_setup
sops_setup
sops_encrypt
cleanup
