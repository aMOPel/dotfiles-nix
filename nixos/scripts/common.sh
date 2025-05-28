#!/usr/bin/env bash

importConfig() {
  default_value="$(mktemp -d -t yubikey-"$(date +'%Y.%m.%dT%H:%M')"-XXXX)"
  read -r -p "enter desired GNUPGHOME [${default_value}]:  " GNUPGHOME
  export GNUPGHOME=${GNUPGHOME:-"$default_value"}

  default_value="y"
  read -r -p "copy gpg.conf from drduh? [${default_value}]  "
  export REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
    cp -f "@drduhRepo@/config/gpg.conf" "$GNUPGHOME/gpg.conf"
  fi
}

getUserInfo() {
  if [[ -z "$IDENTITY" ]]; then
    default_value="YubiKey"
    read -r -p "enter identity in a format like this: [${default_value}]  " IDENTITY
    export IDENTITY=${IDENTITY:-"$default_value"}
  fi

  export KEYID="$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')"
  export KEY_TYPE=${KEY_TYPE:-"rsa4096"}
  export EXPIRATION=${EXPIRATION:-"never"}

  if [[ -z "$CERTIFY_PASS" ]]; then
    echo "For this script to work, the passphrase needs to only contain alpha numerics due to a bug with gpg."
    echo "Read more here https://www.reddit.com/r/yubikey/comments/1b5pjzq/strange_gpg_error_when_using_keytocard/ ."
    echo "If this is unacceptable for you, you have to do it manually."
    read -r -s -p "enter passphrase: " CERTIFY_PASS
    echo ""
    read -r -s -p "confirm passphrase: " CERTIFY_PASS_CONFIRM
    echo ""
    if [[ "${CERTIFY_PASS_CONFIRM}" != "${CERTIFY_PASS}" ]]; then
      while [[ "${CERTIFY_PASS_CONFIRM}" != "${CERTIFY_PASS}" ]]; do
        echo "passphrases did not match. try again."
        read -r -s -p "enter passphrase: " CERTIFY_PASS
        echo ""
        read -r -s -p "confirm passphrase: " CERTIFY_PASS_CONFIRM
        echo ""
      done
    fi
    export CERTIFY_PASS=${CERTIFY_PASS}
  fi

  read -r -p "plug in your yubikey now"
}

importConfig
getUserInfo
