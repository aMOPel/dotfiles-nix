#!/usr/bin/env bash

trustKey() {
  gpg --command-fd=0 --pinentry-mode=loopback --edit-key "$KEYID" <<EOF
uid *
trust
5
y
save
EOF
}

generateKeys() {
  echo "$CERTIFY_PASS" | gpg --batch --passphrase-fd 0 --quick-generate-key "$IDENTITY" "$KEY_TYPE" cert never

  export KEYID=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')

  export KEYFP=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^fpr:/ { print $10; exit }')

  printf "\nKey ID: %40s\nKey FP: %40s\n\n" "$KEYID" "$KEYFP"

  trustKey

  for SUBKEY in sign encrypt auth; do
    echo "$CERTIFY_PASS" | gpg --batch --pinentry-mode=loopback --passphrase-fd 0 --quick-add-key "$KEYFP" "$KEY_TYPE" "$SUBKEY" "$EXPIRATION"
  done

  gpg -K
}

createBackup() {
  default_value="./gpg-key-backup"
  read -r -p "enter path to backup directory [${default_value}]:  " BACKUP_DIR
  export BACKUP_DIR=${BACKUP_DIR:-"$default_value"}

  if [[ -d "$BACKUP_DIR" ]]; then
    echo "removing $BACKUP_DIR"
    rm -rI "$BACKUP_DIR"
  fi
  mkdir -p "$BACKUP_DIR"

  echo "$CERTIFY_PASS" | gpg --output "$BACKUP_DIR"/"$KEYID"-Certify.key --batch --pinentry-mode=loopback --passphrase-fd 0 --armor --export-secret-keys "$KEYID"

  echo "$CERTIFY_PASS" | gpg --output "$BACKUP_DIR"/"$KEYID"-Subkeys.key --batch --pinentry-mode=loopback --passphrase-fd 0 --armor --export-secret-subkeys "$KEYID"

  gpg --output "$BACKUP_DIR"/"$KEYID"-"$(date +%F)".asc --armor --export "$KEYID"
}

importKeys() {
  export KEYID=$(ls "$BACKUP_DIR"/* | sed -n -e 's|^.*/\([^/]*\)-Certify.key$|\1|p')
  gpg --import "$BACKUP_DIR"/*

  trustKey
}

generateKeys
createBackup
