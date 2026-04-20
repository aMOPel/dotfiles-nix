# https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/misc/ids.nix
{
  pkgs,
  sops-nix,
  disko-nix,
  ...
}:
{
  options = { };
  config = {
    ids = {
      uids = {
        radicale = 5001;
        samba = 5002;
      };
      gids = {
        radicale = 5001;
        samba = 5002;
      };
    };
  };
}
