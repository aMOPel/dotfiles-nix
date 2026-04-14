#!/usr/bin/env bash
# shellcheck disable=SC2155,SC2162

DISKO_FILE=""

require_value() {
  local opt="$1"
  local val="${2:-}"

  if [[ -z $val || $val == -* ]]; then
    echo "Error: $opt requires a value." >&2
    exit 1
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --disko-file)
    require_value "$1" "${2:-}"
    DISKO_FILE="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1" >&2
    exit 1
    ;;
  esac
done

if [[ -z $DISKO_FILE ]]; then
  echo "Error: --disko-file is required." >&2
  exit 1
fi

default_value="y"
read -p "partition disk now? [$default_value] "
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

  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/v1.13.0 -- \
    --mode destroy,format,mount \
    "$DISKO_FILE"
fi

default_value="y"
read -p "install nixos now? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY == "y" ]]; then
  nixos-install -f 'github:amopel/dotfiles-nix#homelab-one'
fi

default_value="y"
read -p "reboot now? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY == "y" ]]; then
  systemctl reboot
fi
