#!/usr/bin/env bash
# shellcheck disable=SC2155,SC2162

default_value="y"
read -p "add ssh daemon to nixos configuration.nix? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY != "y" ]]; then
  exit 1
fi

echo "add a root password first"
sudo passwd

echo "configuration.nix BEFORE"
echo ""
cat /etc/nixos/configuration.nix
echo ""

sudo sed -i 's/\}[\n\r\s]*$/services.openssh={enable=true;settings={PasswordAuthentication=true;PermitRootLogin="yes";};};}/' /etc/nixos/configuration.nix

echo "configuration.nix AFTER"
echo ""
cat /etc/nixos/configuration.nix
echo ""

default_value="y"
read -p "looks good? going to switch to new configuration in next step. [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY != "y" ]]; then
  exit 1
fi

sudo nixos-rebuild switch

ip address show

echo ""
echo "find the ip address to login with"
echo ""

default_value=$(ip address show | grep "inet " | awk '{print $2}' | grep -v 127.0.0.1 | sed 's|/[0-9]\+||' | head -n 1)
read -p "enter the correct ip address. [$default_value]" ip_address
ip_address=${ip_address:-"$default_value"}

echo ""
echo "connect via ssh with:"
echo ""
echo "    $ ssh root@$ip_address"
echo ""
