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
      configs = {
        t460s = {
          system = "x86_64-linux";
          hostname = "t460s";
          path = ./machines/t460s;
        };
        x1-carbon = {
          system = "x86_64-linux";
          hostname = "x1-carbon";
          path = ./machines/x1_carbon_gen3;
        };
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
    in
    {
      nixosConfigurations."${configs.t460s.hostname}" = nixpkgs.lib.nixosSystem rec {
        system = configs.t460.system;
        specialArgs = makeInputsForSystem inputs system;
        modules = [ (configs.t460s.path + "/configuration.nix") ];
      };

      nixosConfigurations."${configs.x1-carbon.hostname}" = nixpkgs.lib.nixosSystem rec {
        system = configs.x1-carbon.system;
        specialArgs = makeInputsForSystem inputs system;
        modules = [ (configs.x1-carbon.path + "/configuration.nix") ];
      };
    }
    // (
    # flake-utils.lib.eachDefaultSystem (
    #   system:
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
      {
        devShells."x86_64-linux".default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            niv
            gnumake
          ];
        };
      }
    );
}
