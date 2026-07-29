{
  pkgs_latest,
  pkgs_for_nvim,
  pkgs,
  lib,
  sops-nix,
  home-manager,
  hmlib,
  ...
}:
let
  config-values = import ./config_values.nix;
  yubikey-disc-encryption = import ../../common/yubikey-disc-encryption.nix {
    device = config-values.nixos.luksDiskPath;
  };
in
# udev-rule = import ../../../keyboard-layout/udev.nix { inherit pkgs; };
{
  imports = [
    ./hardware-configuration.nix
    ../../common/common.nix
    ../../common/yubikey-support.nix
    ./remote-builders.nix
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops
    # udev-rule
    yubikey-disc-encryption
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    backupFileExtension = "backup";
    users."${config-values.username}" = ../../../../home-manager/home.nix;
    extraSpecialArgs = {
      inherit pkgs_for_nvim pkgs_latest hmlib;
      config-values-path = ./config_values.nix;
    };
  };

  sops.age.sshKeyPaths = [ ];
  sops.gnupg.sshKeyPaths = [ ];
  sops.age.generateKey = false;
  sops.gnupg.home = "/home/${config-values.username}/.gnupg";

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
    gcc-unwrapped
  ];

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
