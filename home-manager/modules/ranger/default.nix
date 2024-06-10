{ pkgs, ... }:
let
  sources = import ../../../nix/sources.nix;
in
{
  home.packages = with pkgs; [
    ffmpegthumbnailer
    zathura
    atool
    poppler_utils
    mediainfo
    fd
  ];

  home.sessionVariables = {
    RANGER_LOAD_DEFAULT_RC = "FALSE";
  };

  programs.bash = {
    # mind the `''${ranger_cmd[@]} "$@"` line, `''` escaped the string interpolation
    bashrcExtra = ''
      function ranger {
        local IFS=$'\t\n'
        local tempfile="$(mktemp -t tmp.XXXXXX)"
        local ranger_cmd=(
          command
          ranger
          --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
        )

        ''${ranger_cmd[@]} "$@"
        if [[ -s "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
          command zoxide add "$(cat -- "$tempfile")" && cd -- "$(cat -- "$tempfile")" || return
        fi
        command rm -f -- "$tempfile" 2>/dev/null
      }

      alias r=ranger
    '';
  };

  programs.ranger = {
    enable = true;
    plugins = [
      {
        name = "zoxide";
        src = sources.ranger-zoxide;
      }
      {
        name = "devicons";
        src = sources.ranger-devicons2;
      }
      {
        name = "context.py";
        src = ./plugins/context.py;
      }
    ];
  };

  xdg.configFile =
    {
      "ranger/commands.py".text = builtins.readFile ./commands.py;
      "ranger/rc.conf".text = builtins.readFile ./rc.conf;
      "ranger/rifle.conf".text = builtins.readFile ./rifle.conf;
      "ranger/scope.sh" = {
        executable = true;
        text = builtins.readFile ./scope.sh;
      };
    };
}
