#!/usr/bin/env bash
# shellcheck disable=SC2155,SC2162

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  ./nixos/configuration/machines/homelab-one/partitioning/disko.nix

default_value="y"
read -p "generate nixos config? [$default_value] "
REPLY=${REPLY:-"$default_value"}

if [[ $REPLY == "y" ]]; then
  nixos-generate-config --root /mnt

  echo ""
  ls -l /dev/disk/by-uuid
  echo ""

  # shellcheck disable=SC2010
  default_value=$(ls -l /dev/disk/by-uuid | grep "$(basename /dev/nvme0n1)"p2 | awk '{print $9}')
  read -p "enter uuid of encrypted disk (should point to /dev/nvme0n1p2) [$default_value] " uuid0
  uuid0=${uuid0:-"$default_value"}

  # shellcheck disable=SC2010
  default_value=$(ls -l /dev/disk/by-uuid | grep "$(basename /dev/sda)"1 | awk '{print $9}')
  read -p "enter uuid of encrypted disk (should point to /dev/sda1) [$default_value] " uuid1
  uuid1=${uuid1:-"$default_value"}

  # shellcheck disable=SC2010
  default_value=$(ls -l /dev/disk/by-uuid | grep "$(basename /dev/sdb)"1 | awk '{print $9}')
  read -p "enter uuid of encrypted disk (should point to /dev/sdb1) [$default_value] " uuid1
  uuid2=${uuid2:-"$default_value"}

  default_value="user1"
  read -p "enter username. [$default_value] " username
  username=${username:-"$default_value"}

  default_value="nixos-pc"
  read -p "enter hostname. [$default_value] " hostname
  hostname=${hostname:-"$default_value"}

  # append the lines about disk encryption to the end
  cat <<EOF >/mnt/etc/nixos/configuration.nix
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (\`nixos-help\`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd = {
    systemd.enable=true;
    luks.devices = {
      cryptdisk0 = {
        crypttabExtraOpts = [ "fido2-device=auto" ];
        device = "/dev/disk/by-uuid/${uuid0}";
      };
      cryptdisk1 = {
        crypttabExtraOpts = [ "fido2-device=auto" ];
        device = "/dev/disk/by-uuid/${uuid1}";
      };
      cryptdisk2 = {
        crypttabExtraOpts = [ "fido2-device=auto" ];
        device = "/dev/disk/by-uuid/${uuid2}";
      };
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEPGNQt7xa+8hYGMlGK8lLrhbYaYAin00V0XyWrcq/ImQF7uqWBXf1I09WxCsoFThIUVybgyP0bOXZA9p09c6WrlKEBRr606bMH8KxwXUt5h4lpEpXDP31Qz25zVxGDCC/sfAwP/qmGDjKF2/OeNxnydh/kuq+xTCGaTJ/B5zI3gj/up85HVHYszYQZpfE0UcPjqNwHugQTcNIbs28Gw+NS3BcfrLareIcKboKE3p1q6r5210PxqCiTvksZIIeFaFqhZesMD5Rcln0NWXSYWW6zAcZEKRUFAwNQtCJdOFy60YNBLvju+nLiBDTkYRkfzUkRtNmtmCBL+alxCNqV/K+Fstlbs9lbd8iw2McbpCCSqyU5gIFG+rTTxZZwW6e3nQgNrzfAuwtLVR2A2PMMCURYMzlk6Rhl3fkTNucvntB2+OLNvJJAj6RfmXqhpfJFQgE6RpFpZgYGkISv0VGn+Lya0GYTcdvC+Vajj1mP0JeGnv+TTnBZVrHBGGqth4YZlDw9nvsEuQCw0nTjFwq8++sp63gr/qi/Gav7mlmIzO3KEin3WcySXVOfaEcJaE7phtIuRpY4Ffoam2Rm7VtInj8vOmow6NtRv0+mW04d4NYWe8jkHCsazxYnrjAuNQLK/AL7dYzLS1OSMJqkNlIqcF/VTkFo7hre9aonJRZa929Pw== cardno:32_443_537"
    ];
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  networking.hostName = "${hostname}"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      git
      neovim
      niv
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see \`man configuration.nix\` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
EOF

  default_value="n"
  read -p "edit nixos config with vim? [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  if [[ $REPLY == "y" ]]; then
    vim /mnt/etc/nixos/configuration.nix
  fi

fi

default_value="y"
read -p "install nixos now? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY == "y" ]]; then
  nixos-install
fi

default_value="y"
read -p "reboot now? you should be asked for the yubikey pin at startup. [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ $REPLY == "y" ]]; then
  systemctl reboot
fi
