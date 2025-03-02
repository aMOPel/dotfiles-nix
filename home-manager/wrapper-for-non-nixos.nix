{
  config,
  pkgs,
  lib,
  ...
}:
import ./home.nix { personal-info-path = ../personal_info.nix; } { inherit config pkgs lib; }
