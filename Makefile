.PHONY: all
all:
.PHONY: clean
clean:
.PHONY: test
test:

.PHONY: hm-switch
hm-switch:
	nix develop --extra-experimental-features flakes --extra-experimental-features nix-command .#hmShell --command home-manager switch --flake .

.PHONY: nixos-switch
nixos-switch:
	nixos-rebuild switch --use-remote-sudo --fast --flake '.#'$$(cat /etc/hostname)


.PHONY: nixos-upgrade
nixos-upgrade:
	nix flake update
	nixos-rebuild boot --use-remote-sudo --fast --flake '.#'$$(cat /etc/hostname)
	sudo reboot

.PHONY: homelab-one-nixos-switch
homelab-one-nixos-switch:
	nixos-rebuild switch --use-remote-sudo --fast --flake '.#homelab-one' --target-host root@homelab-one
