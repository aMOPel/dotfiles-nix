# dotfiles-nix

My dotfiles managed by the nix home manager.

## on Non-NixOS

### Setup

1. Install Nix: <https://github.com/DeterminateSystems/nix-installer>

2. Setup home manager

```sh
make home-install
```

3. Fill in `home-manager/config_values.nix`

### Usage

Switch to new config

```sh
make home-switch
```

### Kitty On Non-NixOS Systems

OpenGL in Nix is broken on non-NixOS system, and solutions like the NixGL
wrapper are not fully integrated yet.

Until then, simply use the official kitty installer:

<https://sw.kovidgoyal.net/kitty/binary/>

Or download the binary bundle:

<https://github.com/kovidgoyal/kitty/releases>

Kitty will then be installed twice, and in the terminal the nixos version will
be in the PATH, which can't start a GUI, but runs otherwise.

Make sure to hook up the absolute path of the other kitty install with DE/WM
keymaps.

Also make sure that the versions match, so the configuration doesn't get messed
up

## on NixOS

make sure that the nixpkgs versions in `nix/sources.json` match with the NixOS
version

```sh
make nixos-switch
```
