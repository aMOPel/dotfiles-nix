#!/usr/bin/env bash

importConfig() {
  # default_value="$(mktemp -d -t yubikey-"$(date +'%Y.%m.%dT%H:%M')"-XXXX)"
  default_value="$HOME/.gnupg"
  read -r -p "enter desired GNUPGHOME [${default_value}]:  " GNUPGHOME
  export GNUPGHOME=${GNUPGHOME:-"$default_value"}

  default_value="n"
  read -r -p "copy gpg.conf from drduh? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
    cp -f "@drduhRepo@/config/gpg.conf" "$GNUPGHOME/gpg.conf"
  fi
}

getUserInfo() {
  if [[ -z "$IDENTITY" ]]; then
    default_value="YubiKey"
    read -r -p "enter pgp key identity: [${default_value}]  " IDENTITY
    export IDENTITY=${IDENTITY:-"$default_value"}
  fi

  export KEYID="$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')"
  export KEY_TYPE=${KEY_TYPE:-"rsa4096"}
  export EXPIRATION=${EXPIRATION:-"never"}
}

importConfig
getUserInfo
