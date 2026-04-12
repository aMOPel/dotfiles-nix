let
  partitionEfi =
    { size }:
    {
      inherit size;
      type = "EF00";
      priority = 0;
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        mountOptions = [
          "fmask=0022"
          "dmask=0022"
        ];
      };
    };
  partitionLuksLvm =
    { size, diskIndex }:
    {
      inherit size;
      label = "disk${builtins.toString diskIndex}-p1";
      content = {
        type = "luks";
        name = "disk${builtins.toString diskIndex}-crypted";
        settings = {
          # if you want to use the key for interactive login be sure there is no trailing newline
          # for example use `echo -n "password" > /tmp/secret.key`
          keyFile = "/tmp/secret.key";
          allowDiscards = true;
        };
        content = {
          type = "lvm_pv";
          vg = "disk${builtins.toString diskIndex}-pool";
        };
      };
    };
  partitionBtrfs =
    { size, subvolumes }:
    {
      inherit size;
      content = {
        type = "btrfs";
        mountOptions = [
          "defaults"
          "compress=zstd"
          "noatime"
        ];
        inherit subvolumes;
      };
    };
  partitionSwap =
    { size }:
    {
      inherit size;
      content = {
        type = "swap";
      };
    };
  diskGpt =
    { device, partitions }:
    {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        inherit partitions;
      };
    };
in
{
  disko.devices = {
    disk = {
      disk0 = diskGpt {
        device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U9NU0YA00981L";
        partitions = {
          ESP = partitionEfi {
            size = "1000M";
          };
          p1 = partitionLuksLvm {
            size = "100%";
            diskIndex = 0;
          };
        };
      };
      disk1 = diskGpt {
        device = "/dev/disk/by-id/ata-SanDisk_SDSSDA240G_171799447907";
        partitions = {
          p1 = partitionLuksLvm {
            size = "100%";
            diskIndex = 1;
          };
        };
      };
      disk2 = diskGpt {
        device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S21PNXAG977384L";
        partitions = {
          p1 = partitionLuksLvm {
            size = "100%";
            diskIndex = 2;
          };
        };
      };
    };
    lvm_vg = {
      disk1-pool = {
        type = "lvm_vg";
        lvs = {
          root = partitionBtrfs {
            size = "100%";
            subvolumes = {
              "/sub1" = {
                mountpoint = "/snapraid/disk1";
              };
            };
          };
        };
      };
      disk2-pool = {
        type = "lvm_vg";
        lvs = {
          root = partitionBtrfs {
            size = "100%";
            subvolumes = {
              "/sub1" = {
                mountpoint = "/snapraid/disk2";
              };
            };
          };
        };
      };
      disk0-pool = {
        type = "lvm_vg";
        lvs = {
          swap = partitionSwap {
            size = "16G";
          };
          root = partitionBtrfs {
            size = "200G";
            subvolumes = {
              "/root" = {
                mountpoint = "/";
              };
              "/home" = {
                mountpoint = "/home";
              };
              "/nix" = {
                mountpoint = "/nix";
              };
            };
          };
          snapraidParity = partitionBtrfs {
            size = "250G";
            subvolumes = {
              "/parity" = {
                mountpoint = "/snapraid/parity";
              };
            };
          };
          data = partitionBtrfs {
            size = "100%";
            subvolumes = {
              "/data" = {
                mountpoint = "/data";
              };
            };
          };
        };
      };
    };
  };
}
