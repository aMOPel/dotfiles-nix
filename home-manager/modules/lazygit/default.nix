{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        scrollHeight = 2;
        scrollPastBottom = true;
        sidePanelWidth = 0.3333;
        expandFocusedSidePanel = false;
        mainPanelSplitMode = "flexible";
        language = "auto";
        timeFormat = "02 Jan 06 15=04 MST";
        theme = {
          lightTheme = false;
          activeBorderColor = [ "#98c379" "bold" ];
          inactiveBorderColor = [ "#565c64" ];
          optionsTextColor = [ "#61afef" ];
          selectedLineBgColor = [ "#353b45" ];
          selectedRangeBgColor = [ "#353b45" ];
          cherryPickedCommitBgColor = [ "#56b6c2" ];
          cherryPickedCommitFgColor = [ "#61afef" ];
          unstagedChangesColor = [ "#e06c75" ];
          defaultFgColor = [ "#c8ccd4" ];
        };
        commitLength = {
          show = true;
        };
        mouseEvents = true;
        skipUnstageLineWarning = false;
        skipStashWarning = false;
        showFileTree = true;
        showListFooter = true;
        showRandomTip = true;
        showBottomLine = true;
        showCommandLog = true;
        showIcons = true;
        commandLogSize = 8;
        splitDiff = "auto";
      };
      git = {
        paging = {
          colorArg = "always";
          useConfig = false;
        };
        commit = {
          signOff = false;
        };
        merging = {
          manualCommit = false;
          args = "";
        };
        log = {
          order = "topo-order";
          showGraph = "when-maximised";
          showWholeGraph = false;
        };
        skipHookPrefix = "WIP";
        autoFetch = true;
        autoRefresh = true;
        branchLogCmd = "git log - -graph - -color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
        allBranchesLogCmd = "git log - -graph - -all - -color=always --abbrev-commit --decorate --date=relative  --pretty=medium";
        overrideGpg = false;
        disableForcePushing = false;
        parseEmoji = false;
        diffContextSize = 3;
      };
      os = {
        edit = "nvim";
        editAtLine = "{{editor}} +{{line}} -- {{filename}}";
        open = "xdg-open {{filename}} >/dev/null";
      };
      refresher = {
        refreshInterval = 10;
        fetchInterval = 60;
      };
      update = {
        method = "prompt";
        days = 14;
      };
      reporting = "undetermined";
      confirmOnQuit = false;
      quitOnTopLevelReturn = false;
      disableStartupPopups = false;
      notARepository = "prompt";
      promptToReturnFromSubprocess = true;
      keybinding = {
        universal = {
          quit = "q";
          quit-alt1 = "<c-c>";
          return = "<esc>";
          quitWithoutChangingDirectory = "Q";
          togglePanel = "<tab>";
          prevItem = "<up>";
          nextItem = "<down>";
          prevItem-alt = "k";
          nextItem-alt = "j";
          prevPage = ",";
          nextPage = ".";
          gotoTop = "<";
          gotoBottom = ">";
          scrollLeft = "H";
          scrollRight = "L";
          prevBlock = "<left>";
          nextBlock = "<right>";
          prevBlock-alt = "K";
          nextBlock-alt = "J";
          jumpToBlock = [ "1" "2" "3" "4" "5" ];
          nextMatch = "n";
          prevMatch = "N";
          optionMenu = "x";
          optionMenu-alt1 = "?";
          select = "<space>";
          goInto = "<enter>";
          openRecentRepos = "<c-r>";
          confirm = "<enter>";
          confirm-alt1 = "y";
          remove = "d";
          new = "n";
          edit = "e";
          openFile = "o";
          scrollUpMain = "<pgup>";
          scrollDownMain = "<pgdown>";
          scrollUpMain-alt2 = "<c-u>";
          scrollDownMain-alt2 = "<c-d>";
          executeCustomCommand = "=";
          createRebaseOptionsMenu = "m";
          pushFiles = "P";
          pullFiles = "p";
          refresh = "R";
          createPatchOptionsMenu = "<c-p>";
          nextTab = "]";
          prevTab = "[";
          nextScreenMode = "+";
          prevScreenMode = "_";
          undo = "z";
          redo = "<c-z>";
          filteringMenu = "<c-s>";
          diffingMenu = "W";
          diffingMenu-alt = "<c-e>";
          copyToClipboard = "<c-o>";
          submitEditorText = "<enter>";
          appendNewline = "<a-enter>";
          extrasMenu = "@";
          toggleWhitespaceInDiffView = "<c-w>";
          increaseContextInDiffView = "}";
          decreaseContextInDiffView = "{";
        };
        status = {
          checkForUpdate = "u";
          recentRepos = "<enter>";
        };
        files = {
          commitChanges = "c";
          commitChangesWithoutHook = "w";
          amendLastCommit = "A";
          commitChangesWithEditor = "C";
          ignoreFile = "i";
          refreshFiles = "r";
          stashAllChanges = "s";
          viewStashOptions = "S";
          toggleStagedAll = "a";
          viewResetOptions = "D";
          fetch = "f";
          toggleTreeView = "`";
        };
        branches = {
          createPullRequest = "o";
          viewPullRequestOptions = "O";
          checkoutBranchByName = "c";
          forceCheckoutBranch = "F";
          rebaseBranch = "r";
          renameBranch = "R";
          mergeIntoCurrentBranch = "M";
          viewGitFlowOptions = "i";
          fastForward = "f";
          pushTag = "P";
          setUpstream = "u";
          fetchRemote = "f";
        };
        commits = {
          squashDown = "s";
          renameCommit = "r";
          renameCommitWithEditor = "R";
          viewResetOptions = "g";
          markCommitAsFixup = "f";
          createFixupCommit = "F";
          squashAboveCommits = "S";
          moveDownCommit = "<c-j>";
          moveUpCommit = "<c-k>";
          amendToCommit = "A";
          pickCommit = "p";
          revertCommit = "t";
          cherryPickCopy = "c";
          cherryPickCopyRange = "C";
          pasteCommits = "v";
          tagCommit = "T";
          checkoutCommit = "<space>";
          resetCherryPick = "<c-R>";
          copyCommitMessageToClipboard = "<c-y>";
          openLogMenu = "<c-l>";
          viewBisectOptions = "b";
        };
        stash = {
          popStash = "g";
        };
        commitFiles = {
          checkoutCommitFile = "c";
        };
        main = {
          toggleDragSelect = "v";
          toggleDragSelect-alt = "V";
          toggleSelectHunk = "a";
          pickBothHunks = "b";
        };
        submodules = {
          init = "i";
          update = "u";
          bulkMenu = "b";
        };
      };
    };
  };
}
