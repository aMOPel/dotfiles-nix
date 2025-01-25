{ pkgs, pkgs_latest, ... }:
{
  home.packages = with pkgs; [
    ffmpegthumbnailer
    p7zip
    poppler_utils
    imagemagick
    mediainfo
    mpv
  ];

  home.sessionVariables = { };

  # programs.bash = {
  #   bashrcExtra = ''
  #     function y() {
  #       local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  #       yazi "$@" --cwd-file="$tmp"
  #       if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
  #         builtin cd -- "$cwd"
  #       fi
  #       rm -f -- "$tmp"
  #     }
  #
  #     alias ya=yazi
  #   '';
  # };

  programs.yazi = {
    enable = true;
    package = pkgs_latest.yazi;

    enableBashIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./settings.toml);
    keymap = builtins.fromTOML (builtins.readFile ./keymaps.toml);
    theme = builtins.fromTOML (builtins.readFile ./theme.toml);
  };
}
