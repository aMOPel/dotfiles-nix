let
  partitionEfi =
    args:
    {
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
    }
    // args;
  partitionLuksLvm =
    args:
    { diskIndex }:
    {
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
    }
    // args;
  partitionBtrfs =
    args: btrgsArgs:
    {
      content = {
        type = "btrfs";
        mountOptions = [
          "defaults"
          "compress=zstd"
          "noatime"
        ];
      }
      // btrgsArgs;
    }
    // args;
  partitionSwap =
    args:
    {
      content = {
        type = "swap";
      };
    }
    // args;
  diskGpt =
    args: gptArgs:
    {
      type = "disk";
      content = {
        type = "gpt";
      }
      // gptArgs;
    }
    // args;
in
{
  disko.devices = {
    disk = {
      disk0 =
        diskGpt
          {
            device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U9NU0YA00981L";
          }
          {
            partitions = {
              ESP = partitionEfi {
                size = "1000M";
                uuid = "46bcb782-a60b-4426-ab49-0f3432549643";
              };
              p1 =
                partitionLuksLvm
                  {
                    size = "100%";
                    uuid = "b2e3e409-7e59-4cc4-91ea-88d09d3e5f96"; # partuuid, not uuid
                  }
                  {
                    diskIndex = 0;
                  };
            };
          };
      disk1 =
        diskGpt
          {
            device = "/dev/disk/by-id/ata-SanDisk_SDSSDA240G_171799447907";
          }
          {
            partitions = {
              p1 =
                partitionLuksLvm
                  {
                    size = "100%";
                    uuid = "3597d698-2379-4e8b-bd5a-c3fdcc2f3b16"; # partuuid, not uuid
                  }
                  {
                    diskIndex = 1;
                  };
            };
          };
      disk2 =
        diskGpt
          {
            device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S21PNXAG977384L";
          }
          {
            partitions = {
              p1 =
                partitionLuksLvm
                  {
                    size = "100%";
                    uuid = "71944308-c58f-4f5f-a434-e1a3149a38c1"; # partuuid, not uuid
                  }
                  {
                    diskIndex = 2;
                  };
            };
          };
    };
    lvm_vg = {
      disk1-pool = {
        type = "lvm_vg";
        lvs = {
          root =
            partitionBtrfs
              {
                size = "100%";
              }
              {
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
          root =
            partitionBtrfs
              {
                size = "100%";
              }
              {
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
          root =
            partitionBtrfs
              {
                size = "200G";
              }
              {
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
          snapraidParity =
            partitionBtrfs
              {
                size = "250G";
              }
              {
                subvolumes = {
                  "/parity" = {
                    mountpoint = "/snapraid/parity";
                  };
                };
              };
          data =
            partitionBtrfs
              {
                size = "100%";
              }
              {
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
