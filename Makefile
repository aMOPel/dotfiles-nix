.PHONY: nixos-switch-flake
nixos-switch-flake:
	nixos-rebuild switch --use-remote-sudo --fast --flake '.#'$$(cat /etc/hostname)
