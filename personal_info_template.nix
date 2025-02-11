rec {
  username = "";
  homeDirectory = "/home/${username}";
  git = {
    userName = "";
    userEmail = "";
  };
  task = {
    context = {
      # test.read = "pro:test";
      # test.write = "pro:test";
    };
  };
  myModules = {

    task = {
      enable = true;
      context = task.context;
    };

    git = {
      enable = true;
      enableLazygit = true;
      userName = git.userName;
      userEmail = git.userEmail;
    };

    gnome = {
      enable = true;
    };

    mime-applications = {
      enable = true;
    };

    neovim = {
      enable = true;
      filetypes = [
        "angular"
        # "cmake"
        "make"
        # "cpp"
        "css"
        # "cypher"
        "dockerfile"
        # "gdscript"
        "git"
        "go"
        "html"
        "json"
        "lua"
        "markdown"
        # "nim"
        "nix"
        "python"
        "rust"
        "sh"
        "dotenv"
        # "tex"
        "toml"
        "typescript"
        "vim"
        "yaml"
        "misc"
      ];
    };
  };
}
