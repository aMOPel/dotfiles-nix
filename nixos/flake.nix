{
  inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";
    ref = "release-24.11";
    rev = "1eec32f0efe3b830927989767a9e6ece0d82d608";
  };

  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs_nixos";

  inputs."nixpkgs" = {
    "ref" = "nixos-unstable";
    "owner" = "NixOS";
    "repo" = "nixpkgs";
    "rev" = "57610d2f8f0937f39dbd72251e9614b1561942d8";
    "type" = "github";
  };

  inputs."nixpkgs_for_nvim" = {
    "ref" = "nixos-unstable";
    "owner" = "NixOS";
    "repo" = "nixpkgs";
    "rev" = "0aa475546ed21629c4f5bbf90e38c846a99ec9e9";
    "type" = "github";
  };

  inputs."nixpkgs_latest" = {
    "ref" = "nixos-unstable";
    "owner" = "NixOS";
    "repo" = "nixpkgs";
    "rev" = "0aa475546ed21629c4f5bbf90e38c846a99ec9e9";
    "type" = "github";
  };

  inputs."nixpkgs_nixos" = {
    "ref" = "nixos-24.11";
    "owner" = "NixOS";
    "repo" = "nixpkgs";
    "rev" = "ba8b70ee098bc5654c459d6a95dfc498b91ff858";
    "type" = "github";
  };

  outputs =
    { self, nixpkgs, home-manager, ... }@attrs:
    let
      configs = {
        t460s = {
          hostname = "t460s";
          path = ./machines/t460s/configuration.nix;
        };
        x1-carbon = {
          hostname = "x1-carbon";
          path = ./machines/x1_carbon_gen3/configuration.nix;
        };
      };
    in
    {
      nixosConfigurations."${configs.t460s.hostname}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [ configs.t460s.path ];
      };
      nixosConfigurations."${configs.x1-carbon.hostname}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [ configs.x1-carbon.path home-manager.nixosModules.home-manager  ];
      };
    };
}
