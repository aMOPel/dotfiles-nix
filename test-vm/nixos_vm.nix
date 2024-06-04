let
  sources = import ../nix/sources.nix;
  configuration = import ./configuration.nix;
  nixos = import (sources.nixpkgs + "/nixos") { inherit configuration; };
in
nixos.vm
