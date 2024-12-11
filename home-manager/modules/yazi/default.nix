{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpegthumbnailer
    p7zip
    poppler_utils
    imagemagick
    mediainfo
    mpv
  ];

  home.sessionVariables = { };

  programs.yazi = {
    enable = true;

    enableBashIntegration = true;
    shellWrapperName = "y";
    keymap = { };
    theme = { };
    settings = {

      manager = {
        ratio = [
          1
          4
          3
        ];
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        sort_translit = false;
        # TODO:
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
        scrolloff = 5;
        mouse_events = [ ];
        title_format = "Yazi: {cwd}";
      };

      preview = {
        wrap = "no";
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "~/.cache/yazi/previews";
        image_delay = 300;
        image_filter = "triangle";
        image_quality = 75;
        sixel_fraction = 15;
        ueberzug_scale = 1;
        ueberzug_offset = [
          0
          0
          0
          0
        ];
      };

      opener = {
        edit = [
          {
            run = ''${"EDITOR:-vi"} "$@"'';
            desc = "$EDITOR";
            block = true;
            for = "unix";
          }
        ];
        open = [
          {
            run = ''xdg-open "$1"'';
            desc = "Open";
            for = "linux";
          }
        ];
        reveal = [
          {
            run = ''xdg-open "$(dirname "$1")"'';
            desc = "Reveal";
            for = "linux";
          }
          {
            run = ''exiftool "$1"; echo "Press enter to exit"; read _'';
            block = true;
            desc = "Show EXIF";
            for = "unix";
          }
        ];
        extract = [
          {
            run = ''ya pub extract --list "$@"'';
            desc = "Extract here";
            for = "unix";
          }
        ];
        play = [
          {
            run = ''mpv --force-window "$@"'';
            orphan = true;
            for = "unix";
          }
          {
            run = ''mediainfo "$1"; echo "Press enter to exit"; read _'';
            block = true;
            desc = "Show media info";
            for = "unix";
          }
        ];
      };

      open = {
        rules = [
          # Folder
          {
            name = "*/";
            use = [
              "edit"
              "open"
              "reveal"
            ];
          }
          # Text
          {
            mime = "text/*";
            use = [
              "edit"
              "reveal"
            ];
          }
          # Image
          {
            mime = "image/*";
            use = [
              "open"
              "reveal"
            ];
          }
          # Media
          {
            mime = "{audio;video}/*";
            use = [
              "play"
              "reveal"
            ];
          }
          # Archive
          {
            mime = "application/{;g}zip";
            use = [
              "extract"
              "reveal"
            ];
          }
          {
            mime = "application/x-{tar;bzip*;7z-compressed;xz;rar}";
            use = [
              "extract"
              "reveal"
            ];
          }
          # JSON
          {
            mime = "application/{json;x-ndjson}";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            mime = "*/javascript";
            use = [
              "edit"
              "reveal"
            ];
          }
          # Empty file
          {
            mime = "inode/x-empty";
            use = [
              "edit"
              "reveal"
            ];
          }
          # Fallback
          {
            name = "*";
            use = [
              "open"
              "reveal"
            ];
          }
        ];
      };

      tasks = {
        micro_workers = 10;
        macro_workers = 25;
        bizarre_retry = 5;
        image_alloc = 536870912; # 512MB
        image_bound = [
          0
          0
        ];
        suppress_preload = false;
      };

      plugin = {
        fetchers = [
          # Mimetype
          {
            id = "mime";
            name = "*";
            run = "mime";
            "if" = "!mime";
            prio = "high";
          }
        ];
        preloaders = [
          # Image
          {
            mime = "image/{avif;hei?;jxl;svg+xml}";
            run = "magick";
          }
          {
            mime = "image/*";
            run = "image";
          }
          # Video
          {
            mime = "video/*";
            run = "video";
          }
          # PDF
          {
            mime = "application/pdf";
            run = "pdf";
          }
          # Font
          {
            mime = "font/*";
            run = "font";
          }
          {
            mime = "application/vnd.ms-opentype";
            run = "font";
          }
        ];
        previewers = [
          {
            name = "*/";
            run = "folder";
            sync = true;
          }
          # Code
          {
            mime = "text/*";
            run = "code";
          }
          {
            mime = "*/{xml;javascript;x-wine-extension-ini}";
            run = "code";
          }
          # JSON
          {
            mime = "application/{json;x-ndjson}";
            run = "json";
          }
          # Image
          {
            mime = "image/{avif;hei?;jxl;svg+xml}";
            run = "magick";
          }
          {
            mime = "image/*";
            run = "image";
          }
          # Video
          {
            mime = "video/*";
            run = "video";
          }
          # PDF
          {
            mime = "application/pdf";
            run = "pdf";
          }
          # Archive
          {
            mime = "application/{;g}zip";
            run = "archive";
          }
          {
            mime = "application/x-{tar;bzip*;7z-compressed;xz;rar;iso9660-image}";
            run = "archive";
          }
          # Font
          {
            mime = "font/*";
            run = "font";
          }
          {
            mime = "application/vnd.ms-opentype";
            run = "font";
          }
          # Empty file
          {
            mime = "inode/x-empty";
            run = "empty";
          }
          # Fallback
          {
            name = "*";
            run = "file";
          }
        ];
      };

      input = {
        cursor_blink = false;

        # cd
        cd_title = "Change directory:";
        cd_origin = "top-center";
        cd_offset = [
          0
          2
          50
          3
        ];

        # create
        create_title = "Create:";
        create_origin = "top-center";
        create_offset = [
          0
          2
          50
          3
        ];

        # rename
        rename_title = "Rename:";
        rename_origin = "hovered";
        rename_offset = [
          0
          1
          50
          3
        ];

        # filter
        filter_title = "Filter:";
        filter_origin = "top-center";
        filter_offset = [
          0
          2
          50
          3
        ];

        # find
        find_title = [
          "Find next:"
          "Find previous:"
        ];
        find_origin = "top-center";
        find_offset = [
          0
          2
          50
          3
        ];

        # search
        search_title = "Search via {n}:";
        search_origin = "top-center";
        search_offset = [
          0
          2
          50
          3
        ];

        # shell
        shell_title = [
          "Shell:"
          "Shell (block):"
        ];
        shell_origin = "top-center";
        shell_offset = [
          0
          2
          50
          3
        ];
      };

      confirm = {
        # trash
        trash_title = "Trash {n} selected file{s}?";
        trash_origin = "center";
        trash_offset = [
          0
          0
          70
          20
        ];

        # delete
        delete_title = "Permanently delete {n} selected file{s}?";
        delete_origin = "center";
        delete_offset = [
          0
          0
          70
          20
        ];

        # overwrite
        overwrite_title = "Overwrite file?";
        overwrite_content = "Will overwrite the following file:";
        overwrite_origin = "center";
        overwrite_offset = [
          0
          0
          50
          15
        ];

        # quit
        quit_title = "Quit?";
        quit_content = "The following task is still running are you sure you want to quit?";
        quit_origin = "center";
        quit_offset = [
          0
          0
          50
          15
        ];
      };

      select = {
        open_title = "Open with:";
        open_origin = "hovered";
        open_offset = [
          0
          1
          50
          7
        ];
      };

      which = {
        sort_by = "none";
        sort_sensitive = false;
        sort_reverse = false;
        sort_translit = false;
      };

      log = {
        enabled = false;
      };
    };

    keymaps = {

      manager = {

        keymap = [
          {
            on = "<Esc>";
            run = "escape";
            desc = "Exit visual mode; clear selected; or cancel search";
          }
          {
            on = "<C-[>";
            run = "escape";
            desc = "Exit visual mode; clear selected; or cancel search";
          }
          {
            on = "q";
            run = "quit";
            desc = "Quit the process";
          }
          {
            on = "Q";
            run = "quit --no-cwd-file";
            desc = "Quit the process without outputting cwd-file";
          }
          {
            on = "<C-c>";
            run = "close";
            desc = "Close the current tab; or quit if it''s last";
          }
          {
            on = "<C-z>";
            run = "suspend";
            desc = "Suspend the process";
          }

          # Hopping
          {
            on = "k";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "j";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          {
            on = "<Up>";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "<Down>";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          {
            on = "<C-u>";
            run = "arrow -50%";
            desc = "Move cursor up half page";
          }
          {
            on = "<C-d>";
            run = "arrow 50%";
            desc = "Move cursor down half page";
          }
          {
            on = "<C-b>";
            run = "arrow -100%";
            desc = "Move cursor up one page";
          }
          {
            on = "<C-f>";
            run = "arrow 100%";
            desc = "Move cursor down one page";
          }

          {
            on = "<S-PageUp>";
            run = "arrow -50%";
            desc = "Move cursor up half page";
          }
          {
            on = "<S-PageDown>";
            run = "arrow 50%";
            desc = "Move cursor down half page";
          }
          {
            on = "<PageUp>";
            run = "arrow -100%";
            desc = "Move cursor up one page";
          }
          {
            on = "<PageDown>";
            run = "arrow 100%";
            desc = "Move cursor down one page";
          }

          {
            on = [
              "g"
              "g"
            ];
            run = "arrow -99999999";
            desc = "Move cursor to the top";
          }
          {
            on = "G";
            run = "arrow 99999999";
            desc = "Move cursor to the bottom";
          }

          # Navigation
          {
            on = "h";
            run = "leave";
            desc = "Go back to the parent directory";
          }
          {
            on = "l";
            run = "enter";
            desc = "Enter the child directory";
          }

          {
            on = "<Left>";
            run = "leave";
            desc = "Go back to the parent directory";
          }
          {
            on = "<Right>";
            run = "enter";
            desc = "Enter the child directory";
          }

          {
            on = "H";
            run = "back";
            desc = "Go back to the previous directory";
          }
          {
            on = "L";
            run = "forward";
            desc = "Go forward to the next directory";
          }

          # Toggle
          {
            on = "<Space>";
            run = [
              "toggle"
              "arrow 1"
            ];
            desc = "Toggle the current selection state";
          }
          {
            on = "<C-a>";
            run = "toggle_all --state=on";
            desc = "Select all files";
          }
          {
            on = "<C-r>";
            run = "toggle_all";
            desc = "Invert selection of all files";
          }

          # Visual mode
          {
            on = "v";
            run = "visual_mode";
            desc = "Enter visual mode (selection mode)";
          }
          {
            on = "V";
            run = "visual_mode --unset";
            desc = "Enter visual mode (unset mode)";
          }

          # Seeking
          {
            on = "K";
            run = "seek -5";
            desc = "Seek up 5 units in the preview";
          }
          {
            on = "J";
            run = "seek 5";
            desc = "Seek down 5 units in the preview";
          }

          # Spotting
          {
            on = "<Tab>";
            run = "spot";
            desc = "Spot hovered file";
          }

          # Operation
          {
            on = "o";
            run = "open";
            desc = "Open selected files";
          }
          {
            on = "O";
            run = "open --interactive";
            desc = "Open selected files interactively";
          }
          {
            on = "<Enter>";
            run = "open";
            desc = "Open selected files";
          }
          {
            on = "<S-Enter>";
            run = "open --interactive";
            desc = "Open selected files interactively";
          }
          {
            on = "y";
            run = "yank";
            desc = "Yank selected files (copy)";
          }
          {
            on = "x";
            run = "yank --cut";
            desc = "Yank selected files (cut)";
          }
          {
            on = "p";
            run = "paste";
            desc = "Paste yanked files";
          }
          {
            on = "P";
            run = "paste --force";
            desc = "Paste yanked files (overwrite if the destination exists)";
          }
          {
            on = "-";
            run = "link";
            desc = "Symlink the absolute path of yanked files";
          }
          {
            on = "_";
            run = "link --relative";
            desc = "Symlink the relative path of yanked files";
          }
          {
            on = "<C-->";
            run = "hardlink";
            desc = "Hardlink yanked files";
          }
          {
            on = "Y";
            run = "unyank";
            desc = "Cancel the yank status";
          }
          {
            on = "X";
            run = "unyank";
            desc = "Cancel the yank status";
          }
          {
            on = "d";
            run = "remove";
            desc = "Trash selected files";
          }
          {
            on = "D";
            run = "remove --permanently";
            desc = "Permanently delete selected files";
          }
          {
            on = "a";
            run = "create";
            desc = "Create a file (ends with / for directories)";
          }
          {
            on = "r";
            run = "rename --cursor=before_ext";
            desc = "Rename selected file(s)";
          }
          {
            on = ";";
            run = "shell --interactive";
            desc = "Run a shell command";
          }
          {
            on = ":";
            run = "shell --block --interactive";
            desc = "Run a shell command (block until finishes)";
          }
          {
            on = ".";
            run = "hidden toggle";
            desc = "Toggle the visibility of hidden files";
          }
          {
            on = "s";
            run = "search --via=fd";
            desc = "Search files by name via fd";
          }
          {
            on = "S";
            run = "search --via=rg";
            desc = "Search files by content via ripgrep";
          }
          {
            on = "<C-s>";
            run = "escape --search";
            desc = "Cancel the ongoing search";
          }
          {
            on = "z";
            run = "plugin zoxide";
            desc = "Jump to a directory via zoxide";
          }
          {
            on = "Z";
            run = "plugin fzf";
            desc = "Jump to a file/directory via fzf";
          }

          # Linemode
          {
            on = [
              "m"
              "s"
            ];
            run = "linemode size";
            desc = "Linemode: size";
          }
          {
            on = [
              "m"
              "p"
            ];
            run = "linemode permissions";
            desc = "Linemode: permissions";
          }
          {
            on = [
              "m"
              "b"
            ];
            run = "linemode btime";
            desc = "Linemode: btime";
          }
          {
            on = [
              "m"
              "m"
            ];
            run = "linemode mtime";
            desc = "Linemode: mtime";
          }
          {
            on = [
              "m"
              "o"
            ];
            run = "linemode owner";
            desc = "Linemode: owner";
          }
          {
            on = [
              "m"
              "n"
            ];
            run = "linemode none";
            desc = "Linemode: none";
          }

          # Copy
          {
            on = [
              "c"
              "c"
            ];
            run = "copy path";
            desc = "Copy the file path";
          }
          {
            on = [
              "c"
              "d"
            ];
            run = "copy dirname";
            desc = "Copy the directory path";
          }
          {
            on = [
              "c"
              "f"
            ];
            run = "copy filename";
            desc = "Copy the filename";
          }
          {
            on = [
              "c"
              "n"
            ];
            run = "copy name_without_ext";
            desc = "Copy the filename without extension";
          }

          # Filter
          {
            on = "f";
            run = "filter --smart";
            desc = "Filter files";
          }

          # Find
          {
            on = "/";
            run = "find --smart";
            desc = "Find next file";
          }
          {
            on = "?";
            run = "find --previous --smart";
            desc = "Find previous file";
          }
          {
            on = "n";
            run = "find_arrow";
            desc = "Goto the next found";
          }
          {
            on = "N";
            run = "find_arrow --previous";
            desc = "Goto the previous found";
          }

          # Sorting
          {
            on = [
              ","
              "m"
            ];
            run = [
              "sort mtime --reverse=no"
              "linemode mtime"
            ];
            desc = "Sort by modified time";
          }
          {
            on = [
              ","
              "M"
            ];
            run = [
              "sort mtime --reverse"
              "linemode mtime"
            ];
            desc = "Sort by modified time (reverse)";
          }
          {
            on = [
              ","
              "b"
            ];
            run = [
              "sort btime --reverse=no"
              "linemode btime"
            ];
            desc = "Sort by birth time";
          }
          {
            on = [
              ","
              "B"
            ];
            run = [
              "sort btime --reverse"
              "linemode btime"
            ];
            desc = "Sort by birth time (reverse)";
          }
          {
            on = [
              ","
              "e"
            ];
            run = "sort extension --reverse=no";
            desc = "Sort by extension";
          }
          {
            on = [
              ","
              "E"
            ];
            run = "sort extension --reverse";
            desc = "Sort by extension (reverse)";
          }
          {
            on = [
              ","
              "a"
            ];
            run = "sort alphabetical --reverse=no";
            desc = "Sort alphabetically";
          }
          {
            on = [
              ","
              "A"
            ];
            run = "sort alphabetical --reverse";
            desc = "Sort alphabetically (reverse)";
          }
          {
            on = [
              ","
              "n"
            ];
            run = "sort natural --reverse=no";
            desc = "Sort naturally";
          }
          {
            on = [
              ","
              "N"
            ];
            run = "sort natural --reverse";
            desc = "Sort naturally (reverse)";
          }
          {
            on = [
              ","
              "s"
            ];
            run = [
              "sort size --reverse=no"
              "linemode size"
            ];
            desc = "Sort by size";
          }
          {
            on = [
              ","
              "S"
            ];
            run = [
              "sort size --reverse"
              "linemode size"
            ];
            desc = "Sort by size (reverse)";
          }
          {
            on = [
              ","
              "r"
            ];
            run = "sort random --reverse=no";
            desc = "Sort randomly";
          }

          # Goto
          {
            on = [
              "g"
              "h"
            ];
            run = "cd ~";
            desc = "Go home";
          }
          {
            on = [
              "g"
              "c"
            ];
            run = "cd ~/.config";
            desc = "Goto ~/.config";
          }
          {
            on = [
              "g"
              "d"
            ];
            run = "cd ~/Downloads";
            desc = "Goto ~/Downloads";
          }
          {
            on = [
              "g"
              "<Space>"
            ];
            run = "cd --interactive";
            desc = "Jump interactively";
          }

          # Tabs
          {
            on = "t";
            run = "tab_create --current";
            desc = "Create a new tab with CWD";
          }

          {
            on = "1";
            run = "tab_switch 0";
            desc = "Switch to the first tab";
          }
          {
            on = "2";
            run = "tab_switch 1";
            desc = "Switch to the second tab";
          }
          {
            on = "3";
            run = "tab_switch 2";
            desc = "Switch to the third tab";
          }
          {
            on = "4";
            run = "tab_switch 3";
            desc = "Switch to the fourth tab";
          }
          {
            on = "5";
            run = "tab_switch 4";
            desc = "Switch to the fifth tab";
          }
          {
            on = "6";
            run = "tab_switch 5";
            desc = "Switch to the sixth tab";
          }
          {
            on = "7";
            run = "tab_switch 6";
            desc = "Switch to the seventh tab";
          }
          {
            on = "8";
            run = "tab_switch 7";
            desc = "Switch to the eighth tab";
          }
          {
            on = "9";
            run = "tab_switch 8";
            desc = "Switch to the ninth tab";
          }

          {
            on = "[";
            run = "tab_switch -1 --relative";
            desc = "Switch to the previous tab";
          }
          {
            on = "]";
            run = "tab_switch 1 --relative";
            desc = "Switch to the next tab";
          }

          {
            on = "{";
            run = "tab_swap -1";
            desc = "Swap current tab with previous tab";
          }
          {
            on = "}";
            run = "tab_swap 1";
            desc = "Swap current tab with next tab";
          }

          # Tasks
          {
            on = "w";
            run = "tasks_show";
            desc = "Show task manager";
          }

          # Help
          {
            on = "~";
            run = "help";
            desc = "Open help";
          }
          {
            on = "<F1>";
            run = "help";
            desc = "Open help";
          }
        ];
      };

      tasks = {

        keymap = [
          {
            on = "<Esc>";
            run = "close";
            desc = "Close task manager";
          }
          {
            on = "<C-[>";
            run = "close";
            desc = "Close task manager";
          }
          {
            on = "<C-c>";
            run = "close";
            desc = "Close task manager";
          }
          {
            on = "w";
            run = "close";
            desc = "Close task manager";
          }

          {
            on = "k";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "j";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          {
            on = "<Up>";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "<Down>";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          {
            on = "<Enter>";
            run = "inspect";
            desc = "Inspect the task";
          }
          {
            on = "x";
            run = "cancel";
            desc = "Cancel the task";
          }

          # Help
          {
            on = "~";
            run = "help";
            desc = "Open help";
          }
          {
            on = "<F1>";
            run = "help";
            desc = "Open help";
          }
        ];
      };

      spot = {

        keymap = [
          {
            on = "<Esc>";
            run = "close";
            desc = "Close the spot";
          }
          {
            on = "<C-[>";
            run = "close";
            desc = "Close the spot";
          }
          {
            on = "<C-c>";
            run = "close";
            desc = "Close the spot";
          }
          {
            on = "<Tab>";
            run = "close";
            desc = "Close the spot";
          }

          {
            on = "k";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "j";
            run = "arrow 1";
            desc = "Move cursor down";
          }
          {
            on = "h";
            run = "swipe -1";
            desc = "Swipe to the previous file";
          }
          {
            on = "l";
            run = "swipe 1";
            desc = "Swipe to the next file";
          }

          {
            on = "<Up>";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "<Down>";
            run = "arrow 1";
            desc = "Move cursor down";
          }
          {
            on = "<Left>";
            run = "swipe -1";
            desc = "Swipe to the next file";
          }
          {
            on = "<Right>";
            run = "swipe 1";
            desc = "Swipe to the previous file";
          }

          # Copy
          {
            on = [
              "c"
              "c"
            ];
            run = "copy cell";
            desc = "Copy selected cell";
          }

          # Help
          {
            on = "~";
            run = "help";
            desc = "Open help";
          }
          {
            on = "<F1>";
            run = "help";
            desc = "Open help";
          }
        ];
      };

      pick = {

        keymap = [
          {
            on = "<Esc>";
            run = "close";
            desc = "Cancel pick";
          }
          {
            on = "<C-[>";
            run = "close";
            desc = "Cancel pick";
          }
          {
            on = "<C-c>";
            run = "close";
            desc = "Cancel pick";
          }
          {
            on = "<Enter>";
            run = "close --submit";
            desc = "Submit the pick";
          }

          {
            on = "k";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "j";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          {
            on = "<Up>";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "<Down>";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          # Help
          {
            on = "~";
            run = "help";
            desc = "Open help";
          }
          {
            on = "<F1>";
            run = "help";
            desc = "Open help";
          }
        ];
      };

      input = {

        keymap = [
          {
            on = "<C-c>";
            run = "close";
            desc = "Cancel input";
          }
          {
            on = "<Enter>";
            run = "close --submit";
            desc = "Submit input";
          }
          {
            on = "<Esc>";
            run = "escape";
            desc = "Go back the normal mode; or cancel input";
          }
          {
            on = "<C-[>";
            run = "escape";
            desc = "Go back the normal mode; or cancel input";
          }

          # Mode
          {
            on = "i";
            run = "insert";
            desc = "Enter insert mode";
          }
          {
            on = "I";
            run = [
              "move first-char"
              "insert"
            ];
            desc = "Move to the BOL; and enter insert mode";
          }
          {
            on = "a";
            run = "insert --append";
            desc = "Enter append mode";
          }
          {
            on = "A";
            run = [
              "move eol"
              "insert --append"
            ];
            desc = "Move to the EOL; and enter append mode";
          }
          {
            on = "v";
            run = "visual";
            desc = "Enter visual mode";
          }
          {
            on = "V";
            run = [
              "move bol"
              "visual"
              "move eol"
            ];
            desc = "Enter visual mode and select all";
          }
          {
            on = "r";
            run = "replace";
            desc = "Replace a single character";
          }

          # Character-wise movement
          {
            on = "h";
            run = "move -1";
            desc = "Move back a character";
          }
          {
            on = "l";
            run = "move 1";
            desc = "Move forward a character";
          }
          {
            on = "<Left>";
            run = "move -1";
            desc = "Move back a character";
          }
          {
            on = "<Right>";
            run = "move 1";
            desc = "Move forward a character";
          }
          {
            on = "<C-b>";
            run = "move -1";
            desc = "Move back a character";
          }
          {
            on = "<C-f>";
            run = "move 1";
            desc = "Move forward a character";
          }

          # Word-wise movement
          {
            on = "b";
            run = "backward";
            desc = "Move back to the start of the current or previous word";
          }
          {
            on = "B";
            run = "backward --far";
            desc = "Move back to the start of the current or previous WORD";
          }
          {
            on = "w";
            run = "forward";
            desc = "Move forward to the start of the next word";
          }
          {
            on = "W";
            run = "forward --far";
            desc = "Move forward to the start of the next WORD";
          }
          {
            on = "e";
            run = "forward --end-of-word";
            desc = "Move forward to the end of the current or next word";
          }
          {
            on = "E";
            run = "forward --far --end-of-word";
            desc = "Move forward to the end of the current or next WORD";
          }
          {
            on = "<A-b>";
            run = "backward";
            desc = "Move back to the start of the current or previous word";
          }
          {
            on = "<A-f>";
            run = "forward --end-of-word";
            desc = "Move forward to the end of the current or next word";
          }

          # Line-wise movement
          {
            on = "0";
            run = "move bol";
            desc = "Move to the BOL";
          }
          {
            on = "$";
            run = "move eol";
            desc = "Move to the EOL";
          }
          {
            on = "_";
            run = "move first-char";
            desc = "Move to the first non-whitespace character";
          }
          {
            on = "^";
            run = "move first-char";
            desc = "Move to the first non-whitespace character";
          }
          {
            on = "<C-a>";
            run = "move bol";
            desc = "Move to the BOL";
          }
          {
            on = "<C-e>";
            run = "move eol";
            desc = "Move to the EOL";
          }
          {
            on = "<Home>";
            run = "move bol";
            desc = "Move to the BOL";
          }
          {
            on = "<End>";
            run = "move eol";
            desc = "Move to the EOL";
          }

          # Delete
          {
            on = "<Backspace>";
            run = "backspace";
            desc = "Delete the character before the cursor";
          }
          {
            on = "<Delete>";
            run = "backspace --under";
            desc = "Delete the character under the cursor";
          }
          {
            on = "<C-h>";
            run = "backspace";
            desc = "Delete the character before the cursor";
          }
          {
            on = "<C-d>";
            run = "backspace --under";
            desc = "Delete the character under the cursor";
          }

          # Kill
          {
            on = "<C-u>";
            run = "kill bol";
            desc = "Kill backwards to the BOL";
          }
          {
            on = "<C-k>";
            run = "kill eol";
            desc = "Kill forwards to the EOL";
          }
          {
            on = "<C-w>";
            run = "kill backward";
            desc = "Kill backwards to the start of the current word";
          }
          {
            on = "<A-d>";
            run = "kill forward";
            desc = "Kill forwards to the end of the current word";
          }

          # Cut/Yank/Paste
          {
            on = "d";
            run = "delete --cut";
            desc = "Cut the selected characters";
          }
          {
            on = "D";
            run = [
              "delete --cut"
              "move eol"
            ];
            desc = "Cut until the EOL";
          }
          {
            on = "c";
            run = "delete --cut --insert";
            desc = "Cut the selected characters; and enter insert mode";
          }
          {
            on = "C";
            run = [
              "delete --cut --insert"
              "move eol"
            ];
            desc = "Cut until the EOL; and enter insert mode";
          }
          {
            on = "x";
            run = [
              "delete --cut"
              "move 1 --in-operating"
            ];
            desc = "Cut the current character";
          }
          {
            on = "y";
            run = "yank";
            desc = "Copy the selected characters";
          }
          {
            on = "p";
            run = "paste";
            desc = "Paste the copied characters after the cursor";
          }
          {
            on = "P";
            run = "paste --before";
            desc = "Paste the copied characters before the cursor";
          }

          # Undo/Redo
          {
            on = "u";
            run = "undo";
            desc = "Undo the last operation";
          }
          {
            on = "<C-r>";
            run = "redo";
            desc = "Redo the last operation";
          }

          # Help
          {
            on = "~";
            run = "help";
            desc = "Open help";
          }
          {
            on = "<F1>";
            run = "help";
            desc = "Open help";
          }
        ];
      };

      confirm = {

        keymap = [
          {
            on = "<Esc>";
            run = "close";
            desc = "Cancel the confirm";
          }
          {
            on = "<C-[>";
            run = "close";
            desc = "Cancel the confirm";
          }
          {
            on = "<C-c>";
            run = "close";
            desc = "Cancel the confirm";
          }
          {
            on = "<Enter>";
            run = "close --submit";
            desc = "Submit the confirm";
          }

          {
            on = "n";
            run = "close";
            desc = "Cancel the confirm";
          }
          {
            on = "y";
            run = "close --submit";
            desc = "Submit the confirm";
          }

          {
            on = "k";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "j";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          {
            on = "<Up>";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "<Down>";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          # Help
          {
            on = "~";
            run = "help";
            desc = "Open help";
          }
          {
            on = "<F1>";
            run = "help";
            desc = "Open help";
          }
        ];
      };

      completion = {

        keymap = [
          {
            on = "<C-c>";
            run = "close";
            desc = "Cancel completion";
          }
          {
            on = "<Tab>";
            run = "close --submit";
            desc = "Submit the completion";
          }
          {
            on = "<Enter>";
            run = [
              "close --submit"
              "close_input --submit"
            ];
            desc = "Submit the completion and input";
          }

          {
            on = "<A-k>";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "<A-j>";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          {
            on = "<Up>";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "<Down>";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          {
            on = "<C-p>";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "<C-n>";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          # Help
          {
            on = "~";
            run = "help";
            desc = "Open help";
          }
          {
            on = "<F1>";
            run = "help";
            desc = "Open help";
          }
        ];
      };

      help = {

        keymap = [
          {
            on = "<Esc>";
            run = "escape";
            desc = "Clear the filter; or hide the help";
          }
          {
            on = "<C-[>";
            run = "escape";
            desc = "Clear the filter; or hide the help";
          }
          {
            on = "<C-c>";
            run = "close";
            desc = "Hide the help";
          }

          # Navigation
          {
            on = "k";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "j";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          {
            on = "<Up>";
            run = "arrow -1";
            desc = "Move cursor up";
          }
          {
            on = "<Down>";
            run = "arrow 1";
            desc = "Move cursor down";
          }

          # Filtering
          {
            on = "f";
            run = "filter";
            desc = "Apply a filter for the help items";
          }
        ];
      };
    };

  };
}
