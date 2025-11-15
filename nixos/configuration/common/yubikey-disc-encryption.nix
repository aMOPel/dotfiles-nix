{ device }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd = {
    systemd.enable = true;
    luks.devices.cryptdisk = {
      crypttabExtraOpts = [ "fido2-device=auto" ];
      device = device;
    };
  };
}
