{
  pkgs_latest,
  pkgs_for_nvim,
  pkgs,
  lib,
  home-manager,
  hmlib,
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
  ];

  networking.hostName = config-values.nixos.hostname;

  users.users."${config-values.username}" = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "libvirtd"
      "wheel"
      "samba-group"
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [
          "127.0.0.1:5232"
        ];
        max_connections = 20;
        max_content_length = 100000000; # 100 Megabyte
        timeout = 30; # 30 seconds
      };
      auth = {
        type = "none";
        # htpasswd_filename = "/etc/radicale/users";
        # htpasswd_encryption = "bcrypt";
        # delay = 1; # Average delay after failed login attempts in seconds
      };
      storage = {
        filesystem_folder = "/srv/radicale/collections";
      };
    };
  };

  services.nginx = {
    enable = true;

    # for acme
    # recommendedProxySettings = true;
    # recommendedTlsSettings = true;

    virtualHosts = {
      "${config-values.nixos.hostname}" = {
        root = "/srv/www/";

        # for acme
        # enableACME = true;
        # forceSSL = true;

        locations = {
          "/" = {
            extraConfig = ''
              index index.html;
            '';
          };
          "/radicale/" = {
            extraConfig = ''
              proxy_pass        http://127.0.0.1:5232;
              proxy_set_header  X-Script-Name /radicale;
              proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header  X-Forwarded-Host $host;
              proxy_set_header  X-Forwarded-Port $server_port;
              proxy_set_header  X-Forwarded-Proto $scheme;
              proxy_set_header  Host $host;
              proxy_pass_header Authorization;
            '';
          };
        };
      };
    };
  };

  # acme server
  services.step-ca = {
    enable = true;
    openFirewall = false;
    # overrides config
    address = "127.0.0.1";
    port = 8443;
    # these files only exists after running `/nixos/scripts/new-install/6-init-step-ca.sh`
    intermediatePasswordFile = "/run/keys/smallstep-password";
    settings = builtins.fromJSON (builtins.readFile /var/lib/step-ca/.step/config/ca.json);

  };

  # # acme client
  # security.acme = {
  #   acceptTerms = true;
  #   defaults = {
  #     email = "admin@homelab-one";
  #     server = "https://127.0.0.1:8443/acme/acme/directory";
  #   };
  # };

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
    sambaServerName = "samba-${config-values.nixos.hostname}";
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
