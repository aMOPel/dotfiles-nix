# Configuring crkbd r2g keyboard

## VIA

To configure keymaps directly in browser use <https://usevia.app/>, which, on
linux, needs a udev rule to be in place to authorize the current user.

### udev rule on NixOS

1. add `./udev.nix` to `configuration.nix` `imports = []`
2. apply configuration
3. run `sudo udevadm control --reload && sudo udevadm trigger` to reload udev
   rules without restart

### udev rule on Non-NixOS

1. use this one-liner to create the rule:

```sh
export USER_GID=`id -g`; sudo --preserve-env=USER_GID sh -c 'echo "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", MODE=\"0660\", GROUP=\"$USER_GID\", TAG+=\"uaccess\", TAG+=\"udev-acl\"" > /etc/udev/rules.d/92-viia.rules && udevadm control --reload && udevadm trigger'
```

## QMK

### flash firmware

refenrence <https://docs.keeb.io/flashing-firmware>

1. get the latest qmk toolbox (only on windows)
2. upload the json to qmk configurator
3. change the configuration
4. compile the firmware
5. download the firmware
6. open qmk toolbox as admin
7. select `.hex`/`.bin` firmware file and MCU `ATmega32U4`
8. tick auto-flash
9. press reset button on bottom of pcb on one half of split keyboard, and wait
   for it to finish. there should be some output about progess in the
   installation, and not `device not found` messages.
10. unplug first half and plug in second half
11. repeat `9.`
12. done. plug in first (left) half again to use it, since it's the main half,
    otherwise keybindings will be swapped between halves. If step `9.` does not
    work, you might need to reload the drivers in windows, see below.

### reload windows drivers

using <https://zadig.akeo.ie/>

refenrence <https://github.com/qmk/qmk_toolbox/issues/58#issuecomment-800781473>

> This fixed my issue with ATmega32U4 (Tokyo60).
>
> 1. First you need to uninstall the driver from Device Manager,
> 2. Unplug and replug, enter into bootloader mode (L-shift + right-shift + fn +
>    b)
> 3. Follow https://docs.qmk.fm/#/driver_installation_zadig?id=installation here
>    to load libusb-win32 into the recognized device (the one probably named
>    ATm32U4DFU)
> 4. Unplug and replug.
> 5. Then go to QMK toolbox, enter bootloader mode, should see something like
>    "Atmel DFU device connected (libusb0): Atmel Corp. ATm32U4DFU
>    (03EB:2FF4:0000)"
> 6. Then you can flash the VIA hex.
