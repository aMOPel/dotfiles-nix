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
    luksDiskPath = "/dev/disk/by-uuid/...";
    hostname = "";
    system = "";
    knownHosts = {
      # "<host>".publicKey =
      #   "ssh-rsa <key>";
    };
  };
  homeManagerModules = {

    task = {
      enable = true;
      context = task.context;
    };

    treefmt = {
      enable = true;
    };

    git = rec {
      enable = true;
      enableLazygit = true;
      globalUserName = username;
      # globalUserEmail = "";
      conditionalConfig = [
        {
          ifRemoteIsHost = "github.com";
          contents = {
            user = {
              email = "";
              name = globalUserName;
              # signingKey = "<key fingerprint>";
            };
            commit = {
              gpgSign = false;
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
        "all"
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
