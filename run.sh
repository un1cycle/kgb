rm engine86.iso

nasm -f bin src/boot.asm -o boot.bin
nasm -f bin src/kernel.asm -o kernel.bin

dd if=/dev/zero of=engine86.iso bs=1M count=1
dd if=boot.bin of=engine86.iso conv=notrunc
dd if=kernel.bin of=engine86.iso seek=1 conv=notrunc

qemu-system-x86_64 -enable-kvm -cpu host -smp 22 -drive format=raw,file=engine86.iso -no-reboot -d int,cpu_reset -vga std

rm boot.bin
rm kernel.bin
