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
      settings = {
        user = {
          name = cfg.globalUserName;
          email = cfg.globalUserEmail;
        };
      };
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
      iniContent = {
        core = {
          pager = "delta";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        delta = {
          # TODO: increase context window (--context-lines) in new delta version
          dark = true;
          right-arrow = "⟶  ";
          syntax-theme = "base16-256";
          # -- git
          commit-decoration-style = "none";
          commit-style = "magenta";
          # -- diff
          keep-plus-minus-markers = false;
          line-numbers = true;
          line-numbers-minus-style = "#4b5263";
          line-numbers-plus-style = "#4b5263";
          line-numbers-left-style = "#4b5263";
          line-numbers-left-format = "{nm:>5}│";
          line-numbers-right-style = "#4b5263";
          line-numbers-right-format = "{np:>5}│";
          line-numbers-zero-style = "#4b5263";
          minus-emph-style = "syntax #542426";
          minus-empty-line-marker-style = "syntax #25171C";
          minus-style = "syntax #25171C";
          plus-emph-style = "syntax #1C4428";
          plus-empty-line-marker-style = "syntax #12261E";
          plus-style = "syntax #12261E";
          whitespace-error-style = "black white";
          zero-style = "syntax";
          # -- decorations
          file-decoration-style = "brightwhite overline";
          file-added-label = "[A]";
          file-copied-label = "[*]";
          file-modified-label = "[M]";
          file-removed-label = "[D]";
          file-renamed-label = "[R]";
          file-style = "brightblack bold";
          hunk-header-style = "omit";
          tabs = 4;
        };
        merge = {
          conflictStyle = "zdiff3";
        };
      };
      lfs = {
        enable = true;
      };
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
      # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
      package = pkgs_latest.lazygit;
      settings = {
        gui = {
          theme = {
            selectedLineBgColor = [ "#4b5263" ]; # one dark gutter grey
            cherryPickedCommitFgColor = [ "cyan" ];
            cherryPickedCommitBgColor = [ "#5c6370" ]; # one dark comment grey
          };
        };
        git = {
          overrideGpg = true;
          autoFetch = false;
          pagers = [
            {
              colorArg = "always";
              pager = "delta --dark --paging=never";
            }
          ];
        };
      };
    };

    home.packages = with pkgs; [
      git-crypt
      git-bug
      pkgs_latest.delta
    ];
  };

}
