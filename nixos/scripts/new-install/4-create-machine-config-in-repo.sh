#!/usr/bin/env bash
# shellcheck disable=SC2155,SC2162

is_git_clean="$(git diff --quiet && git diff --cached --quiet && echo "clean" || echo "dirty")"
if [[ $is_git_clean != "clean" ]]; then
  echo "git working directory is dirty. clean it first"
  exit 1
fi

default_value="$USER"
read -p "enter username [$default_value] " username
username=${username:-"$default_value"}

default_value="$HOSTNAME"
read -p "enter hostname [$default_value] " hostname
hostname=${hostname:-"$default_value"}

default_value="$(uname -m)-$(uname -s | awk '{ print tolower($0) }')"
alternative_value="aarch64-linux"
read -p "enter target machine system, possible values are '$default_value', '$alternative_value' [$default_value] " system
system=${system:-"$default_value"}

lsblk --fs
default_value=$(lsblk --fs | awk '$2 == "crypto_LUKS" { print $4 }')
read -p "enter luks disk uuid [$default_value] " uuid
uuid=${uuid:-"$default_value"}

root=$(git rev-parse --show-toplevel)
nixos_dir="$root"/nixos/configuration
templates_dir="$nixos_dir"/templates
target_dir="$nixos_dir"/machines/"$hostname"
config_values_file="$target_dir"/config_values.nix

mkdir -p "$target_dir"
cp /etc/nixos/hardware-configuration.nix "$target_dir"/hardware-configuration.nix
cp "$templates_dir"/configuration.nix "$target_dir"/configuration.nix
cp "$templates_dir"/config_values_.nix "$config_values_file"
sed -i 's?username *= *".*"?username = "'"$username"'"?' "$config_values_file"
sed -i 's?hostname *= *".*"?hostname = "'"$hostname"'"?' "$config_values_file"
sed -i 's?system *= *".*"?system = "'"$system"'"?' "$config_values_file"
sed -i 's?luksDiskPath *= *".*"?luksDiskPath = "/dev/disk/by-uuid/'"$uuid"'"?' "$config_values_file"

echo ""
echo "configuration files have been copied to '$target_dir'"
echo "now you can adapt them as you please and run:"
echo ""
echo "    \$ cd $root"
echo '    $ make nixos-switch-flake'
