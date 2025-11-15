{ pkgs, pkgs_latest, ... }:
{
  home.packages = with pkgs; [
    bash-completion
    bashInteractive
  ];

  programs.readline = {
    enable = true;
    bindings = {
      "TAB" = "menu-complete";
      # shift tab
      "\\e[Z" = "menu-complete-backward";
    };
    # man readline
    variables = {
      bell-style = "none";
      colored-stats = true;
      completion-ignore-case = true;
      completion-map-case = true;
      menu-complete-display-prefix = true;
      print-completions-horizontally = true;
      show-all-if-ambiguous = true;
      show-all-if-unmodified = true;
      mark-symlinked-directories = true;
      enable-bracketed-paste = true;
      keymap = "vi";
      editing-mode = "vi";
      show-mode-in-prompt = true;
      vi-ins-mode-string = ''\1\e[5 q\2'';
      vi-cmd-mode-string = ''\1\e[2 q\2'';
    };
  };

  # home.file = {
  #   ".local/share/bash/bash_history".text = "";
  # };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # historyFile = ".local/share/bash/bash_history";
    historySize = 10000;
    historyFileSize = 10000;
    historyControl = [
      "ignoredups"
      "erasedups"
    ];
    shellOptions = [
      "autocd"
      "cdspell"
      "dirspell"
      "extglob"
      "dotglob"
      "globstar"
      "histappend"
    ];
    sessionVariables = {
      PROMPT_COMMAND = "history -a; history -c; history -r; $PROMPT_COMMAND";
    };
    initExtra = builtins.readFile ./aliases + builtins.readFile ./prompt;
    # + ''set -o vi'';
  };
}
