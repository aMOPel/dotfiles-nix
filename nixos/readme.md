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

## data recovery

### on server with snapraid

<https://www.snapraid.it/manual>

#### about snapraid

- Snapraid uses parity, like raid5, to protect from disk failure.
- one parity disk with 4tb can protect an array of data disks with 4tb.
- as long as only one disk fails, all data can be recovered.
- if two disks fail. data can not be recovered, but, opposed to raid5, the data
  on the remaining disks is still available.
- It is used like a backup tool, with manual invocation.
- There is only one "backup", the latest one, no diff based backlog, like with
  borg.

#### usage

to setup a new array with 2 data disks and 1 parity disk

write this to `/etc/snapraid.conf`

```conf
parity /mnt/parity1/snapraid.parity
content /mnt/disk1/snapraid.content
content /mnt/disk2/snapraid.content
data d1 /mnt/disk1/
data d2 /mnt/disk2/
```

to create a new backup **and override the previous one**

```sh
snapraid sync
```

to recreate the state of the last backup (can also recover deleted files)

```sh
snapraid fix
```

##### after a disk failure

Scenario: disk1 broke

1. immediately stop all services on system, especially `snapraid sync`
2. change `/etc/snapraid.conf`

```diff
parity /mnt/parity1/snapraid.parity
- content /mnt/disk1/snapraid.content
+ content /mnt/replacement_disk/snapraid.content
content /mnt/disk2/snapraid.content
- data d1 /mnt/disk1/
+ data d1 /mnt/replacement_disk/
data d2 /mnt/disk2/
```

3. recreate state of last backup

```sh
snapraid -d d1 -l fix.log fix
```

4. check again

```sh
snapraid -d d1 check
```

5. sync again

```sh
snapraid sync
```

##### add another disk/parity to array

Scenario: add disk3 (works with parity, too)

1. change `/etc/snapraid.conf`

```diff
parity /mnt/parity1/snapraid.parity
content /mnt/disk1/snapraid.content
content /mnt/disk2/snapraid.content
+ content /mnt/disk3/snapraid.content
data d1 /mnt/disk1/
data d2 /mnt/disk2/
+ data d3 /mnt/disk3/
```

2. sync again

```sh
snapraid sync
```
