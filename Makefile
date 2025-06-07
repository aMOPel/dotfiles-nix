.PHONY: nixos-switch-flake
nixos-switch-flake:
	nixos-rebuild switch --use-remote-sudo --fast --flake './nixos#'$$(cat /etc/hostname)
