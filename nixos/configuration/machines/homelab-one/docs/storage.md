# storage

## hardware

currently there are 3 ssds builtin:

- sata ssd 250gb
- sata ssd 250gb
- nvme ssd 4tb

when ssd prices drop again, we can upgrade the 250gb ssds to 4tb ssds

## raid

to have some tolerance for disk failure, we use snapraid.

- Snapraid uses parity, like raid5, to protect from disk failure.
- one parity disk with 4tb can protect an array of data disks with 4tb.
- as long as only one disk fails, all data can be recovered.
- if two disks fail. data can not be recovered, but, opposed to raid5, the data
  on the remaining disks is still available. thus it is important to keep the
  physical disks separate before using snapraid on them (don't merge them with
  lvm vg or similar)
- parity calculation is invoked manually, similar to a backup tool.
- There is only one "backup", the latest one, no diff based backlog, like with
  borg.

because the 2 sata ssds are smaller, and with parity we can at most protect as
much as the smallest disk, the 4tb disk has a separate 250gb partition. those 3
250gb partitions are setup with snapraid.

to merge the fs of the 3 ssds together, mergerfs is used.

the rest of the 4tb drive can't be protected with parity until the other drives
are upgraded to 4tb as well.

the important data should go on the snapraid drives.

the `snapraid-mergerfs.nix` module takes care of setting up snapraid data drives
and parity drives, as well as merge the data drives to a single mountpoint.

## luks

each physical disk is encrypted individually, but all with the same passphrase.

## layering

```
physical disk
-> gpt parttions # because some systems expect to find partition tables
-> luks # for disk encryption, as low as possible
-> lvm # for disk abstraction, to avoid physical repartitioning
-> lvm volume groups # but disks need to stay separate for
-> btrfs # for it's performance features
-> btrfs subvolumes #
```

## lsblk

```
NAME                             FSTYPE      FSVER    LABEL UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
sda
└─sda1                           crypto_LUKS 2              cd03e58c-b8cf-4fae-a755-073e64a57f08
  └─cryptdisk1                   LVM2_member LVM2 001       LZocjQ-vh3o-SFdL-7CXw-CZ7g-ZQk1-7RCbmp
    └─disk1--pool-root           btrfs                      89f7d4c4-80cc-482d-8b51-3305701ee87e    221.5G     0% /snapraid/disk1
sdb
└─sdb1                           crypto_LUKS 2              418fcdb0-9edd-425c-8f25-16c45dc52265
  └─cryptdisk2                   LVM2_member LVM2 001       9m1zSe-VVrR-j8AS-mIE3-b1cL-lAhP-ZCa4Tx
    └─disk2--pool-root           btrfs                      ad88c745-5fa0-459d-ae1d-2cae0e2d634a    230.9G     0% /snapraid/disk2
nvme0n1
├─nvme0n1p1                      vfat        FAT32          4D46-3725                               862.2M    14% /boot
└─nvme0n1p2                      crypto_LUKS 2              ca12320a-27ce-4ea8-b440-bec65dd51642
  └─cryptdisk0                   LVM2_member LVM2 001       X3MrH2-CEso-1lJe-nEaE-a2as-4cJc-fEvV0E
    ├─disk0--pool-root           btrfs                      dc52e175-60d8-4811-8798-7614810fd123    189.8G     4% /srv/www
    │                                                                                                             /srv/radicale/collections
    │                                                                                                             /home
    │                                                                                                             /nix/store
    │                                                                                                             /nix
    │                                                                                                             /
    ├─disk0--pool-snapraidParity btrfs                      85042328-41b8-47f1-9f7b-fa3d8eb68991      248G     0% /snapraid/parity
    ├─disk0--pool-swap           swap        1              6f84f967-d26d-4faa-b7b9-531ee0ed057e                  [SWAP]
    └─disk0--pool-data           btrfs                      2a07411b-092d-467d-beb3-900cd18bb339      3.2T     0% /data
```

## data recovery

### on server with snapraid

<https://www.snapraid.it/manual>

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
