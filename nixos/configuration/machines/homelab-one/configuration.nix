{
  pkgs_latest,
  pkgs_for_nvim,
  pkgs,
  lib,
  home-manager,
  hmlib,
  sops-nix,
  ...
}:
let
  config-values = import ./config_values.nix;
  yubikey-disc-encryption = import ../../common/yubikey-disc-encryption.nix {
    device = config-values.nixos.luksDiskPath;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    yubikey-disc-encryption
    ./samba.nix
    ./tls-in-lan.nix
    sops-nix.nixosModules.sops
  ];

  sops.age.sshKeyPaths = [ ];
  sops.gnupg.sshKeyPaths = [ ];
  sops.age.generateKey = false;
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  networking.hostName = config-values.nixos.hostname;

  users.users."${config-values.username}" = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "libvirtd"
      "wheel"
      "samba-group" # can log into samba share
    ];
    openssh.authorizedKeys.keys = config-values.nixos.authorizedKeys.keys;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = config-values.nixos.authorizedKeys.keys;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # system hardening
  security.sudo.wheelNeedsPassword = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  hardware = {
    graphics.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    cntr
    gnumake
    apacheHttpd
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.ssh.knownHosts = {
    "github.com".publicKey =
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
  }
  // config-values.nixos.knownHosts;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      443
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

  # services.radicale = {
  #   enable = true;
  #   settings = {
  #     server = {
  #       hosts = [
  #         "127.0.0.1:5232"
  #       ];
  #       max_connections = 20;
  #       max_content_length = 100000000; # 100 Megabyte
  #       timeout = 30; # 30 seconds
  #     };
  #     auth = {
  #       type = "none";
  #       # htpasswd_filename = "/etc/radicale/users";
  #       # htpasswd_encryption = "bcrypt";
  #       # delay = 1; # Average delay after failed login attempts in seconds
  #     };
  #     storage = {
  #       filesystem_folder = "/srv/radicale/collections";
  #     };
  #   };
  # };

  services.nginx = {
    enable = true;

    # for acme
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    recommendedGzipSettings = false;
    recommendedOptimisation = true;
    recommendedZstdSettings = true;
    recommendedUwsgiSettings = true;
    recommendedBrotliSettings = false;

    appendHttpConfig = ''
      # Strict Transport Security (HSTS)
      add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
      # Content Security Policy (CSP)
      add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self';" always;

      add_header Referrer-Policy "no-referrer" always;
      add_header X-Content-Type-Options "nosniff" always;
      add_header X-Frame-Options "DENY" always;
    '';

    virtualHosts = {
      "${config-values.nixos.hostname}" = {
        root = "/srv/www/";

        # for acme
        enableACME = true;
        forceSSL = true;

        # don't configure top level to not collide with recommended settings, which breaks config
        extraConfig = ''
          ssl_stapling off; # because ocsp is not supported by step-ca
          ssl_prefer_server_ciphers on;
        '';

        locations = {
          "/" = {
            extraConfig = ''
              index index.html;
            '';
          };
          # "/radicale/" = {
          #   extraConfig = ''
          #     proxy_pass        http://127.0.0.1:5232;
          #     proxy_set_header  X-Script-Name /radicale;
          #     proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
          #     proxy_set_header  X-Forwarded-Host $host;
          #     proxy_set_header  X-Forwarded-Port $server_port;
          #     proxy_set_header  X-Forwarded-Proto $scheme;
          #     proxy_set_header  Host $host;
          #     proxy_pass_header Authorization;
          #   '';
          # };
        };
      };
    };
  };

  fileSystems."/srv/www" = {
    device = "/home/${config-values.username}/data/www";
    options = [ "bind" ];
  };

  fileSystems."/srv/radicale/collections" = {
    device = "/home/${config-values.username}/data/radicale/collections";
    options = [ "bind" ];
  };

  myModules.samba = {
    enable = true;
    shareParentDir = "/home/${config-values.username}/data";
    sambaServerName = "${config-values.nixos.hostname}";
    allowedUsers = "${config-values.username}";
  };

  myModules.tls-in-lan = {
    enable = true;
    rootCaCrtPath = ./certificates/root-ca.crt;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
