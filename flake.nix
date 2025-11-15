{
  inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";
    ref = "release-25.05";
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
    ref = "nixos-25.05";
    owner = "NixOS";
    repo = "nixpkgs";
    type = "github";
  };

  inputs."treefmt-nix" = {
    ref = "6b9214fffbcf3f1e608efa15044431651635ca83";
    owner = "numtide";
    repo = "treefmt-nix";
    type = "github";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.git-hooks-nix = {
    ref = "84255025dee4c8701a99fbff65ac3c9095952f99";
    type = "github";
    owner = "cachix";
    repo = "git-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      treefmt-nix,
      git-hooks-nix,
      ...
    }@inputs:
    let
      machinesPath = ./nixos/configuration/machines;
      nixosConfigurations = builtins.mapAttrs (key: _: makeNixosConfiguration key) (
        builtins.readDir machinesPath
      );
      makeNixosConfiguration =
        hostname:
        let
          config_values = import (machinesPath + "/${hostname}/config_values.nix");
          path = ./nixos/configuration/machines + "/${hostname}/configuration.nix";
          system = config_values.nixos.system;
        in
        (nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = makeInputsForSystem inputs system;
          modules = [ path ];
        });

      nonNixosMachinesPath = ./home-manager/non-nixos-machines;
      nonNixosHmConfigurations =
        let
          hostnames = (builtins.attrNames (builtins.readDir nonNixosMachinesPath));
        in
        builtins.listToAttrs (builtins.map (hostname: makeNonNixosHmConfiguration hostname) hostnames);
      makeNonNixosHmConfiguration = (
        hostname:
        let
          inputs' = makeInputsForSystem inputs system;
          config_values = import (nonNixosMachinesPath + "/${hostname}/config_values.nix");
          system = config_values.nixos.system;
        in
        {
          name = config_values.username;
          value = home-manager.lib.homeManagerConfiguration {
            inherit (inputs') pkgs;
            modules = [ ./home-manager/home.nix ];
            extraSpecialArgs = {
              inherit (inputs') pkgs_latest pkgs_for_nvim hmlib;
              config-values-path = nonNixosMachinesPath + "/${hostname}/config_values.nix";
            };
          };
        }
      );

      overlays = [
        (self: super:
        let
          global-treefmt = self.callPackage ./lib/treefmt.nix { };
        in
        {
          inherit treefmt-nix git-hooks-nix global-treefmt;
        })
      ];

      config = {
        allowUnfree = true;
      };

      makeInputsForSystem =
        prev_inputs: system:
        (
          prev_inputs
          // rec {
            pkgs = import prev_inputs.nixpkgs {
              inherit system overlays config;
            };
            pkgs_latest = import prev_inputs.nixpkgs_latest { inherit system overlays config; };
            pkgs_for_nvim = import prev_inputs.nixpkgs_for_nvim { inherit system overlays config; };
            lib = prev_inputs.nixpkgs.lib;
            hmlib = import "${prev_inputs.home-manager}/modules/lib" { inherit lib; };
          }
        );
    in
    {
      inherit nixosConfigurations;
      # for non nixos systems
      homeConfigurations = nonNixosHmConfigurations;
    }
    // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        scripts = (pkgs.callPackage ./nixos/scripts { }).scripts;
        pre-commit = pkgs.callPackage ./lib/pre-commit.nix { };
      in
      {
        packages = {
        }
        // scripts;
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              gnumake
              git-crypt
            ];
            shellHook = ''
              ${pre-commit.pre-commit-check.shellHook}
            '';
            buildInputs = pre-commit.pre-commit-check.enabledPackages;
          };
          hmShell = pkgs.mkShellNoCC {
            packages = [
              home-manager.packages."${system}".home-manager
            ];
          };
        };
      }
    ));
}
