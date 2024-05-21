{ config, lib, pkgs, ... }:
let
in
{
  plugins = (with pkgs.vimPlugins; [



    nvim-lspconfig
    SchemaStore-nvim
    nvim-lint
    formatter-nvim
  ]);
}
