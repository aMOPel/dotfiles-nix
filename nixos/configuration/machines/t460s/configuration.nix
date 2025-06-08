{
  pkgs_latest,
  pkgs_for_nvim,
  pkgs,
  home-manager,
  lib,
  hmlib,
  ...
}:
let
  device = "/dev/disk/by-uuid/d3895f9e-d91a-4f79-a994-89c2e6ce54a4";
  config-values = import ./config_values.nix;
in
# udev-rule = import ../../../keyboard-layout/udev.nix { inherit pkgs; };
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../yubikey-support.nix
    home-manager.nixosModules.home-manager
    # udev-rule
    ../../yubikey-disc-encryption.nix
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

  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;
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
