{ pkgs, pkgs_latest, ... }:
# TODO:
# find a way to make xdg-open work with home manager on ubuntu
# bulk rename in neovim broken, since <c-v> seems to equal <enter>
# mount.yazi needs newer yazi version
# extract doesn't work
# need to add sudo mappings
let
  # official-plugins = pkgs.fetchFromGitHub {
  #   owner = "yazi-rs";
  #   repo = "plugins";
  #   rev = "8f1d9711bcd0e48af1fcb4153c16d24da76e732d";
  #   sha256 = "";
  # };

  # patched-official-plugins = pkgs.stdenv.mkDerivation (finalAttrs: {
  #   pname = "yazi-rs-plugins-patched";
  #   version = "2025-01-26";
  #
  #   src = official-plugins;
  #
  #   installPhase = ''
  #     rm ./sudo-demo.yazi/init.lua
  #     cp ${./sudo.lua} ./sudo-demo.yazi/init.lua
  #     cp -r . $out
  #   '';
  # });

  # my-sudo-demo = pkgs.stdenv.mkDerivation (finalAttrs: {
  #   pname = "my-sudo-demo";
  #   version = "2025-03-02";
  #   src = ./sudo-demo.yazi;
  #
  #   installPhase = ''
  #     cp -r . $out
  #   '';
  # });

  # relative-motions = pkgs.fetchFromGitHub {
  #   owner = "dedukun";
  #   repo = "relative-motions.yazi";
  #   rev = "df97039a04595a40a11024f321a865b3e9af5092";
  #   sha256 = "sha256-csX8T2a5f7k6g2mlR+08rm0qBeWdI4ABuja+klIvwqw=";
  # };
  # compress = pkgs.fetchFromGitHub {
  #   owner = "KKV9";
  #   repo = "compress.yazi";
  #   rev = "60b24af23d1050f1700953a367dd4a2990ee51aa";
  #   sha256 = "sha256-Yf5R3H8t6cJBMan8FSpK3BDSG5UnGlypKSMOi0ZFqzE=";
  # };
  # copy-file-contents = pkgs.fetchFromGitHub {
  #   owner = "AnirudhG07";
  #   repo = "plugins-yazi";
  #   rev = "52ee2bacc344ab835ab279d036980ff9b9fe4b21";
  #   sha256 = "sha256-djE0of7Y+IYP6/euAG4uxvZ/ch5aU/PsYBX6MN/km5s=";
  # };
in
# sudo = pkgs.fetchFromGitHub {
#   owner = "TD-sky";
#   repo = "sudo.yazi";
#   rev = "f4030083a8a4d1de66f88a8add27ec47b43b01c6";
#   sha256 = "sha256-IKdDhLzQCWT8mGNnAbjguoIqxQKUO7N5NsHx51erjLk=";
# };
{
  home.packages = with pkgs; [
    ffmpegthumbnailer
    p7zip
    poppler
    imagemagick
    mediainfo
  ];

  home.sessionVariables = {
    YAZI_LOG = "debug";
  };

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

    plugins = with pkgs_latest.yaziPlugins; {
      "smart-enter" = smart-enter;
      # "mount" = "${official-plugins}/mount.yazi";
      "git" = git;
      "chmod" = chmod;
      # "sudo-demo" = my-sudo-demo;
      "relative-motions" = relative-motions;
      # "compress" = compress;
      # "copy-file-contents" = "${copy-file-contents}/copy-file-contents.yazi";
    };
    initLua = ./init.lua;

    enableBashIntegration = true;
    shellWrapperName = "y";
    settings = builtins.fromTOML (builtins.readFile ./yazi.toml);
    keymap = builtins.fromTOML (builtins.readFile ./keymap.toml);
    theme = builtins.fromTOML (builtins.readFile ./theme.toml);
  };
}
