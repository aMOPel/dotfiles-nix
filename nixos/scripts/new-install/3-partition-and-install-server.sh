#!/usr/bin/env bash
# shellcheck disable=SC2155,SC2162

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/1.13.0 -- \
  --mode destroy,format,mount \
  ./nixos/configuration/machines/homelab-one/partitioning/disko.nix

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
