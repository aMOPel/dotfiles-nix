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

db_pw_setup() {
  LENGTH=128
  tr -cd '[:alnum:]' </dev/urandom | fold -w "${LENGTH}" | head -n 1 | tr -d '\n' >"$OUTDIR"/db.key
}

sops_pre_setup() {
  mkdir -p "$SOPS_DIR"
  touch "$TEMP_SOPS_FILE"
}

sops_setup() {
  yq eval '.forgejo.db_password = load_str("'"$OUTDIR"'/db.key")' -i "$TEMP_SOPS_FILE"
}

sops_encrypt() {
  sops encrypt "$TEMP_SOPS_FILE" >"$SOPS_DIR"/"$SOPS_FILE"
}

cleanup() {
  rm -rf "$OUTDIR"
  rm "$TEMP_SOPS_FILE"
}

pre_setup
db_pw_setup
sops_pre_setup
sops_setup
sops_encrypt
cleanup
