{
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../common
  ];

  myModules.common-configuration.enable = true;
  myModules.yubikey-support.enable = true;
  myModules.yubikey-disc-encryption.enable = true;
  myModules.home-manager.enable = true;
}
