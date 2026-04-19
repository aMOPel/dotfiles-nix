{
  pkgs,
  sops-nix,
  disko-nix,
  ...
}:
let
  config-values = import ./config_values.nix;

  hardenedServerExtraConfig = ''
    ssl_stapling off; # because ocsp is not supported by step-ca
    ssl_prefer_server_ciphers on;
    proxy_cookie_path / "/; Secure; HttpOnly; SameSite=Strict";
    server_tokens off; # don't leak server information

    # dos protection
    client_max_body_size 10M;
    client_body_timeout 10s;
    client_header_timeout 10s;
    limit_req zone=global burst=20 nodelay;

    # block external access
    allow 192.168.1.0/24;
    deny all;
  '';
in
{
  imports = [
    ./hardware-configuration.nix
    ./samba.nix
    ./tls-in-lan.nix
    ./dns.nix
    ./ssh.nix
    ./nginx.nix
    ./snapraid-mergerfs.nix
    disko-nix.nixosModules.disko
    sops-nix.nixosModules.sops
    ./partitioning/disko.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sops.age.sshKeyPaths = [ ];
  sops.gnupg.sshKeyPaths = [ ];
  sops.age.generateKey = true;
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  networking.hostName = config-values.nixos.hostname;

  users.users."${config-values.username}" = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "libvirtd"
      # TODO: check if this is necessary
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
    allowed-users = [
      "@users" # "users" group
    ];
  };

  # system hardening
  security.sudo.wheelNeedsPassword = true;
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
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
    age
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
  };

  # automatically blacklist hosts that have too many failed auth attempts
  services.fail2ban = {
    # TODO: enable after auditing
    enable = false;
    # TODO: jail for samba
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
  #       # type = "none";
  #       type = "htpasswd";
  #       htpasswd_filename = "/var/lib/radicale/users";
  #       htpasswd_encryption = "autodetect";
  #       delay = 1; # Average delay after failed login attempts in seconds
  #     };
  #     storage = {
  #       filesystem_folder = "/srv/radicale/collections";
  #     };
  #   };
  # };
  #
  # services.nginx = {
  #   virtualHosts = {
  #     "radicale.${config-values.nixos.hostname}" = {
  #       # for acme
  #       enableACME = true;
  #       forceSSL = true;
  #
  #       # don't configure top level to not collide with recommended settings, which breaks config
  #       extraConfig = hardenedServerExtraConfig;
  #
  #       locations = {
  #         "/" = {
  #           extraConfig = ''
  #             proxy_pass        http://127.0.0.1:5232;
  #             proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
  #             proxy_set_header  X-Forwarded-Host $host;
  #             proxy_set_header  X-Forwarded-Port $server_port;
  #             proxy_set_header  X-Forwarded-Proto $scheme;
  #             proxy_set_header  Host $host;
  #             proxy_pass_header Authorization;
  #           '';
  #         };
  #       };
  #     };
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
    enable = false;
    shareParentDir = "/home/${config-values.username}/data";
    sambaServerName = "${config-values.nixos.hostname}";
    allowedUsers = "${config-values.username}";
  };

  myModules.tls-in-lan = {
    enable = false;
    rootCaCrtPath = ./certificates/root-ca.crt;
  };

  myModules.dns = {
    enable = false;
  };

  myModules.ssh = {
    enable = true;
    allowUsers = [
      "root"
      "${config-values.username}"
    ];
  };

  myModules.nginx = {
    enable = false;
    defaultDomain = "${config-values.nixos.hostname}";
  };

  myModules.snapraid-mergerfs = {
    enable = true;
    parityDisks = [
      "/snapraid/parity-disk0"
    ];
    dataDisks = [
      "/snapraid/data-disk1"
      "/snapraid/data-disk2"
    ];
    mergerfsMountpoint = "/snapraid/mergerfs";
    user = config-values.username;
    group = "users";
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
