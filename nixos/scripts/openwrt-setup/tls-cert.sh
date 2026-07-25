#!/usr/bin/env bash

CA_OUTDIR=./temp
SOPS_DIR=./secrets/
SOPS_FILE=./step-ca.yaml

INTERMEDIATE_LIFETIME_YEARS=1

ca_pre_setup() {
  rm -rI "$CA_OUTDIR"
  mkdir -p "$CA_OUTDIR"
}

ca_get_root() {
  sops decrypt --extract '["root-ca"]["public-cert"]' "$SOPS_DIR"/"$SOPS_FILE" >"$CA_OUTDIR"/root-ca.crt
  sops decrypt --extract '["root-ca"]["private-key"]' "$SOPS_DIR"/"$SOPS_FILE" >"$CA_OUTDIR"/root-ca.key
  sops decrypt --extract '["root-ca"]["private-password"]' "$SOPS_DIR"/"$SOPS_FILE" >"$CA_OUTDIR"/root-password.txt
}

ca_setup_intermediate() {
  # generate key
  openssl genrsa -out "$CA_OUTDIR"/openwrt.key 2048

  # generate csr
  openssl req -new \
    -key "$CA_OUTDIR"/openwrt.key \
    -out "$CA_OUTDIR"/openwrt.csr \
    -subj "/CN=openwrt.lan"

  # signed by root
  step certificate sign \
    "$CA_OUTDIR"/openwrt.csr \
    "$CA_OUTDIR"/root-ca.crt \
    "$CA_OUTDIR"/root-ca.key \
    --password-file "$CA_OUTDIR"/root-password.txt \
    --not-after "$(("24" * "365" * INTERMEDIATE_LIFETIME_YEARS))"h \
    >"$CA_OUTDIR"/openwrt.crt
}

ca_cleanup_root() {
  rm "$CA_OUTDIR"/root-ca.crt
  rm "$CA_OUTDIR"/root-ca.key
  rm "$CA_OUTDIR"/root-password.txt
}

ca_cleanup_rest() {
  rm "$CA_OUTDIR"/openwrt.csr
}

ca_pre_setup
ca_get_root
ca_setup_intermediate
ca_cleanup_root
ca_cleanup_rest
