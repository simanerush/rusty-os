LIBRUSTYOS=target/riscv64gc-unknown-none-elf/debug/librustyos.a

build:
	cargo build
	riscv64-unknown-elf-ld -Thello.ld $(LIBRUSTYOS) -o hello.ELF

run: build
	echo "Ctrl-a x to quit qemu"
	echo "Ctrl-a c to start qemu console, 'info registers' shows the current registers"
	qemu-system-riscv64 \
		-machine virt \
		-m 2G \
		-bios none \
		-nographic \
		-kernel hello.ELF

clean:
	cargo clean
	rm -rf src/*.o
	rm -rf hello.ELF
