{
  pkgs,
  ...
}:
let
  udev-rule = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "udev-rule-for-via";
    version = "2025-10-02";
    src = ./udev-rule;
    installPhase = ''
      cp -r . $out
    '';
  });
in
{
  services.udev.packages = [
    udev-rule
  ];
}
