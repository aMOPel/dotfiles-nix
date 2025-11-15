{
  pkgs,
  git-hooks-nix,
  gitignore-nix,
  global-treefmt,
  system,
}:
let
  dotenv_linter = {
    enable = true;
    name = "dotenv-linter";
    entry = "dotenv-linter";
    args = [
      "--quiet"
      "--no-color"
    ];
    extraPackages = with pkgs; [
      dotenv-linter
    ];
    files = "^\\.env$|^\\.env\\..+$";
    language = "system";
    pass_filenames = true;
    stages = [ "pre-commit" ];
  };

  enable = {
    enable = true;
  };
in
{
  pre-commit-check = git-hooks-nix.lib.${system}.run {
    src = gitignore-nix.gitignoreSource ../.;
    # If your hooks are intrusive, avoid running on each commit with a default_states like this:
    # default_stages = ["manual" "push"];
    hooks = {
      inherit
        dotenv_linter
        ;

      check-added-large-files = enable;
      check-case-conflicts = enable;
      check-executables-have-shebangs = enable;
      check-merge-conflicts = enable;
      check-shebang-scripts-are-executable = enable;
      check-symlinks = enable;
      check-vcs-permalinks = enable;
      detect-private-keys = enable;
      forbid-new-submodules = enable;
      no-commit-to-branch = {
        enable = true;
        settings = {
          branch = [
            "main"
          ];
        };
      };
      # trim-trailing-whitespace = {
      #   enable = true;
      # };
      # mixed-line-endings = {
      #   enable = true;
      # };
      # end-of-file-fixer = {
      #   enable = true;
      # };

      check-xml = enable;
      check-toml = enable;
      check-json = enable;
      check-yaml = enable;

      end-of-file-fixer = enable;
      mixed-line-endings = enable;
      trim-trailing-whitespace = enable;

      editorconfig-checker = enable;
      shellcheck = enable;
      checkmake = enable;
      treefmt = {
        enable = true;
        packageOverrides.treefmt = global-treefmt;
      };
    };
  };

}
