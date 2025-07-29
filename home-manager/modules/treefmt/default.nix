{
  config,
  pkgs,
  lib,
  ...
}:
let
  treefmt-nix = import pkgs.treefmt-nix;

  cfg = config.myModules.treefmt;

  myTreefmt = treefmt-nix.mkWrapper pkgs {
    package = pkgs.treefmt;
    projectRootFile = ".git/config";
    programs = {
      deno.enable = true;
      clang-format.enable = true;
      nixfmt-rfc-style.enable = true;
      gdformat.enable = true;
      gofumpt.enable = true;
      stylua.enable = true;
      black.enable = true;
      isort.enable = true;
      rustfmt.enable = true;
      shfmt.enable = true;
      dockfmt.enable = true;
      taplo.enable = true;
    };

    settings.formatter = {
      deno.includes = [
        "*.css"
        "*.sass"
        "*.scss"
        "*.less"
        "*.html"
        "*.json"
        "*.jsonc"
        "*.yaml"
        "*.yml"
        "*.md"
        "*.mkd"
        "*.mkdn"
        "*.mdwn"
        "*.mdown"
        "*.markdown"
        "*.js"
        "*.cjs"
        "*.mjs"
        "*.jsx"
        "*.ts"
        "*.mts"
        "*.cts"
        "*.tsx"
      ];
      clang-format.includes = [
        "*.c"
        "*.cc"
        "*.cpp"
        "*.h"
        "*.hh"
        "*.hpp"
        "*.glsl"
        "*.vert"
        ".tesc"
        ".tese"
        ".geom"
        ".frag"
        ".comp"
      ];
      nixfmt-rfc-style.includes = [ "*.nix" ];
      gdformat.includes = [ "*.gd" ];
      gofumpt.includes = [ "*.go" ];
      stylua.includes = [ "*.lua" ];
      black.includes = [
        "*.py"
        "*.py"
      ];
      isort.includes = [
        "*.py"
        "*.pyi"
      ];
      rustfmt.includes = [ "*.rs" ];
      shfmt.includes = [ "*.sh" ];
      dockfmt.includes = [
        "*.sh"
        "*.bash"
        "*.envrc"
        "*.envrc.*"
      ];
      taplo.includes = [ ".toml" ];

    };
  };
in
{
  options.myModules.treefmt = {
    enable = lib.mkEnableOption "treefmt";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      myTreefmt
    ];
  };
}
