{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
    ripgrep
    gh
    glab
    direnv
    hyperfine # benchmarking
    license-cli # generate license
    gibo # generate gitignore
    man
    unzip
    qemu
    xclip
    jq
    yq
    help2man
  ];

  home.sessionVariables = {
    _ZO_RESOLVE_SYMLINKS = "1";
  };

  programs = {

    bat = {
      enable = true;
      config = {
        style = "number,changes,header";
        theme = "base16-256";
      };
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      changeDirWidgetCommand = ''fd --type d'';
      changeDirWidgetOptions = [ ''--preview 'tree -C {}' '' ];
      fileWidgetCommand = ''fd --type f'';
      fileWidgetOptions = [ ''--preview 'bat -n --color=always {}' '' ];
      historyWidgetOptions = [ ''--preview 'echo {}' --preview-window up:3:hidden:wrap'' ];
      colors = {
        "bg+" = "#353b45";
        "bg" = "#282c34";
        "spinner" = "#56b6c2";
        "hl" = "#61afef";
        "fg" = "#565c64";
        "header" = "#61afef";
        "info" = "#e5c07b";
        "pointer" = "#56b6c2";
        "marker" = "#56b6c2";
        "fg+" = "#b6bdca";
        "prompt" = "#e5c07b";
        "hl+" = "#61afef";
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

  };

}
