- plan is to use 3-2-1 backup strategy
  - 3 copies
  - 2 medias local
  - 1 media remote (later)

  - local copy with snapraid (parity-based)
    - snapraid will be over 3 4tb partitions, one of which will be parity
    - snapraid `sync` and `scrub` needs to be executed regularly
  - remote copy with borg or restic (file-based), to some cheap rented server

- todo
  - figure out
    - which fs?
    - how could btrfs/zfs snapshots be part of the backup solution
    - more about btrfs
    - when exactly should snapraid syncs and scrubs run? what happens when a
      sync is run? what data is overriden? what data is recoverable?
    - whether to backup server `/home`
    - exactly how do I extend the fs?
      - mergerfs allows for just adding additional partitions into the pool
      - how to add a partition to snapraid?
  - experiment with mergerfs and snapraid on test partitions
    - test a scenario for disk failure and recovery
    - test this scenario of gradual expansion
      https://chatgpt.com/c/692ad5b5-adbc-8328-958e-a1cc6c6a442a
      1. start with one data disk `/data1`, add data to it
      2. add one parity disk `/parity1` to mergerfs and snapraid, sync it
         - test undeleting
           ```sh
           echo "test" > file1
           snapraid sync
           rm file1
           snapraid fix -f file1
           ```
         - test recovery
           ```sh
           # change config to point to spare disk
           # replace: `data d1 /mnt/disk1`
           # with: `data d1 /mnt/sparedisk1/`
           unmount /disk1
           mount /sparedisk1
           snapraid -d d1 -l log.fix fix
           snapraid -d d1 -a check
           snapraid sync
           ```
      3. add another data disk to mergerfs and snapraid, sync parity, add data
         to it
         - test undeleting
         - test recovery

- nixos reference
  <https://github.com/ironicbadger/nix-config/blob/2465b0ca1c6a2638bbbb3ca0b0648d27e2568652/hosts/nixos/morphnix/default.nix>

- phone backup:
  - for contacts:
    - with carddav in radicale
    - into /contacts
  - for calendar:
    - with caldav in radicale
    - into /calendar
  - for app data:
    - with webdav in radicale
    - into /system-backups/pixel-6
  - for user data:
    - with syncthing
    - from downloads, fotos, recording, documents
    - into /user-data/pixel-6
- pc backup:
  - for user data
    - with syncthing
    - from uni, downloads, documents,
- git:
  - move password store
- services:
  - reverse proxy
  - gitea
  - syncthing
  - radicale (with auth)
  - samba share (with auth)
    - every backuped folder is on samba share
  - ssh server (with key-only auth)
  - dns (if necessary)
  - vault warden (maybe)
  - cronjob borg backup to rented server (later)
  - document server e.g. paperless (maybe)
  - foto server e.g. immich (maybe)
  - paperless
  - pastebin clone
  - homer (homepage)
  - prometheus + node exporter
  - grafana
  - log analyzer (goaccess)
- security
  - firewall
  - no ssh password allowed
  - setup user, don't just use root
- disk health:
  - run smartd weekly (with email notification)
  - run snapraid scrub biweekly
- fs layout:
  - on nvme
    - 1gb efi
    - 100gb /root
    - 50gb /home
    - rest /data
  - on other drives
    - all /data
  - mergerfs merges all /data partitions to single data partition
  - snapraid uses one disk /data for parity
  - underlying filesystem: ext4
  -
