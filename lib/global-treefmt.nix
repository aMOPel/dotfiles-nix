{
  treefmt-nix,
  treefmt,
  pkgs,
}:
let

  enable = {
    enable = true;
  };

  global-treefmt = treefmt-nix.lib.evalModule pkgs {
    package = treefmt;
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
      deno.excludes = [
        "secrets/*"
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
        "Dockerfile"
        "*.Dockerfile"
        "Dockerfile.*"
      ];
      taplo.includes = [ ".toml" ];

    };
  };

  # https://github.com/numtide/treefmt-nix/blob/790751ff7fd3801feeaf96d7dc416a8d581265ba/module-options.nix#L229
  # NOTE: adapt the wrapper script to use local treefmt.toml if available
  code =
    config:
    # bash
    ''
      set -euo pipefail;
      unset PRJ_ROOT;
      config_file="${config.build.configFile}";
      set +e;
      config_file_git_root="$(git rev-parse --show-toplevel 2>/dev/null)/treefmt.toml";
      set -e;
      if [[ -f "$config_file_git_root" ]]; then
        config_file="$config_file_git_root";
      elif [[ -f "./treefmt.toml" ]]; then
        config_file="./treefmt.toml";
      fi
      echo "INFO: using config $config_file";
      exec ${config.package}/bin/treefmt \
        --config-file="$config_file" \
        --tree-root-file="${config.projectRootFile}" \
        "$@"
    '';
in
pkgs.writeShellScriptBin "treefmt" (code global-treefmt.config)
