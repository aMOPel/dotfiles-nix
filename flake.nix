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
      machineConfigs = {
        t460s = rec {
          system = "x86_64-linux";
          hostname = "t460s";
          path = ./nixos/configuration/machines + "/${hostname}/configuration.nix";
        };
        x1-carbon = rec {
          system = "x86_64-linux";
          hostname = "x1-carbon";
          path = ./nixos/configuration/machines + "/${hostname}/configuration.nix";
        };
        #### TEMPLATE
        #### INJECT HERE
      };
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
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            gnumake
          ];
        };
      }
    ));
}
