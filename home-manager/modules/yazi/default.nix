{ pkgs, pkgs_latest, ... }:
# TODO:
# find a way to make xdg-open work with home manager on ubuntu
# bulk rename in neovim broken, since <c-v> seems to equal <enter>
# extract doesn't work
# need to add sudo mappings
# sudo plugin rename broken
let
  # my-sudo-demo = pkgs.stdenv.mkDerivation (finalAttrs: {
  #   pname = "my-sudo-demo";
  #   version = "2025-03-02";
  #   src = ./sudo-demo.yazi;
  #
  #   installPhase = ''
  #     cp -r . $out
  #   '';
  # });

  # sudo = pkgs.fetchFromGitHub {
  #   owner = "TD-sky";
  #   repo = "sudo.yazi";
  #   rev = "f4030083a8a4d1de66f88a8add27ec47b43b01c6";
  #   sha256 = "sha256-IKdDhLzQCWT8mGNnAbjguoIqxQKUO7N5NsHx51erjLk=";
  # };
  cd-git-root = pkgs.fetchFromGitHub {
    owner = "ciarandg";
    repo = "cd-git-root.yazi";
    rev = "a0e0f4bef420c392f599569dda770f1827569855";
    sha256 = "sha256-W2ByLHTFN8aMv1d3UfS7FfU7hkKU97rIKWJAHPyKLy0=";
  };
  copy-file-contents = pkgs.fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "plugins-yazi";
    rev = "71545f4ee1a0896c555b3118dc3d2b0a1b92fad9";
    sha256 = "sha256-JsQJg/SfXLQ/JIpl2YsfzdGpS1ZeWIACJwWTpHaVH3w=";
  };
in
{
  home.packages = with pkgs; [
    ffmpegthumbnailer
    p7zip
    jq
    fd
    ripgrep
    fzf
    zoxide
    poppler
    resvg
    imagemagick
    mediainfo
  ];

  home.sessionVariables = {
    YAZI_LOG = "debug";
  };

  programs.yazi = {
    enable = true;
    package = pkgs_latest.yazi;

    plugins = with pkgs_latest.yaziPlugins; {
      "smart-enter" = smart-enter;
      "mount" = mount;
      "git" = git;
      "chmod" = chmod;
      # "sudo-demo" = my-sudo-demo;
      "relative-motions" = relative-motions;
      "compress" = compress;
      "copy-file-contents" = "${copy-file-contents}/copy-file-contents.yazi";
      "mediainfo" = mediainfo;
      "cd-git-root" = cd-git-root;
    };
    initLua = ./init.lua;

    enableBashIntegration = true;
    shellWrapperName = "y";
    settings = builtins.fromTOML (builtins.readFile ./yazi.toml);
    keymap = builtins.fromTOML (builtins.readFile ./keymap.toml);
    theme = builtins.fromTOML (builtins.readFile ./theme.toml);
  };
}
