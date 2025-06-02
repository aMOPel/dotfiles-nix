{
  pkgs_latest,
  pkgs_for_nvim,
  pkgs,
  lib,
  home-manager,
  hmlib,
  ...
}:
let
  device = "/dev/disk/by-uuid/b7406ebd-2255-4d70-acf2-5a537ea7e82a";
  config-values = import ./config_values.nix;
  yubikey-disc-encryption = import ../../yubikey-disc-encryption.nix { inherit device; };
in
# udev-rule = import ../../../keyboard-layout/udev.nix { inherit pkgs; };
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../yubikey-support.nix
    home-manager.nixosModules.home-manager
    # udev-rule
    yubikey-disc-encryption
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    backupFileExtension = "backup";
    users."${config-values.username}" = ../../../home-manager/home.nix;
    extraSpecialArgs = {
      inherit pkgs_for_nvim pkgs_latest hmlib;
      config-values-path = ./config_values.nix;
    };
  };

  services.gnome.gnome-keyring.enable = lib.mkForce false;
  networking.hostName = config-values.nixos.hostname;

  programs.ssh.knownHosts = config-values.nixos.knownHosts;

  users.users."${config-values.username}" = {
    isNormalUser = true;
    extraGroups = [
      # "audio"
      # "cups"
      "docker"
      # "input"
      "libvirtd"
      # "lp"
      # "video"
      "wheel"
      # "wireshark"
    ];
  };
}
