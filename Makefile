.PHONY: switch
home-switch:
	nix develop --extra-experimental-features nix-command -f ./hm-shell.nix --command home-manager switch

.PHONY: install
home-install:
	nix-shell ./hm-install.nix -A install

.PHONY: nixos-switch
nixos-switch:
	nixos-rebuild switch --use-remote-sudo --no-flake --fast -I nixos-config=./nixos/default.nix

.PHONY: nixos-switch-flake
nixos-switch-flake:
	nixos-rebuild switch --use-remote-sudo --fast --flake './nixos#'"$(cat /etc/hostname)"
