# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  config-values,
  ...
}:
let
  name = "common-configuration";
  cfg = config.myModules.${name};
in
{
  options.myModules.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {

    users.users."${config-values.username}" = {
      isNormalUser = true;
      extraGroups = [
        # "audio"
        # "cups"
        "docker"
        # "input"
        "libvirtd"
        # "lp"
        # "video"
        "wheel"
        # "wireshark"
      ];
    };

    networking.hostName = config-values.nixos.hostname;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm = {
      enable = true;
    };
    services.desktopManager.gnome.enable = true;
    # services.gnome.core-utilities.enable = false;

    # Configure keymap in X11
    # services.xserver.xkb.layout = "us,de";
    # services.xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable sound.
    # hardware.pulseaudio.enable = true;
    # OR
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;

    virtualisation = {
      libvirtd.enable = true;
      docker.enable = true;
    };

    hardware = {
      graphics.enable = true;
    };

    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = [
          "kitty.desktop"
        ];
      };
    };

    # programs.firefox.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim
      cntr
    ];

    environment.variables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    programs.ssh.knownHosts = {
      "github.com".publicKey =
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
    }
    // config-values.nixos.knownHosts;

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    networking.firewall.enable = true;

    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
    ];
  };
}
