.PHONY: all
all:
	echo "not implemented"

.PHONY: test
test:
	echo "not implemented"

.PHONY: clean
clean:
	echo "not implemented"

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

.PHONY: clean-boot-entries
clean-boot-entries:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
	sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system +4
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
	nixos-rebuild switch --use-remote-sudo --fast --flake '.#'$$(cat /etc/hostname)
