{ pkgs, pkgs-latest, ... }:
let
in
{
  programs.zathura = {
    enable = true;
    package = pkgs-latest.zathura;

    options = {
      selection-clipboard = "clipboard";
    };
  };
}
