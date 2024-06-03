
SHELL=/bin/bash

TEST_VM_DIR=./test-vm

.PHONY=build-test-vm
build-test-vm:
	nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=${TEST_VM_DIR}/nixpkgs.nix -I nixos-config=${TEST_VM_DIR}/configuration.nix

.PHONY=start-test-vm
start-test-vm: build-test-vm
	./result/bin/run-nixos-vm &>/dev/null &
