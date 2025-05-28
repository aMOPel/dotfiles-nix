#!/usr/bin/env bash

getUserInfo() {
  ls -lsa .
  default_value="./backup"
  read -e -p "enter path to backup directory [${default_value}]: " BACKUP_DIR
  export BACKUP_DIR=${BACKUP_DIR:-"$default_value"}
}

trustKey() {
  # export KEYID=$(ls "$BACKUP_DIR"/* | sed -n -e 's|^.*/\([^/]*\)-Certify.key$|\1|p')
  export KEYID=$(gpg -K | grep ^sec | head -1 | awk '{print $2}' | sed 's|^.*/0x\(.*\)$|\1|')

  gpg -K
  default_value="$KEYID"
  read -r -p "enter KEYID to trust [$default_value]: " KEYID
  export KEYID=${KEYID:-"$default_value"}

  gpg --command-fd=0 --pinentry-mode=loopback --edit-key "$KEYID" <<EOF
uid *
trust
5
y
save
EOF
}

importKeys() {
  gpg --import "$BACKUP_DIR"/*

  default_value="y"
  read -r -p "trust new key? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
    trustKey
  fi

  gpg -K
}

getUserInfo
importKeys
