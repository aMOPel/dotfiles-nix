#!/usr/bin/env bash

echo "Assumptions:"
echo "  - The disk, the installation goes to, is backed up or the data on it is not valuable."
echo "  - You want a disk layout like this:"
echo ""
echo "    sda             8:0    0 223.6G  0 disk            "
echo "    ├─sda1          8:1    0  1023M  0 part  /mnt/boot "
echo "    └─sda2          8:2    0 222.6G  0 part            "
echo "      └─cryptroot 254:0    0 222.6G  0 crypt           "
echo "        ├─vg-swap 254:1    0     8G  0 lvm   [SWAP]    "
echo "        └─vg-root 254:2    0 214.6G  0 lvm   /mnt/nix  "
echo "                                             /mnt/home "
echo "                                             /mnt      "
echo ""
echo "  - The first 1GB of the physical disk is given to a fat32 EFI partion."
echo "  - The rest of the disk is a linux partition and encrypted at rest with 'cryptsetup', using yubikey's 'fido2' for authentication."
echo "  - The encrypted partition is  managed by LVM (Logic Volume Manager)."
echo "  - In the LVM disk there is a 'swap' volume of a size of your choice, the rest of the space is given to the 'root' volume."
echo "  - The 'root' volume is formatted in an btrfs filesystem and there are 3 subvolumes (/root /home /nix)"
echo ""
read -p "understood?"

default_value="/dev/sda"
read -p "enter disk path, where nixos should be installed [$default_value] " disk_path
disk_path=${disk_path:-"$default_value"}

default_value="y"
read -p "partition disk into 1G EFI partition and the rest as LVM partition? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ "$REPLY" == "y" ]]; then
  gdisk "$disk_path" <<EOF
o
y
n


1G
ef00
n




w
y
EOF

  echo ""
  gdisk -l "$disk_path"
  echo ""

  default_value="y"
  read -p "does this look correct? [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  [ "$REPLY" != "y" ] && exit 1

  echo ""
  lsblk
  echo ""

  default_value="y"
  read -p "does this look correct? [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  [ "$REPLY" != "y" ] && exit 1
fi

default_value="y"
read -p "setup luks, lvm partitions and btrfs? [$default_value] "
REPLY=${REPLY:-"$default_value"}

if [[ "$REPLY" == "y" ]]; then
  default_value="16"
  read -p "enter ram size in GB [$default_value] " ram_size
  ram_size=${ram_size:-"$default_value"}

  cryptsetup luksFormat "$disk_path"2
  cryptsetup luksOpen "$disk_path"2 cryptroot

  pvcreate /dev/mapper/cryptroot
  vgcreate vg /dev/mapper/cryptroot
  lvcreate -L "$ram_size"G -n swap vg
  lvcreate -l '100%FREE' -n root vg

  mkfs.fat -F 32 "$disk_path"1
  mkfs.btrfs -L root /dev/vg/root
  mkswap -L swap /dev/vg/swap

  mkdir -p /mnt
  mount /dev/vg/root /mnt
  btrfs subvolume create /mnt/root
  btrfs subvolume create /mnt/home
  btrfs subvolume create /mnt/nix
  umount /mnt

  mount -o subvol=root /dev/vg/root /mnt
  mkdir /mnt/{home,nix,boot}
  mount -o subvol=home /dev/vg/root /mnt/home
  mount -o subvol=nix /dev/vg/root /mnt/nix
  mount "$disk_path"1 /mnt/boot
  swapon /dev/vg/swap

  echo ""
  lsblk
  echo ""

  default_value="y"
  read -p "does this look correct? [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  [ "$REPLY" != "y" ] && exit 1
fi

while :; do
  default_value="y"
  read -p "setup (another) yubikey for luks disk encryption? [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" != "y" ]]; then
    break
  fi

  read -p "plugin the yubikey now! "

  default_value="y"
  read -p "change yubikey fido pin? this requires 'ykman' in PATH [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
    ykman fido access change-pin
  fi
  systemd-cryptenroll --fido2-device=auto --fido2-with-client-pin=yes "$disk_path"2
done

default_value="y"
read -p "generate nixos config? [$default_value] "
REPLY=${REPLY:-"$default_value"}

if [[ "$REPLY" == "y" ]]; then
  nixos-generate-config --root /mnt

  echo ""
  ls -l /dev/disk/by-uuid
  echo ""

  default_value=$(ls -l /dev/disk/by-uuid | grep "$(basename /dev/sda)"2 | awk '{print $9}')
  read -p "enter uuid of encrypted disk (should point to ${disk_path}2) [$default_value] " uuid
  uuid=${uuid:-"$default_value"}

  default_value="user1"
  read -p "enter username. [$default_value] " username
  username=${username:-"$default_value"}

  default_value="nixos-pc"
  read -p "enter hostname. [$default_value] " hostname
  hostname=${hostname:-"$default_value"}

  # append the lines about disk encryption to the end
  cat <<EOF >/mnt/etc/nixos/configuration.nix
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (\`nixos-help\`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "${disk_path}"; # or "nodev" for efi only

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd = {
    systemd.enable=true;
    luks.devices.cryptdisk = {
      crypttabExtraOpts = [ "fido2-device=auto" ];
      device = "/dev/disk/by-uuid/${uuid}";
    };
  };

  networking.hostName = "${hostname}"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      git
      neovim
      niv
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see \`man configuration.nix\` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
EOF

  default_value="n"
  read -p "edit nixos config with vim? [$default_value] "
  REPLY=${REPLY:-"$default_value"}
  if [[ "$REPLY" == "y" ]]; then
    vim /mnt/etc/nixos/configuration.nix
  fi

fi

default_value="y"
read -p "install nixos now? [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ "$REPLY" == "y" ]]; then
  nixos-install
fi

default_value="y"
read -p "reboot now? you should be asked for the yubikey pin at startup. [$default_value] "
REPLY=${REPLY:-"$default_value"}
if [[ "$REPLY" == "y" ]]; then
  echo "before you restart, remember that you should remove the passphrase as a slot for the cryptsetup disk!"
  echo ""
  echo "    \$ systemd-cryptenroll --wipe-slot=password ${disk_path}2"
  echo ""
  read -p "understood?"
  systemctl reboot
fi
