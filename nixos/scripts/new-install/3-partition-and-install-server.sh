#!/usr/bin/env bash
# shellcheck disable=SC2155,SC2162

default_value="y"
read -p "partition disk and install nixos now? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY == "y" ]]; then

  askPass() {
    echo ""
    read -sp "enter luks passphrase " passphrase1
    echo ""
    read -sp "enter luks passphrase again " passphrase2
  }

  askPass
  while [[ $passphrase1 != "$passphrase2" ]]; do
    echo ""
    echo "passphrases don't match"
    askPass
  done

  # needs to match the keyfile in disko.nix
  file=/tmp/secret.key
  touch $file
  chmod 600 $file
  chown root:root $file
  echo "$passphrase1" >$file

  nix \
    --extra-experimental-features flakes \
    --extra-experimental-features nix-command \
    run 'github:nix-community/disko/v1.13.0#disko-install' -- \
    --flake '/root/dotfiles-nix#homelab-one' \
    --disk disk0 /dev/nvme0n1 \
    --disk disk1 /dev/sda \
    --disk disk2 /dev/sdb \
    --write-efi-boot-entries
fi

default_value="y"
read -p "reboot now? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY == "y" ]]; then
  systemctl reboot
fi
