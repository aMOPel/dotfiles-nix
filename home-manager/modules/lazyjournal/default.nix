{
  config,
  lib,
  pkgs,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };
  cfg = config.myModules.lazyjournal;
  # https://github.com/Lifailon/lazyjournal/blob/main/config.yml
  lazyjournalConfig = {
    settings = {
      disableMouse = true;
    };
    hotkeys = {
      # NOTE: remapped hotkeys are not displayed in help menu
      # a-z, shift+<a-z>, ctrl+<a-z>, 0-9, f1-f12 and any other symbols
      # tab, shift+tab, enter, space, backspace, del/delete and esc/escape
      help = "?";
      showManager = "m";
      switchWindow = "tab";
      backSwitchWindows = "shift+tab";
      up = "k";
      veryQuickUp = "ctrl+u";
      down = "j";
      veryQuickDown = "ctrl+d";
      left = "h";
      right = "l";
      loadJournal = "enter";
      goToFilter = "/";
      goToEnd = ">";
      goToTop = "<";
      autoUpdateJournal = "shift+R";
      updateJournal = "r";
      updateLists = "ctrl+r";
      exit = "q";

      # unused
      quickUp = "f4";
      switchFilterMode = "f3";
      quickDown = "f2";
      backSwitchFilterMode = "f1";
      disableFilterByDate = "1";
      tailModeMore = "2";
      tailModeLess = "3";
      updateIntervalMore = "4";
      updateIntervalLess = "5";

      colorDisable = "f5";
      tailspinDisable = "f6";
      switchColorMode = "6";
      switchPriority = "7";
      switchDockerMode = "8";
      switchStreamMode = "9";
      timestampShow = "0";
    };
  };
in
{
  options.myModules.lazyjournal = {
    enable = lib.mkEnableOption "lazyjournal";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lazyjournal
    ];
    programs.bash.initExtra = ''
      alias j=lazyjournal;
    '';
    xdg.configFile = {
      "lazyjournal/config.yml" = {
        source = yamlFormat.generate "lazyjournal-config" lazyjournalConfig;
      };
    };
  };
}
