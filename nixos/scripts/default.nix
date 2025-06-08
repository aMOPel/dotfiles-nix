{ pkgs, ... }:
let
  drduhRepo = pkgs.fetchFromGitHub {
    owner = "drduh";
    repo = "YubiKey-Guide";
    rev = "ece9752967e8b01bb3e70919a8ccdbc252eb9387";
    hash = "sha256-iqeUkEK2yrMi6dTpStEYZ3H7PoI5RoK3i90BRKZNlq8=";
  };
  createPreset = name: rec {
    inherit name;
    text = builtins.readFile (./. + "/${name}.sh");
    executable = true;
    destination = "/bin/${name}";
    # NOTE: writeTextFile uses buildCommand and does not have other phases in it's api
    checkPhase = ''
      substituteAllInPlace "$out${destination}";
      patchShebangsAuto;
    '';
  };
in
{
  scripts = {
    import-gpg = pkgs.callPackage ({ writeTextFile }: writeTextFile (createPreset "import-gpg")) { };
    setup-gpg-and-yubikey = pkgs.callPackage (
      { writeTextFile }:
      writeTextFile (
        (createPreset "setup-gpg-and-yubikey")
        // {
          text =
            builtins.readFile (./gpg-setup + "/common.sh")
            + builtins.readFile (./gpg-setup + "/setup-gpg.sh")
            + builtins.readFile (./gpg-setup + "/setup-yubikey.sh");
          derivationArgs = { inherit drduhRepo; };
        }
      )
    ) { };
    setup-gpg = pkgs.callPackage (
      { writeTextFile }:
      writeTextFile (
        (createPreset "setup-gpg")
        // {
          text = builtins.readFile (./gpg-setup + "/common.sh") + builtins.readFile (./gpg-setup + "/setup-gpg.sh");
          derivationArgs = { inherit drduhRepo; };
        }
      )
    ) { };
    setup-yubikey = pkgs.callPackage (
      { writeTextFile }:
      writeTextFile (
        (createPreset "setup-yubikey")
        // {
          text = builtins.readFile (./gpg-setup + "/common.sh") + builtins.readFile (./gpg-setup + "/setup-yubikey.sh");
          derivationArgs = { inherit drduhRepo; };
        }
      )
    ) { };
  };
}
