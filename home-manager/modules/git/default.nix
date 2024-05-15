{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "";
    userEmail = "";
    # extraConfig = {
    #   credential = {
    #     helper = pkgs.pass-git-helper;
    #     useHttpPath = true;
    #   };
    # };
  };
}
