{ config, lib, ... }:
let
  cfg = config.myModules.git;
in
{
  options.myModules.git = {
    enable = lib.mkEnableOption "git";
    enableLazygit = lib.mkEnableOption "lazygit";

    userName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = ''"foo"'';
      description = "git config user name";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = ''"foo@foo.foo"'';
      description = "git config user email";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      ignores = [
        "Session.vim"
        ".direnv/"
      ];
    };

    programs.bash = {
      shellAliases = {
        g = "lazygit";
      };
    };

    programs.lazygit = lib.mkIf cfg.enableLazygit {
      enable = true;
    };
  };

}
