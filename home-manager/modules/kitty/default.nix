{ pkgs, ... }: {

  fonts.fontconfig = {
    enable = true;
  };

  programs.kitty = {
    enable = true;

    font = {
      size = 13;
      package = pkgs.fira-code-nerdfont;
      name = "FiraCode Nerd Font";
    };

    extraConfig =
      builtins.readFile ./colors;

    shellIntegration.mode = "no-cursor";

    settings = {
      font_family = "FiraCode Nerd Font Ret";
      bold_font = "FiraCode Nerd Font Bold";
      italic_font = "FiraCode Nerd Font Light";
      bold_italic_font = "FiraCode Nerd Font Med";
      disable_ligatures = "cursor";
      font_features = "FiraCode-Retina +zero";

      scrollback_lines = "2000";
      scrollback_pager_history_size = "100";
      scrollback_pager = ''bash -c "exec nvim 63<&0 0</dev/null -u NONE -c 'map <silent> q :qa!<CR>' -c 'set shell=bash scrollback=100000 termguicolors laststatus=0 clipboard+=unnamedplus' -c 'autocmd TermEnter * stopinsert' -c 'autocmd TermClose * call cursor(max([0,INPUT_LINE_NUMBER-1])+CURSOR_LINE, CURSOR_COLUMN)' -c 'terminal sed </dev/fd/63 -e \"s/'$'\x1b''']8;;file:[^\]*[\]//g\" && sleep 0.01 && printf \"'$'\x1b''']2;\"'"'';
      wheel_scroll_multiplier = "10.0";
      mouse_hide_wait = "0";

      url_style = "curly";
      open_url_with = "default";
      url_prefixes = "http https file ftp gemini irc gopher mailto news git";
      detect_urls = "yes";

      strip_trailing_spaces = "smart";
      copy_on_select = "no";
      select_by_word_characters = ":@-./_~?&=%+#";
      click_interval = "-1.0";
      focus_follows_mouse = "no";
      pointer_shape_when_grabbed = "arrow";

      enable_audio_bell = "no";
      visual_bell_duration = "0.3";
      window_alert_on_bell = "yes";
      command_on_bell = "none";

      remember_window_size = "yes";
      enabled_layouts = "tall";
      draw_minimal_borders = "yes";
      inactive_text_alpha = "0.9";
      window_border_width = "2";
      window_margin_width = "2";
      window_padding_width = "2";

      tab_bar_edge = "top";
      tab_bar_margin_width = "0";
      tab_bar_margin_height = "5 10";
      tab_bar_style = "powerline";
      tab_separator = ''""'';
      tab_bar_min_tabs = "1";
      tab_switch_strategy = "left";
      tab_title_template = ''"{index}"'';

      background_opacity = "1.0";
      background_image = "none";

      shell = ".";
      editor = ".";
      close_on_child_death = "no";
      update_check_interval = "0";
      startup_session = "none";

      clear_all_shortcuts = "yes";
      kitty_mod = "ctrl+shift";
    };

    keybindings = {
      "kitty_mod+z>plus" = "change_font_size all +2.0";
      "kitty_mod+z>minus" = "change_font_size all -2.0";
      "kitty_mod+z>equal" = "change_font_size all 0";

      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";

      "kitty_mod+k" = "scroll_line_up";
      "kitty_mod+j" = "scroll_line_down";
      "kitty_mod+u" = "scroll_page_up";
      "kitty_mod+d" = "scroll_page_down";
      "kitty_mod+h" = "show_scrollback";

      "kitty_mod+o" = "kitten hints";
      "kitty_mod+f>p" = "kitten hints --type path --program @";
      "kitty_mod+f>f" = "kitten hints --type path --program @";
      "kitty_mod+f>r" = "kitten hints --type path --program cd";
      "kitty_mod+f>l" = "kitten hints --type line --program @";
      "kitty_mod+f>w" = "kitten hints --type word --program @";
      "kitty_mod+f>h" = "kitten hints --type hash --program @";

      "kitty_mod+w>n" = "new_window";
      "kitty_mod+w>c" = "close_window";
      "kitty_mod+w>w" = "next_window";
      "kitty_mod+w>kitty_mod+n" = "new_window";
      "kitty_mod+w>kitty_mod+c" = "close_window";
      "kitty_mod+w>kitty_mod+w" = "next_window";

      "kitty_mod+t>n" = "new_tab";
      "kitty_mod+t>c" = "close_tab";
      "kitty_mod+t>t" = "next_tab";
      "kitty_mod+t>r" = "previous_tab";
      "kitty_mod+t>1" = "goto_tab 1";
      "kitty_mod+t>2" = "goto_tab 2";
      "kitty_mod+t>3" = "goto_tab 3";
      "kitty_mod+t>4" = "goto_tab 4";
      "kitty_mod+t>5" = "goto_tab 5";
      "kitty_mod+t>6" = "goto_tab 6";
      "kitty_mod+t>7" = "goto_tab 7";
      "kitty_mod+t>8" = "goto_tab 8";
      "kitty_mod+t>9" = "goto_tab 9";
      "kitty_mod+t>0" = "goto_tab 10";
      "kitty_mod+t>kitty_mod+n" = "new_tab";
      "kitty_mod+t>kitty_mod+c" = "close_tab";
      "kitty_mod+t>kitty_mod+t" = "next_tab";
      "kitty_mod+t>kitty_mod+r" = "previous_tab";
      "kitty_mod+t>kitty_mod+1" = "goto_tab 1";
      "kitty_mod+t>kitty_mod+2" = "goto_tab 2";
      "kitty_mod+t>kitty_mod+3" = "goto_tab 3";
      "kitty_mod+t>kitty_mod+4" = "goto_tab 4";
      "kitty_mod+t>kitty_mod+5" = "goto_tab 5";
      "kitty_mod+t>kitty_mod+6" = "goto_tab 6";
      "kitty_mod+t>kitty_mod+7" = "goto_tab 7";
      "kitty_mod+t>kitty_mod+8" = "goto_tab 8";
      "kitty_mod+t>kitty_mod+9" = "goto_tab 9";
      "kitty_mod+t>kitty_mod+0" = "goto_tab 10";

    };
  };
}
