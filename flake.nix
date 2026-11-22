{
  inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";
    ref = "release-26.05";
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
    ref = "nixos-26.05";
    owner = "NixOS";
    repo = "nixpkgs";
    type = "github";
  };

  inputs."treefmt-nix" = {
    owner = "numtide";
    repo = "treefmt-nix";
    type = "github";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs."disko-nix" = {
    ref = "v1.13.0";
    owner = "nix-community";
    repo = "disko";
    type = "github";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.git-hooks-nix = {
    type = "github";
    owner = "cachix";
    repo = "git-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      treefmt-nix,
      git-hooks-nix,
      sops-nix,
      disko-nix,
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
          nixosConfiguration = machinesPath + "/${hostname}/configuration.nix";
          system = config_values.nixos.system;
        in
        (nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = makeInputsForSystem inputs system;
          modules = [ nixosConfiguration ];
        });

      overlays = [
        (
          self: super:
          let
            global-treefmt = (
              super.callPackage ./lib/global-treefmt.nix {
                inherit treefmt-nix;
              }
            );
          in
          {
            inherit
              treefmt-nix
              git-hooks-nix
              global-treefmt
              sops-nix
              disko-nix
              ;
          }
        )
      ];

      config = {
        allowUnfree = true;
      };

      makeInputsForSystem =
        prev_inputs: system:
        (
          prev_inputs
          // rec {
            pkgs = import prev_inputs.nixpkgs { inherit system overlays config; };
            pkgs_latest = import prev_inputs.nixpkgs_latest { inherit system overlays config; };
            pkgs_for_nvim = import prev_inputs.nixpkgs_for_nvim { inherit system overlays config; };
            lib = prev_inputs.nixpkgs.lib;
            hmlib = import "${prev_inputs.home-manager}/modules/lib" { inherit lib; };
          }
        );
    in
    {
      inherit nixosConfigurations;
    }
    // (
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system overlays config; };
        scripts = pkgs.callPackage ./nixos/scripts { };
        pre-commit = pkgs.callPackage ./lib/pre-commit.nix { };
      in
      {
        packages.${system} = {
        }
        // scripts;
        devShells.${system} = {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              gnumake
              git-crypt
              sops
            ];
            shellHook = ''
              ${pre-commit.pre-commit-check.shellHook}
            '';
            buildInputs =
              # filter default treefmt package, so it doesn't override global
              builtins.filter (e: e.name != "treefmt") pre-commit.pre-commit-check.enabledPackages;
          };
          hmShell = pkgs.mkShellNoCC {
            packages = [
              home-manager.packages."${system}".home-manager
            ];
          };
        };
      }
    );
}
