{
  config,
  lib,
  pkgs,
  pkgs_latest,
  ...
}:
let
  cfg = config.myModules.git;
in
{
  options.myModules.git = {
    enable = lib.mkEnableOption "git";
    enableLazygit = lib.mkEnableOption "lazygit";

    globalUserName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = ''"foo"'';
      description = "global git config user name";
    };
    globalUserEmail = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = ''"foo@foo.foo"'';
      description = "global git config user email";
    };
    conditionalConfig = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      example = ''
        [
          {
            ifRemoteIsHost = "<host>";
            contents = {
              user = {
                email = git.userEmail;
                name = git.userName;
                signingKey = "<key fingerprint>";
              };
              commit = {
                gpgSign = true;
              };
            };
          };
        ]
      '';
      description = ''
        add settings conditionally, if repos remote is host, see
        https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.includes._.contents
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.globalUserName;
      userEmail = cfg.globalUserEmail;
      includes = lib.lists.flatten (
        builtins.map (value: [
          {
            condition = "hasconfig:remote.*.url:git@${value.ifRemoteIsHost}:*/**";
            contents = value.contents;
          }
          {
            condition = "hasconfig:remote.*.url:https://${value.ifRemoteIsHost}/**";
            contents = value.contents;
          }
        ]) cfg.conditionalConfig
      );
      lfs = {
        enable = true;
      };
      ignores = [
        ".nvim.lua"
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

    home.packages = with pkgs; [
      git-crypt
      git-bug
    ];
  };

}
