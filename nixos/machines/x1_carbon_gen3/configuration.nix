{
  nixpkgs,
  home-manager,
  pkgs_latest,
  pkgs_nvim,
  nixpkgs_nixos,
  hmlib,
  ...
}:
let
  device = "/dev/disk/by-uuid/b7406ebd-2255-4d70-acf2-5a537ea7e82a";
  config-values = import ./config_values.nix;
  yubikey-disc-encryption = import ../../yubikey-disc-encryption.nix { inherit device; };
  yubikey-support = import ../../yubikey-support.nix { pkgs = nixpkgs_nixos; };
in
# udev-rule = import ../../../keyboard-layout/udev.nix { pkgs = nixpkgs_nixos; };
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    # udev-rule
    yubikey-support
    yubikey-disc-encryption
  ];

  # home-manager = {
  #   useGlobalPkgs = false;
  #   useUserPackages = false;
  #   backupFileExtension = "backup";
  #   users."${config-values.username}" = import ../../../home-manager/home.nix {
  #     config-values-path = ./config_values.nix;
  #   };
  # };

  services.gnome.gnome-keyring.enable = nixpkgs_nixos.lib.mkForce false;
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
