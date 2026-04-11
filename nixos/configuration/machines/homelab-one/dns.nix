{
  config,
  lib,
  ...
}:
let
  moduleName = "dns";
  cfg = config.myModules."${moduleName}";
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
  };

  config = lib.mkIf cfg.enable (
    let
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
            "192.168.1.1" # redirect to router for unknown routes
          ];
          address = "/homelab-one/192.168.1.196"; # route all subdomains to same ip
          cache-size = 1000;
          dns-forward-max = 150;

          # TODO: get interface name from somewhere else
          interface = "enp1s0";
          no-dhcp-interface = "enp1s0";
          bogus-priv = true;
        };
      };
    }
  );
}
