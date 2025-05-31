rec {
  username = "";
  homeDirectory = "/home/${username}";
  task = {
    context = {
      # test.read = "pro:test";
      # test.write = "pro:test";
    };
  };
  nixos = {
    hostname = "";
    knownHosts = {
      "<host>".publicKey =
        "ssh-rsa <key>";
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
      globalUserName = "";
      # globalUserEmail = "";
      conditionalConfig = [
        {
          ifRemoteIsHost = "github.com";
          contents = {
            user = {
              email = "";
              name = "";
              signingKey = "<key fingerprint>";
            };
            commit = {
              gpgSign = true;
            };
          };
        }
      ];
    };

    pass = {
      enable = true;
    };

    gpg = {
      enable = true;
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
        # "deno"
        "vim"
        "yaml"
        "misc"
      ];
    };
  };
}
