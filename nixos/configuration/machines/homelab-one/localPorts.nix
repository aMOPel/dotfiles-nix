{
  lib,
  ...
}:
{
  options = {
    ports = lib.mkOption {
      internal = true;
      description = ''
        ports used on localhost by services
      '';
      type = lib.types.attrs;
    };
  };
  config = {
    ports = {
      radicale = 5232;
      prometheus = 9090;
      grafana = 3000;
      node-exporter = 9100;
      stepCa = 8443;
      authelia = 9091;
    };
  };
}
