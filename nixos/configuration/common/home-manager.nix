{
  config,
  lib,
  config-values,
  pkgs-for-nvim,
  pkgs-latest,
  home-manager,
  ...
}:
let
  name = "home-manager";
  cfg = config.myModules.${name};
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  options.myModules.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = false;
      backupFileExtension = "backup";
      users."${config-values.username}" = ../../../home-manager;
      extraSpecialArgs = {
        inherit
          pkgs-for-nvim
          pkgs-latest
          config-values
          ;
      };
    };
  };
}
