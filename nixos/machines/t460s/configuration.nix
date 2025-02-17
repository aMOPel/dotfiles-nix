let
  device = "/dev/disk/by-uuid/d3895f9e-d91a-4f79-a994-89c2e6ce54a4";
  personal-info = import ./personal_info.nix;
  sources = import ../../../nix/sources.nix;
  pkgs = import sources."nixpkgs_nixos" { };
  hm = import sources.home-manager { inherit pkgs; };
  yubikey-disc-encryption = import ../../yubikey-disc-encryption.nix { inherit device; };
  yubikey-support = import ../../yubikey-support.nix { inherit pkgs; };
in
# udev-rule = import ../../../keyboard-layout/udev.nix { inherit pkgs; };
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    hm.nixos
    # udev-rule
    yubikey-support
    yubikey-disc-encryption
  ];

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = false;
    backupFileExtension = "backup";
    users."${personal-info.username}" = import ../../../home-manager/home.nix {
      personal-info-path = ./personal_info.nix;
    };
  };

  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;
  networking.hostName = personal-info.nixos.hostname;

  programs.ssh.knownHosts = personal-info.nixos.knownHosts;

  users.users."${personal-info.username}" = {
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
