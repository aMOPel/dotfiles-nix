{ pkgs, pkgs_latest, ... }:
let
in
{
  programs.zathura = {
    enable = true;
    package = pkgs_latest.zathura;

    options = {
      selection-clipboard = "clipboard";
    };
  };
}
