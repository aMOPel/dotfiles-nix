# Bios update

## Model info

- Model: X1 Carbon 3rd Gen (Type 20BS, 20BT) Laptop (ThinkPad) - Type 20BT
- Serial Number: R90J5HTH

## How to update the bios drivers

- URL to Lenovo driver downloads: <https://pcsupport.lenovo.com/us/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-20bs-20bt/20bt/20bts03y04/r90j5hth/downloads/driver-list/component?name=BIOS%2FUEFI&id=5AC6A815-321D-440E-8833-B07A93E0428C>

1. download the latest `.iso` image
2. unpack the `.iso` with

   ```sh
   nix-shell -p geteltorito
   geteltorito -o boot.img ~/Downloads/n14ur28w.iso
   ```

3. write `.img` to USB drive

   ```sh
   sudo dd if=boot.img bs=128k of=/dev/sdX
   ```

4. Set the BIOS to boot in "UEFI/Legacy: Both"-mode
5. boot from the USB drive

It's possible that the version of the bios is so outdated,
that the latest bios update won't boot.
In that case, try the update with one of the previous versions first.
