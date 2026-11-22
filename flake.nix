{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-for-nvim.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-latest.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko-nix = {
      url = "github:nix-community/disko/v1.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      treefmt-nix,
      git-hooks-nix,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      machinesPath = ./nixos/configuration/machines;
      system = "x86_64-linux";

      makeSpecialArgs =
        prevInputs: system:
        (
          prevInputs
          // {
            pkgs-latest = import prevInputs.nixpkgs-latest { inherit system config; };
            pkgs-for-nvim = import prevInputs.nixpkgs-for-nvim { inherit system config; };
            lib = prevInputs.nixpkgs.lib;
          }
        );

      makeNixosConfiguration =
        hostname:
        let
          config_values = import (machinesPath + "/${hostname}/config_values.nix");
          nixosConfiguration = machinesPath + "/${hostname}/configuration.nix";
          system = config_values.nixos.system;
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = makeSpecialArgs inputs system;
          modules = [
            nixosConfiguration
            {
              nixpkgs = {
                inherit overlays config;
                hostPlatform = system;
              };
            }
          ];
        };

      overlays = [
        (_: super: {
          global-treefmt = super.callPackage ./lib/global-treefmt.nix {
            inherit treefmt-nix;
          };
        })
      ];

      config = {
        allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "cmp-calc"
            "cmp-emoji"
            "cmp-fuzzy-path"
          ];
      };

      pkgs = import nixpkgs { inherit system overlays config; };
      scripts = pkgs.callPackage ./nixos/scripts { };
      pre-commit = pkgs.callPackage ./lib/pre-commit.nix { inherit git-hooks-nix; };
    in
    {
      nixosConfigurations = builtins.mapAttrs (key: _: makeNixosConfiguration key) (
        lib.filterAttrs (_: type: type == "directory") (builtins.readDir machinesPath)
      );
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
          nativeBuildInputs =
            # filter default treefmt package, so it doesn't override global
            builtins.filter (
              pkg:
              builtins.elem (lib.getName pkg) [
                "treefmt"
              ]
            ) pre-commit.pre-commit-check.enabledPackages;
        };
        hmShell = pkgs.mkShellNoCC {
          packages = [
            home-manager.packages."${system}".home-manager
          ];
        };
      };
    };
}
