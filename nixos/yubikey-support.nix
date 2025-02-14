{
  pkgs,
  ...
}:
{
  # TODO: seems to be broken
  # programs.yubikey-touch-detector.enable = true;

  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.systemPackages = with pkgs; [
    yubikey-manager
  ];
}

# WARN: beware of the conflict between pcscd and gpg's scdaemon,
# use in home manager:
# programs.gpg = {
#   scdaemonSettings = {
#     disable-ccid = true;
#   };
# }

# NOTE: reference
# https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html
# https://nixos.wiki/wiki/Yubikey
# https://github.com/drduh/YubiKey-Guide
