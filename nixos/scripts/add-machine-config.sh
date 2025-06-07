#!/usr/bin/env bash

default_value="$USERNAME"
read -p "enter username [$default_value] " username
username=${username:-"$default_value"}

default_value="$HOSTNAME"
read -p "enter hostname [$default_value] " hostname
hostname=${hostname:-"$default_value"}

lsblk --fs
default_value=$(lsblk --fs | awk '$2 == "crypto_LUKS" { print $4 }')
read -p "enter luks disk uuid [$default_value] " uuid
uuid=${uuid:-"$default_value"}

root=$(git rev-parse --show-toplevel)
nixos_dir="$root"/nixos
templates_dir="$nixos_dir"/templates
target_dir="$nixos_dir"/machines/"$hostname"
config_values_file="$target_dir"/config_values.nix

mkdir -p "$target_dir"
cp /etc/nixos/hardware-configuration.nix "$target_dir"/hardware-configuration.nix
cp "$templates_dir"/configuration.nix "$target_dir"/configuration.nix
cp "$templates_dir"/config_values.nix "$config_values_file"
sed -i 's?username *= *".*"?username = "'"$username"'"?' "$config_values_file"
sed -i 's?hostname *= *".*"?hostname = "'"$hostname"'"?' "$config_values_file"
sed -i 's?luksDiskPath *= *".*"?luksDiskPath = "/dev/disk/by-uuid/'"$uuid"'"?' "$config_values_file"
