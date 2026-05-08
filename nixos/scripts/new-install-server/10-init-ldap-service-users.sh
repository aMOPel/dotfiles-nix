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

setup_service() {
  local service_name="$1"
  local pw_file="$OUTDIR"/"$service_name"_password.key
  # generate pw
  LENGTH=128
  tr -cd '[:alnum:]' </dev/urandom | fold -w "${LENGTH}" | head -n 1 | tr -d '\n' >"$pw_file"

  # add service defintion for ldap
  cat <<EOF >>"$OUTDIR"/service-users.ldif
dn: uid=${service_name},ou=services,dc=homelab-one,dc=lan
objectClass: top
objectClass: account
objectClass: simpleSecurityObject
uid: ${service_name}
description: ${service_name} service account
userPassword: test

EOF

  # add service pw to yaml as value
  yq eval '.ldap.services.'"$service_name"'.password = load_str("'"$pw_file"'")' -i "$TEMP_SOPS_FILE"

  # add service pw to ldif service defintion
  awk -v dn="dn: uid=$service_name,ou=services,dc=homelab-one,dc=lan" \
    -v newpw="userPassword: $(cat "$pw_file")" '
  $0 == dn {inblock=1}
  inblock && $1=="userPassword:" {$0=newpw}
  inblock && NF==0 {inblock=0}
  {print}
  ' "$OUTDIR"/service-users.ldif >"$OUTDIR"/service-users-temp.ldif
  mv "$OUTDIR"/service-users-temp.ldif "$OUTDIR"/service-users.ldif
}

sops_pre_setup() {
  mkdir -p "$SOPS_DIR"
  touch "$TEMP_SOPS_FILE"
}

sops_setup() {
  setup_service "authelia"
  setup_service "radiale"

  yq eval '.ldap."service-users.ldif" = load_str("'"$OUTDIR"'/service-users.ldif")' -i "$TEMP_SOPS_FILE"
}

sops_encrypt() {
  sops encrypt "$TEMP_SOPS_FILE" >"$SOPS_DIR"/"$SOPS_FILE"
}

cleanup() {
  rm -rf "$OUTDIR"
  rm "$TEMP_SOPS_FILE"
}

pre_setup
sops_pre_setup
sops_setup
sops_encrypt
cleanup
