{
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../../../keyboard-layout/udev.nix
  ];

  myModules.common-configuration.enable = true;
  myModules.yubikey-support.enable = true;
  myModules.yubikey-disc-encryption.enable = true;
  myModules.udev-rule-for-via.enable = false;
  myModules.home-manager.enable = true;

  boot.loader.timeout = 15;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  hardware.bluetooth.enable = true;
  # trust homelab-one root cert on this machine
  security.pki.certificateFiles = [
    ../homelab-one/certificates/root-ca.crt
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
