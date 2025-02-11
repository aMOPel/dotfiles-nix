let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  packages = with pkgs; [
    niv
    gnumake
  ];
}
