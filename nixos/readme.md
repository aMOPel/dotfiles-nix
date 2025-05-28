# nixos

## setup new nixos machine

1. download iso (with gnome) and create live usb (make sure it's the nixos version in `./nix/sources.nix`)
   <https://nixos.org/manual/nixos/stable/#sec-booting-from-usb-linux>
2. setup internet
3. `git clone https://github.com/aMOPel/dotfiles-nix.git`
4. `cd dotfiles-nix/nixos/scripts/`
5. `./add-ssh.sh`
6. login from another machine with ssh
7. from there, run `./lvm-crypt.sh`
