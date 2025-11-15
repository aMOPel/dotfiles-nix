#!/usr/bin/env bash
# shellcheck disable=SC2155,SC2162

getPins() {
  read -r -s -p "enter new yubikey gpg admin pin: " ADMIN_PIN
  echo ""
  read -r -s -p "confirm admin pin: " ADMIN_PIN_CONFIRM
  echo ""
  if [[ ${ADMIN_PIN_CONFIRM} != "${ADMIN_PIN}" ]]; then
    while [[ ${ADMIN_PIN_CONFIRM} != "${ADMIN_PIN}" ]]; do
      echo "admin pins did not match. try again."
      read -r -s -p "enter admin pin: " ADMIN_PIN
      echo ""
      read -r -s -p "confirm admin pin: " ADMIN_PIN_CONFIRM
      echo ""
    done
  fi
  export ADMIN_PIN=${ADMIN_PIN}

  read -r -s -p "enter new yubikey gpg pin: " USER_PIN
  echo ""
  read -r -s -p "confirm pin: " USER_PIN_CONFIRM
  echo ""
  if [[ ${USER_PIN_CONFIRM} != "${USER_PIN}" ]]; then
    while [[ ${USER_PIN_CONFIRM} != "${USER_PIN}" ]]; do
      echo "pins did not match. try again."
      read -r -s -p "enter pin: " USER_PIN
      echo ""
      read -r -s -p "confirm pin: " USER_PIN_CONFIRM
      echo ""
    done
  fi
  export USER_PIN=${USER_PIN}
}

changeFactoryPins() {
  default_value="y"
  read -r -p "change pins? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ $REPLY == "y" ]]; then
    gpg --command-fd=0 --pinentry-mode=loopback --change-pin <<EOF
3
12345678
$ADMIN_PIN
$ADMIN_PIN
q
EOF

    gpg --command-fd=0 --pinentry-mode=loopback --change-pin <<EOF
1
123456
$USER_PIN
$USER_PIN
q
EOF

    putoutPutin
  fi
}

setIdentityOnYK() {
  default_value="y"
  read -r -p "set identity on yubikey? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ $REPLY == "y" ]]; then
    gpg --command-fd=0 --pinentry-mode=loopback --edit-card <<EOF
admin
login
$IDENTITY
$ADMIN_PIN
quit
EOF
  fi
}

transferSubkeysToYK() {
  default_value="y"
  read -r -p "transfer subkeys to yubikey? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ $REPLY == "y" ]]; then

    gpg --command-fd=0 --edit-key "$KEYID" <<EOF
key 1
keytocard
1
save
EOF

    gpg --command-fd=0 --edit-key "$KEYID" <<EOF
key 2
keytocard
2
save
EOF

    gpg --command-fd=0 --edit-key "$KEYID" <<EOF
key 3
keytocard
3
save
EOF

    gpg -K
  fi
}

activateTouchOnYK() {
  default_value="y"
  read -r -p "activate touch requirement with 15s cache on yubikey for all keys? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ $REPLY == "y" ]]; then
    putoutPutin

    for SUBKEY in dec sig aut; do
      ykman openpgp keys set-touch "$SUBKEY" cached -f --admin-pin "$ADMIN_PIN"
    done

    ykman openpgp info
  fi
}

putin() {
  read -r -p "plug-in your yubikey now"
}

putout() {
  read -r -p "unplug your yubikey now"
}

putoutPutin() {
  read -r -p "unplug and re-insert your yubikey now"
}

getBackupDir() {
  if [[ -z $BACKUP_DIR ]]; then
    ls -lsa .
    default_value="./gpg-key-backup"
    read -r -e -p "enter path to backup directory [${default_value}]: " BACKUP_DIR
    export BACKUP_DIR=${BACKUP_DIR:-"$default_value"}
  fi
}

deleteOldKey() {
  default_value="y"
  read -r -p "change pins? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ $REPLY == "y" ]]; then
    gpg --delete-secret-and-public-keys "$KEYID"
  fi
}

importKey() {
  default_value="y"
  read -r -p "change pins? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ $REPLY == "y" ]]; then
    echo "$CERTIFY_PASS" | gpg --batch --passphrase-fd 0 --import "$BACKUP_DIR"/*
  fi
}

trustKey() {
  gpg --command-fd=0 --pinentry-mode=loopback --edit-key "$KEYID" <<EOF
uid *
trust
5
y
save
EOF
}

anotherYK() {
  while true; do
    default_value="y"
    read -r -p "setup another YK? [${default_value}]  " CONTINUE
    export CONTINUE=${CONTINUE:-"$default_value"}
    if [[ $CONTINUE != "y" ]]; then break; fi

    putout
    deleteOldKey
    getBackupDir
    importKey
    trustKey

    putin
    changeFactoryPins
    setIdentityOnYK
    transferSubkeysToYK
    activateTouchOnYK
  done

}

firstYK() {
  getPins
  putin
  changeFactoryPins
  setIdentityOnYK
  transferSubkeysToYK
  activateTouchOnYK
}

# firstYK
anotherYK
