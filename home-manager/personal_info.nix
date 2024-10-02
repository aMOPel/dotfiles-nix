{ lib, ... }:
let
  personalInfo = rec{
    username = "";
    homeDirectory = "/home/${username}";
    git = {
      userName = "";
      userEmail = "";
    };
    email = {
      address = "";
    };
    task = {
      context = {
        # test.read = "pro:test";
        # test.write = "pro:test";
      };
    };
  };
in
# check that every leaf is differ from emtpy string
lib.attrsets.mapAttrsRecursive
  (name: value:
  assert
  lib.asserts.assertMsg (value != "")
    "you have to provide a value for the key '${lib.strings.concatStringsSep "." name}'";
  value)
  personalInfo
