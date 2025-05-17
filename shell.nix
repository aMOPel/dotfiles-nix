let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs_nixos { };
in
pkgs.mkShell {
  packages = with pkgs; [
    niv
    gnumake
  ];
}
