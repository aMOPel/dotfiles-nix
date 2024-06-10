let
  sources = import ./nix/sources.nix;
  nixpkgs = sources."nixpkgs";
  pkgs = import nixpkgs { };
  hm = import sources.home-manager { inherit pkgs; };
in
{
  install = hm.install;
}
