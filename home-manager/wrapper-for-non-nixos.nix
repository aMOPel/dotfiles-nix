{
  config,
  pkgs,
  lib,
  ...
}:
import ./home.nix { config-values-path = ../config_values.nix; } { inherit config pkgs lib; }
