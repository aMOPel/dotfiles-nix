{
  config,
  lib,
  pkgs,
  pkgs_latest,
  hmlib,
  ...
}:
let
  cfg = config.myModules.gnome;
in
{
  options.myModules.gnome = {
    enable = lib.mkEnableOption "gnome";
  };

  config = lib.mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/default-applications/terminal" = {
        exec = "kitty";
        exec-arg = "";
      };
      "org/gnome/desktop/wm/keybindings" = {
        activate-window-menu = [ ];
        always-on-top = [ ];
        begin-move = [ ];
        begin-resize = [ ];
        close = [ "<Super>w" ];
        cycle-group = [ ];
        cycle-group-backward = [ ];
        cycle-panels = [ ];
        cycle-panels-backward = [ ];
        cycle-windows = [ ];
        cycle-windows-backward = [ ];
        lower = [ ];
        maximize = [ ];
        maximize-horizontally = [ ];
        maximize-vertically = [ ];
        minimize = [ ];
        move-to-center = [ ];
        move-to-corner-ne = [ ];
        move-to-corner-nw = [ ];
        move-to-corner-se = [ ];
        move-to-corner-sw = [ ];
        move-to-monitor-down = [ ];
        move-to-monitor-left = [ ];
        move-to-monitor-right = [ ];
        move-to-monitor-up = [ ];
        move-to-side-e = [ ];
        move-to-side-n = [ ];
        move-to-side-s = [ ];
        move-to-side-w = [ ];
        move-to-workspace-1 = [ ];
        move-to-workspace-10 = [ ];
        move-to-workspace-11 = [ ];
        move-to-workspace-12 = [ ];
        move-to-workspace-2 = [ ];
        move-to-workspace-3 = [ ];
        move-to-workspace-4 = [ ];
        move-to-workspace-5 = [ ];
        move-to-workspace-6 = [ ];
        move-to-workspace-7 = [ ];
        move-to-workspace-8 = [ ];
        move-to-workspace-9 = [ ];
        move-to-workspace-down = [ ];
        move-to-workspace-last = [ ];
        move-to-workspace-left = [ ];
        move-to-workspace-right = [ ];
        move-to-workspace-up = [ ];
        panel-main-menu = [ ];
        panel-run-dialog = [ ];
        raise = [ ];
        raise-or-lower = [ ];
        set-spew-mark = [ ];
        show-desktop = [ ];
        switch-applications = [ "<Alt>Tab" ];
        switch-applications-backward = [ ];
        switch-group = [ ];
        switch-group-backward = [ ];
        switch-input-source = [ "<Super>l" ];
        switch-input-source-backward = [ ];
        switch-panels = [ ];
        switch-panels-backward = [ ];
        switch-to-workspace-1 = [ ];
        switch-to-workspace-10 = [ ];
        switch-to-workspace-11 = [ ];
        switch-to-workspace-12 = [ ];
        switch-to-workspace-2 = [ ];
        switch-to-workspace-3 = [ ];
        switch-to-workspace-4 = [ ];
        switch-to-workspace-5 = [ ];
        switch-to-workspace-6 = [ ];
        switch-to-workspace-7 = [ ];
        switch-to-workspace-8 = [ ];
        switch-to-workspace-9 = [ ];
        switch-to-workspace-down = [ ];
        switch-to-workspace-last = [ ];
        switch-to-workspace-left = [ ];
        switch-to-workspace-right = [ ];
        switch-to-workspace-up = [ ];
        switch-windows = [ "<Super>space" ];
        switch-windows-backward = [ ];
        toggle-above = [ ];
        toggle-fullscreen = [ ];
        toggle-maximized = [ "<Super>m" ];
        toggle-on-all-workspaces = [ ];
        unmaximize = [ ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kitty";
        name = "kitty";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>b";
        command = "brave";
        name = "brave-browser";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
        battery-status = [ ];
        battery-status-static = [ "XF86Battery" ];
        calculator = [ ];
        calculator-static = [ "XF86Calculator" ];
        control-center = [ ];
        control-center-static = [ "XF86Tools" ];
        decrease-text-size = [ ];
        eject = [ ];
        eject-static = [ "XF86Eject" ];
        email = [ ];
        email-static = [ "XF86Mail" ];
        help = [ "<Super>F1" ];
        hibernate = [ ];
        hibernate-static = [
          "XF86Suspend"
          "XF86Hibernate"
        ];
        home = [ ];
        home-static = [ "XF86Explorer" ];
        increase-text-size = [ ];
        keyboard-brightness-down = [ ];
        keyboard-brightness-down-static = [ "XF86KbdBrightnessDown" ];
        keyboard-brightness-toggle = [ ];
        keyboard-brightness-toggle-static = [ "XF86KbdLightOnOff" ];
        keyboard-brightness-up = [ ];
        keyboard-brightness-up-static = [ "XF86KbdBrightnessUp" ];
        logout = [ ];
        magnifier = [ ];
        magnifier-zoom-in = [ ];
        magnifier-zoom-out = [ ];
        media = [ ];
        media-static = [ "XF86AudioMedia" ];
        mic-mute = [ ];
        mic-mute-static = [ "XF86AudioMicMute" ];
        next = [ ];
        next-static = [
          "XF86AudioNext"
          "<Ctrl>XF86AudioNext"
        ];
        on-screen-keyboard = [ ];
        pause = [ ];
        pause-static = [ "XF86AudioPause" ];
        play = [ ];
        play-static = [
          "XF86AudioPlay"
          "<Ctrl>XF86AudioPlay"
        ];
        playback-forward = [ ];
        playback-forward-static = [ "XF86AudioForward" ];
        playback-random = [ ];
        playback-random-static = [ "XF86AudioRandomPlay" ];
        playback-repeat = [ ];
        playback-repeat-static = [ "XF86AudioRepeat" ];
        playback-rewind = [ ];
        playback-rewind-static = [ "XF86AudioRewind" ];
        power = [ ];
        power-static = [ "XF86PowerOff" ];
        previous = [ ];
        previous-static = [
          "XF86AudioPrev"
          "<Ctrl>XF86AudioPrev"
        ];
        rfkill = [ ];
        rfkill-bluetooth = [ ];
        rfkill-bluetooth-static = [ "XF86Bluetooth" ];
        rfkill-static = [
          "XF86WLAN"
          "XF86UWB"
          "XF86RFKill"
        ];
        rotate-video-lock = [ ];
        rotate-video-lock-static = [ "XF86RotationLockToggle" ];
        screen-brightness-cycle = [ ];
        screen-brightness-cycle-static = [ "XF86MonBrightnessCycle" ];
        screen-brightness-down = [ ];
        screen-brightness-down-static = [ "XF86MonBrightnessDown" ];
        screen-brightness-up = [ ];
        screen-brightness-up-static = [ "XF86MonBrightnessUp" ];
        screenreader = [ ];
        screensaver = [ ];
        screensaver-static = [ "XF86ScreenSaver" ];
        search = [ ];
        search-static = [ "XF86Search" ];
        stop = [ ];
        stop-static = [ "XF86AudioStop" ];
        suspend = [ ];
        suspend-static = [ "XF86Sleep" ];
        toggle-contrast = [ ];
        touchpad-off = [ ];
        touchpad-off-static = [ "XF86TouchpadOff" ];
        touchpad-on = [ ];
        touchpad-on-static = [ "XF86TouchpadOn" ];
        touchpad-toggle = [ ];
        touchpad-toggle-static = [
          "XF86TouchpadToggle"
          "<Ctrl><Super>XF86TouchpadToggle"
        ];
        volume-down = [ ];
        volume-down-precise = [ ];
        volume-down-precise-static = [
          "<Shift>XF86AudioLowerVolume"
          "<Ctrl><Shift>XF86AudioLowerVolume"
        ];
        volume-down-quiet = [ ];
        volume-down-quiet-static = [
          "<Alt>XF86AudioLowerVolume"
          "<Alt><Ctrl>XF86AudioLowerVolume"
        ];
        volume-down-static = [
          "XF86AudioLowerVolume"
          "<Ctrl>XF86AudioLowerVolume"
        ];
        volume-mute = [ ];
        volume-mute-quiet = [ ];
        volume-mute-quiet-static = [ "<Alt>XF86AudioMute" ];
        volume-mute-static = [ "XF86AudioMute" ];
        volume-up = [ ];
        volume-up-precise = [ ];
        volume-up-precise-static = [
          "<Shift>XF86AudioRaiseVolume"
          "<Ctrl><Shift>XF86AudioRaiseVolume"
        ];
        volume-up-quiet = [ ];
        volume-up-quiet-static = [
          "<Alt>XF86AudioRaiseVolume"
          "<Alt><Ctrl>XF86AudioRaiseVolume"
        ];
        volume-up-static = [
          "XF86AudioRaiseVolume"
          "<Ctrl>XF86AudioRaiseVolume"
        ];
        www = [ ];
        www-static = [ "XF86WWW" ];
      };
      "org/gnome/shell/keybindings" = {
        focus-active-notification = [ ];
        open-new-window-application-1 = [ ];
        open-new-window-application-2 = [ ];
        open-new-window-application-3 = [ ];
        open-new-window-application-4 = [ ];
        open-new-window-application-5 = [ ];
        open-new-window-application-6 = [ ];
        open-new-window-application-7 = [ ];
        open-new-window-application-8 = [ ];
        open-new-window-application-9 = [ ];
        screenshot = [ ];
        screenshot-window = [ ];
        shift-overview-down = [ ];
        shift-overview-up = [ ];
        show-screen-recording-ui = [ ];
        show-screenshot-ui = [ "Print" ];
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        switch-to-application-5 = [ ];
        switch-to-application-6 = [ ];
        switch-to-application-7 = [ ];
        switch-to-application-8 = [ ];
        switch-to-application-9 = [ ];
        toggle-application-view = [ ];
        toggle-message-tray = [ ];
        toggle-overview = [ ];
        toggle-quick-settings = [ ];
      };
      "org/gnome/desktop/interface" = {
        accent-color = "teal";
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/input-sources" = {
        sources = [
          (hmlib.gvariant.mkTuple [
            "xkb"
            "us"
          ])
          (hmlib.gvariant.mkTuple [
            "xkb"
            "de"
          ])
        ];
      };
    };
  };
}
