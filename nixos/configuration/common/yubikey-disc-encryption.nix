{
  config,
  lib,
  config-values,
  ...
}:
let
  name = "yubikey-disc-encryption";
  cfg = config.myModules.${name};
in
{
  options.myModules.${name} = {
    enable = lib.mkEnableOption name;
    device = lib.mkOption {
      type = lib.types.str;
      default = [ ];
      example = "/dev/disk/by-uuid/...";
      description = "path to device";
    };
  };

  config = lib.mkIf cfg.enable {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd = {
      systemd.enable = true;
      luks.devices.cryptdisk = {
        crypttabExtraOpts = [ "fido2-device=auto" ];
        device = config-values.nixos.luksDiskPath;
      };
    };
  };
}
