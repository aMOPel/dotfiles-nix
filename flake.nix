{
  inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";
    ref = "release-24.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs."nixpkgs_for_nvim" = {
    ref = "nixos-unstable";
    owner = "NixOS";
    repo = "nixpkgs";
    type = "github";
  };

  inputs."nixpkgs_latest" = {
    ref = "nixos-unstable";
    owner = "NixOS";
    repo = "nixpkgs";
    type = "github";
  };

  inputs."nixpkgs" = {
    ref = "nixos-24.11";
    owner = "NixOS";
    repo = "nixpkgs";
    type = "github";
  };

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    let
      machinesPath = ./nixos/configuration/machines;
      machineConfigs = builtins.mapAttrs (
        key: value:
        let
          config_values = import (machinesPath + "/${key}/config_values.nix");
        in
        rec {
          inherit (config_values.nixos) system hostname;
          path = ./nixos/configuration/machines + "/${hostname}/configuration.nix";
        }
      ) (builtins.readDir machinesPath);
      makeInputsForSystem =
        prev_inputs: system:
        (
          prev_inputs
          // rec {
            pkgs = import prev_inputs.nixpkgs { inherit system; };
            pkgs_latest = import prev_inputs.nixpkgs_latest { inherit system; };
            pkgs_for_nvim = import prev_inputs.nixpkgs_for_nvim { inherit system; };
            lib = prev_inputs.nixpkgs.lib;
            hmlib = import "${prev_inputs.home-manager}/modules/lib" { inherit lib; };
          }
        );
      makeNixosConfigurations = (
        with nixpkgs.lib.attrsets;
        configs:
        mapAttrs' (
          _: machineConfig:
          nameValuePair machineConfig.hostname (
            nixpkgs.lib.nixosSystem {
              system = machineConfig.system;
              specialArgs = makeInputsForSystem inputs machineConfig.system;
              modules = [ machineConfig.path ];
            }
          )
        ) configs
      );
    in
    {
      nixosConfigurations = makeNixosConfigurations machineConfigs;
    }
    // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        scripts = (pkgs.callPackage ./nixos/scripts { }).scripts;
      in
      {
        packages = {
        } // scripts;
        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            gnumake
          ];
        };
      }
    ));
}
