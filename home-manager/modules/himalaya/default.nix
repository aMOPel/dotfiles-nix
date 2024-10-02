{ config, lib, pkgs, ... }:
let
  cfg = config.myModules.himalaya;
in
{
  options.myModules.himalaya = {
    enable = lib.mkEnableOption "himalaya";

    address = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = ''"foo@bar.com"'';
      description = "email address";
    };
  };

  # TODO:
  # gpg
  # attachments (open, add)
  # templates
  # contacts (completion)
  # edit drafts

  config = lib.mkIf cfg.enable {
    accounts.email.maildirBasePath = "maildir";
    accounts.email.accounts.one = {
      address = cfg.address;
      name = "bla";
      userName = cfg.address;
      realName = "bla";
      primary = true;
      maildir = { path = "one"; };
      passwordCommand = "pass show gmail";
      smtp = {
        host = "smtp.gmail.com";
        port = 465;
        tls = { enable = true; };
      };
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls = { enable = true; };
      };

      himalaya = {
        enable = true;
        settings = {
          folder.alias = {
            inbox = "INBOX";
            sent = "[Gmail]/Sent Mail";
            drafts = "[Gmail]/Drafts";
            trash = "[Gmail]/Trash";
          };

          backend = "imap";
          imap = {
            login = cfg.address;
            passwd = { cmd = "pass show gmail"; };
          };

          message.send.backend = "smtp";
          smtp = {
            login = cfg.address;
            passwd = { cmd = "pass show gmail"; };
          };
        };
      };
    };

    programs.himalaya = {
      enable = true;

    };
  };
}
