.PHONY: hm-switch
hm-switch:
	nix develop --extra-experimental-features flakes --extra-experimental-features nix-command .#hmShell --command home-manager switch --flake .

.PHONY: nixos-switch
nixos-switch:
	nixos-rebuild switch --use-remote-sudo --fast --flake '.#'$$(cat /etc/hostname)
