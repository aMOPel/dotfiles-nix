{
  config,
  lib,
  ...
}:
let
  moduleName = "dns";
  cfg = config.myModules."${moduleName}";
  inherit (config.globals)
    ports
    subdomains
    uids
    gids
    userGroups
    defaultDomain
    ;
  inherit (config) extraLib;
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
    serverIpAddress = lib.mkOption {
      type = lib.types.str;
      example = "";
      description = "ip that the server has in the lan";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      # dnsRootDataStringSplit = builtins.split " " (
      #   builtins.head (builtins.split "\n" (builtins.readFile "${pkgs.dns-root-data}/root.ds"))
      # );
      # rootZone = builtins.elemAt dnsRootDataStringSplit 0; # . - The root zone
      # keyTag = builtins.elemAt dnsRootDataStringSplit 6; # 20326 - Key tag
      # algorithm = builtins.elemAt dnsRootDataStringSplit 8; # 8 - Algorithm (RSA/SHA-256)
      # digestType = builtins.elemAt dnsRootDataStringSplit 10; # 2 - Digest type (SHA-256)
      # digest = builtins.elemAt dnsRootDataStringSplit 12; # E06D44B80B8F1D39... - The digest
      # trustAnchor = "${rootZone},${keyTag},${algorithm},${digestType},${digest}";
    in
    {
      networking.firewall = {
        enable = true;
        allowedUDPPorts = [
          53 # DNS
        ];
        allowedTCPPorts = [
          53 # DNS
        ];
      };

      services.dnsmasq = {
        enable = true;
        settings = {
          server = [
            # cloudflare dns, was fastest in tests
            # `nix-shell -p dig --run "dig @1.1.1.1 google.com"`
            "1.1.1.1" # redirect here for unknown domains
          ];
          address = [
            # TODO: get hostname from somewhere else
            "/${defaultDomain}/${cfg.serverIpAddress}" # route all subdomains to same ip
          ];
          cache-size = 1000;
          dns-forward-max = 150;
          no-resolv = true;
          no-hosts = true;

          # for debugging
          # log-queries = true;
          # log-facility = "/var/log/dnsmasq.log";

          # NOTE: slows down name resolution considerably
          # dnssec = true;
          # trust-anchor = trustAnchor;

          # TODO: get interface name from somewhere else
          interface = "enp1s0";
          listen-address = [
            config.extraLib.localAddress
            cfg.serverIpAddress
          ];
          no-dhcp-interface = "enp1s0";
          bogus-priv = true;
        };
      };
    }
  );
}
