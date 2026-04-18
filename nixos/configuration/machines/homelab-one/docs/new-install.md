# nixos

this uses [nix disko](https://github.com/nix-community/disko) for disk
partitioning.

disko fully initialises the disk according to the config and takes care of the
hardware-configuration for the disks.

currently the disk ids are hard coded to always point to the same hardware. if
the hardware changes, the `disko.nix` needs to be adapted

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
5. to use ssh

   ```sh
   sudo -i
   passwd
   ```

6. setup lvm, luks encryption and btrfs partitioning and install nixos

   ```sh
   ./nixos/scripts/3-partition-and-install-server.sh
   ```

7. boot into the newly installed nixos
