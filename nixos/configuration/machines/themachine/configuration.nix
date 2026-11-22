{
  pkgs-latest,
  pkgs-for-nvim,
  lib,
  home-manager,
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
    home-manager.nixosModules.home-manager
    # udev-rule
    yubikey-disc-encryption
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    backupFileExtension = "backup";
    users."${config-values.username}" = ../../../../home-manager/home.nix;
    extraSpecialArgs = {
      inherit pkgs-for-nvim pkgs-latest;
      config-values-path = ./config_values.nix;
    };
  };

  boot.loader.timeout = 15;

  services.gnome.gnome-keyring.enable = lib.mkForce false;
  networking.hostName = config-values.nixos.hostname;

  programs.ssh.knownHosts = config-values.nixos.knownHosts;

  hardware.bluetooth.enable = true;

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

  # trust homelab-one root cert on this machine
  security.pki.certificateFiles = [
    ../homelab-one/certificates/root-ca.crt
  ];

}
