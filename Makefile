
TEST_VM_DIR=./test-vm

.PHONY: build-test-vm
build-test-vm:
	nix-build ${TEST_VM_DIR}/nixos_vm.nix --show-trace

.PHONY: start-test-vm
start-test-vm:
	./result/bin/run-nixos-vm -m 8196 -smp 4 -vga virtio -display gtk

.PHONY: switch
switch:
	nix-shell --run "home-manager switch" ./hm-shell.nix

.PHONY: install
install:
	nix-shell ./hm-install.nix -A install
