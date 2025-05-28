#!/usr/bin/env bash

changeFactoryPins() {

  default_value="y"
  read -r -p "change pins? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
    gpg --command-fd=0 --change-pin <<EOF
3
12345678
q
EOF

    gpg --command-fd=0 --change-pin <<EOF
1
123456
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
    gpg --command-fd=0 --edit-card <<EOF
admin
login
$IDENTITY
quit
EOF
  fi
}

transferSubkeysToYK() {
  default_value="y"
  read -r -p "transfer subkeys to yubikey? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then

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

read -r -p "plug in your yubikey now"
changeFactoryPins
setIdentityOnYK
transferSubkeysToYK
