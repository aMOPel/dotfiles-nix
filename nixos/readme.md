# nixos

## setup new nixos machine

1. clone repo on the machine you create the live usb:

   ```sh
   git clone https://github.com/aMOPel/dotfiles-nix.git
   cd dotfiles-nix
   ```

2. run this to create the live-usb

   ```sh
   ./nixos/scripts/1-create-live-usb.sh
   ```

3. boot the live usb on the machine you want to install nixos onto
4. setup internet if necessary
5. clone the repo again

   ```sh
   git clone https://github.com/aMOPel/dotfiles-nix.git
   cd dotfiles-nix
   ```

6. (Optional) add the ssh daemon to login from another machine

   ```sh
   ./nixos/scripts/2-add-ssh-to-live-usb.sh
   ```

7. setup lvm, luks encryption and btrfs partitioning and install nixos

   ```sh
   ./nixos/scripts/3-partition-and-install.sh
   ```

8. boot into the newly installed nixos

9. clone repo on the machine you create the live usb:

   ```sh
   git clone https://github.com/aMOPel/dotfiles-nix.git
   cd dotfiles-nix
   ```

10. create a new config for the machine in this repository

    ```sh
    ./nixos/scripts/4-create-machine-config-in-repo.sh
    ```

## setup new gpg key and multiple yubikeys with the opengpg module

```sh
git clone https://github.com/aMOPel/dotfiles-nix.git
cd dotfiles-nix/nixos/scripts/
nix-build scripts.setup-gpg-and-yubikey
```
