#!/usr/bin/env bash
# shellcheck disable=SC2155,SC2162

LOCAL_DOTFILES_REPO=""
MOUNT_ONLY=false

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
  --mount-only)
    MOUNT_ONLY=true
    shift 1
    ;;
  --local-dotfiles-repo)
    require_value "$1" "${2:-}"
    LOCAL_DOTFILES_REPO="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1" >&2
    exit 1
    ;;
  esac
done

if [[ -z $LOCAL_DOTFILES_REPO ]]; then
  echo "Error: --local-dotfiles-repo is required." >&2
  exit 1
fi

DISKO_FILE="$LOCAL_DOTFILES_REPO"/nixos/configuration/machines/homelab-one/partitioning/disko.nix

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

  if $MOUNT_ONLY; then
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/v1.13.0 -- \
      --mode mount \
      "$DISKO_FILE"
  else
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/v1.13.0 -- \
      --mode destroy,format,mount \
      "$DISKO_FILE"
  fi

  lsblk -f
fi

# ./dotfiles-nix/nixos/scripts/new-install/3-partition-and-install-server.sh --local-dotfiles-repo ./dotfiles-nix

default_value="y"
read -p "install nixos now? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY == "y" ]]; then
  nixos-install --flake "$LOCAL_DOTFILES_REPO"#homelab-one
fi

default_value="y"
read -p "reboot now? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY == "y" ]]; then
  systemctl reboot
fi
