{
  config,
  lib,
  ...
}:
let
  moduleName = "ssh";
  cfg = config.myModules."${moduleName}";
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
    allowUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "root" ];
      example = ''["first", "second"]'';
      description = "ssh login only for these users enabled";
    };
  };

  config = lib.mkIf cfg.enable (
    let
    in
    {
      services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PasswordAuthentication = false;
          PubkeyAuthentication = true;
          KbdInteractiveAuthentication = false;
          PermitEmptyPasswords = false;
          X11Forwarding = false;
          AllowAgentForwarding = false;
          AllowTcpForwarding = false;
          KexAlgorithms = [
            "mlkem768x25519-sha256"
          ];
          Ciphers = [
            "aes256-gcm@openssh.com"
          ];
          Macs = [ "hmac-sha2-512-etm@openssh.com" ];
          AllowUsers = cfg.allowUsers;
          LogLevel = "VERBOSE"; # for fail2ban
          PermitRootLogin = "without-password"; # required for remote nixos-rebuild
          ClientAliveCountMax = 2;
          MaxAuthTries = 3;
          IgnoreRhosts = true;
          UseDns = true;
          TCPKeepAlive = false;
        };
      };
    }
  );
}
