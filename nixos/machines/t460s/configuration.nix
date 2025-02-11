let
  device = "/dev/disk/by-uuid/d3895f9e-d91a-4f79-a994-89c2e6ce54a4";
  personal-info = import ../../../personal_info.nix;
  sources = import ../../../nix/sources.nix;
  pkgs = import sources."nixpkgs_nixos" { };
  hm = import sources.home-manager { inherit pkgs; };
  yubikey-disc-encryption = import ../../yubikey-disc-encryption.nix { inherit device; };
  udev-rule = import ../../../keyboard-layout/udev.nix { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    hm.nixos
    udev-rule
    yubikey-disc-encryption
  ];

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = false;
    users."${personal-info.username}" = import ../../../home-manager/home.nix;
  };

  networking.hostName = personal-info.nixos.hostname;

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
