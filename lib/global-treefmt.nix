{
  treefmt-nix,
  pkgs,
}:
let

  enable = { enable = true; };

  global-treefmt = treefmt-nix.mkWrapper pkgs {
    package = pkgs.treefmt;
    projectRootFile = ".git/config";
    programs = {
      deno = enable;
      clang-format = enable;
      nixfmt = enable;
      gdformat = enable;
      gofumpt = enable;
      stylua = enable;
      black = enable;
      isort = enable;
      rustfmt = enable;
      shfmt = enable;
      dockfmt = enable;
      taplo = enable;
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
      nixfmt.includes = [ "*.nix" ];
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
global-treefmt
