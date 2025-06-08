#!/usr/bin/env bash

root=$(git rev-parse --show-toplevel)
nixos_dir="$root"/nixos
repo_nixos_version="$(cat "$nixos_dir"/nixos-version)"

downloadIso() {

  default_value="y"
  read -p "download nixos iso? [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then

    default_value="x86_64"
    alternative_value="aarch64"
    read -p "enter target machine arch, possible values are '$default_value', '$alternative_value' [$default_value] " arch
    arch=${arch:-"$default_value"}

    default_value="$repo_nixos_version"
    read -p "enter nixos version [$default_value] " nixos_version
    nixos_version=${nixos_version:-"$default_value"}

    iso_url=https://channels.nixos.org/nixos-"$nixos_version"/latest-nixos-gnome-"$arch"-linux.iso

    wget -P "$root" "$iso_url".sha256
    wget -P "$root" "$iso_url"

    sha256sum -c "$root"/*.iso.sha256
  fi
}

transferToUsb() {
  lsblk -d -o NAME,SIZE,LABEL,TRAN
  echo ""

  default_value="$(lsblk -d -o NAME,TRAN | awk '$2 == "usb" { print $1 }')"
  read -p "enter storage device name [$default_value] " device
  device=${device:-"$default_value"}

  default_value="y"
  read -p "unmount storage device now? [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
    sudo umount -f /dev/"$device"*
  fi

  default_value="$(ls "$root"/*.iso | head -1)"
  read -p "enter iso file to write to storage device [$default_value] " iso_file
  iso_file=${iso_file:-"$default_value"}

  sudo dd bs=4M conv=fsync oflag=direct status=progress if="$iso_file" of=/dev/"$device"

  default_value="y"
  read -p "cleanup downloads? [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
    rm "$iso_file"
  fi
}

downloadIso
transferToUsb
