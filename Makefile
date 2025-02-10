
TEST_VM_DIR=./test-vm

.PHONY: build-test-vm
build-test-vm:
	nix-build ${TEST_VM_DIR}/nixos_vm.nix --show-trace

.PHONY: start-test-vm
start-test-vm:
	./result/bin/run-nixos-vm -m 8196 -smp 4 -vga virtio -display gtk

.PHONY: switch
switch:
	nix develop --extra-experimental-features nix-command -f ./hm-shell.nix --command home-manager switch

.PHONY: install
install:
	nix-shell ./hm-install.nix -A install
