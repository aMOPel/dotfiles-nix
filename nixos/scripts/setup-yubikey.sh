#!/usr/bin/env bash

getPins() {
  read -r -s -p "enter new yubikey gpg admin pin: " ADMIN_PIN
  echo ""
  read -r -s -p "confirm admin pin: " ADMIN_PIN_CONFIRM
  echo ""
  if [[ "${ADMIN_PIN_CONFIRM}" != "${ADMIN_PIN}" ]]; then
    while [[ "${ADMIN_PIN_CONFIRM}" != "${ADMIN_PIN}" ]]; do
      echo "passphrases did not match. try again."
      read -r -s -p "enter passphrase: " ADMIN_PIN
      echo ""
      read -r -s -p "confirm passphrase: " ADMIN_PIN_CONFIRM
      echo ""
    done
  fi
  export ADMIN_PIN=${ADMIN_PIN}

  read -r -s -p "enter new yubikey gpg pin: " USER_PIN
  echo ""
  read -r -s -p "confirm pin: " USER_PIN_CONFIRM
  echo ""
  if [[ "${USER_PIN_CONFIRM}" != "${USER_PIN}" ]]; then
    while [[ "${USER_PIN_CONFIRM}" != "${USER_PIN}" ]]; do
      echo "passphrases did not match. try again."
      read -r -s -p "enter passphrase: " USER_PIN
      echo ""
      read -r -s -p "confirm passphrase: " USER_PIN_CONFIRM
      echo ""
    done
  fi
  export USER_PIN=${USER_PIN}
}

changeFactoryPins() {

  default_value="y"
  read -r -p "change pins? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
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

    read -r -p "remove and reinsert the yubikey now."
  fi
}

setIdentityOnYK() {
  default_value="y"
  read -r -p "set identity on yubikey? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
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
  if [[ "$REPLY" == "y" ]]; then

    gpg --command-fd=0 --pinentry-mode=loopback --edit-key "$KEYID" <<EOF
key 1
keytocard
1
$CERTIFY_PASS
$ADMIN_PIN
save
EOF

    gpg --command-fd=0 --pinentry-mode=loopback --edit-key "$KEYID" <<EOF
key 2
keytocard
2
$CERTIFY_PASS
$ADMIN_PIN
save
EOF

    gpg --command-fd=0 --pinentry-mode=loopback --edit-key "$KEYID" <<EOF
key 3
keytocard
3
$CERTIFY_PASS
$ADMIN_PIN
save
EOF

    gpg -K
  fi
}

getPins
changeFactoryPins
setIdentityOnYK
transferSubkeysToYK
