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
    ];
  };
  xdg.configFile =
    {
      "ranger/commands.py".text = builtins.readFile ./commands.py;
      "ranger/rc.conf".text = builtins.readFile ./rc.conf;
      "ranger/rifle.conf".text = builtins.readFile ./rifle.conf;
      "ranger/scope.sh".text = builtins.readFile ./scope.sh;
    };
}
