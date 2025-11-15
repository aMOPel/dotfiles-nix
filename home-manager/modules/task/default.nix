{
  config,
  lib,
  pkgs,
  pkgs_latest,
  ...
}:
let
  cfg = config.myModules.task;
  rootPath = "twarrior";
in
{
  options.myModules.task = {
    enable = lib.mkEnableOption "task";

    context = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = ''"foo"'';
      description = "git config user name";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      shellAliases = {
        t = "taskwarrior-tui";
      };
    };

    home.sessionVariables = {
      TIMEWARRIORDB = "~/${rootPath}/timew";
      TASKDATA = "~/${rootPath}/task";
    };

    home.file = {
      "${rootPath}/task/hooks/on-modify.timewarrior" = {
        source = builtins.toPath "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
        executable = true;
      };

      "${rootPath}/timew/timewarrior.cfg" = {
        text = builtins.readFile ./timewarrior.cfg;
      };
    };

    home.packages = with pkgs; [
      taskwarrior-tui
      timewarrior
      python314
    ];

    programs.taskwarrior = {
      enable = true;
      dataLocation = "~/${rootPath}/task";
      package = pkgs.taskwarrior3;
      config = {
        context = cfg.context;

        uda.priority.values = "H,M,,L";
        urgency.uda.priority.L.coefficient = "-0.5";
        search.case.sensitive = "no";
        dateformat.info = "H:N:S - D.M.Y";
        verbose = "blank,header,footnote,label,new-id,new-uuid,affected,edit,special,project,sync,unwait,recur";
      };
    };

  };
}
