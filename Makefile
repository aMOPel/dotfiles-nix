
TEST_VM_DIR=./test-vm

.PHONY=build-test-vm
build-test-vm:
	nix-build ${TEST_VM_DIR}/nixos_vm.nix --show-trace

.PHONY=start-test-vm
start-test-vm:
	./result/bin/run-nixos-vm -m 8196 -smp 4 -vga virtio -display gtk

switch:
	nix-shell --run "home-manager switch" ./hm-shell.nix

install:
	nix-shell '<home-manager>' -A install ./hm-shell.nix
