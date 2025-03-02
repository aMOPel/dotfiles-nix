let
  sources = import ./nix/sources.nix;
  nixpkgs = sources."nixpkgs_nixos";
  pkgs = import nixpkgs { };
in
pkgs.mkShell rec {
  name = "home-manager-shell";

  # home-manager cli
  buildInputs = with pkgs; [
    (import sources.home-manager { inherit pkgs; }).home-manager
  ];

  NIX_PATH = "nixpkgs=${nixpkgs}:home-manager=${sources."home-manager"}";
  HOME_MANAGER_CONFIG = "./home-manager/wrapper-for-non-nixos.nix";
}
