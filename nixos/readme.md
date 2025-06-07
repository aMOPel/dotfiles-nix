# nixos

## setup new nixos machine

1. download iso (with gnome) and create live usb (make sure it's the nixos version in `./nix/sources.nix`)
   <https://nixos.org/manual/nixos/stable/#sec-booting-from-usb-linux>
2. setup internet
3. `git clone https://github.com/aMOPel/dotfiles-nix.git`
4. `cd dotfiles-nix/nixos/scripts/`
5. (Optional) `./add-ssh.sh` and login from another machine with ssh
6. run `./lvm-crypt.sh`
7. once the the new os is booted, clone the repo again
8. `mkdir -p nixos/machines/<hostname>`
9. `cp -r nixos/machines/t460s/configuration.nix  nixos/machines/<hostname>`
10. `cp /etc/nixos/hardware-configuration.nix nixos/machines/<hostname>/hardware-configuration.nix`
10. `cp nixos/machines/config_values_template.nix nixos/machines/<hostname>/config_values.nix`
11. 
8. `make nixos-switch-flake`
9. 

## setup new gpg key and multiple yubikeys with the opengpg module

3. `git clone https://github.com/aMOPel/dotfiles-nix.git`
4. `cd dotfiles-nix/nixos/scripts/`
5. `nix-build scripts.setup-gpg-and-yubikey`
