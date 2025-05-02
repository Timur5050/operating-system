#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$SCRIPT_DIR/../build/boot"

dd if=/dev/zero of="$SCRIPT_DIR/../build/boot.img" bs=512 count=20480
nasm -f bin -o "$SCRIPT_DIR/../build/boot/boot.bin" "$SCRIPT_DIR/src/boot.asm"
nasm -f bin -o "$SCRIPT_DIR/../build/boot/loader.bin" "$SCRIPT_DIR/src/loader.asm"
nasm -f elf64 -o "$SCRIPT_DIR/../build/kernel/kernel.o" "$SCRIPT_DIR/../kernel/src/core/kernel.asm"
nasm -f elf64 -o "$SCRIPT_DIR/../build/kernel/trapa.o" "$SCRIPT_DIR/../kernel/src/interrupts/trap.asm"
nasm -f elf64 -o "$SCRIPT_DIR/../build/kernel/liba.o" "$SCRIPT_DIR/../kernel/src/lib/lib.asm"
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone \
    -c "$SCRIPT_DIR/../kernel/src/core/main.c" -o "$SCRIPT_DIR/../build/kernel/main.o"
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone \
    -c "$SCRIPT_DIR/../kernel/src/interrupts/trap.c" -o "$SCRIPT_DIR/../build/kernel/trap.o"
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone \
    -c "$SCRIPT_DIR/../kernel/src/print_function/print.c" -o "$SCRIPT_DIR/../build/kernel/print.o"
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone \
    -c "$SCRIPT_DIR/../kernel/src/assertion/debug.c" -o "$SCRIPT_DIR/../build/kernel/debug.o"
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone \
    -c "$SCRIPT_DIR/../kernel/src/memory_management/memory.c" -o "$SCRIPT_DIR/../build/kernel/memory.o"
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone \
    -c "$SCRIPT_DIR/../kernel/src/process/process.c" -o "$SCRIPT_DIR/../build/kernel/process.o"
ld -nostdlib -T "$SCRIPT_DIR/../kernel/src/link.lds" -o "$SCRIPT_DIR/../build/kernel/kernel.elf" \
    "$SCRIPT_DIR/../build/kernel/kernel.o" "$SCRIPT_DIR/../build/kernel/main.o" \
    "$SCRIPT_DIR/../build/kernel/trapa.o" "$SCRIPT_DIR/../build/kernel/trap.o" \
    "$SCRIPT_DIR/../build/kernel/liba.o" "$SCRIPT_DIR/../build/kernel/print.o" \
    "$SCRIPT_DIR/../build/kernel/debug.o" "$SCRIPT_DIR/../build/kernel/memory.o" \
    "$SCRIPT_DIR/../build/kernel/process.o"
objcopy -O binary "$SCRIPT_DIR/../build/kernel/kernel.elf" "$SCRIPT_DIR/../build/kernel/kernel.bin"
dd if="$SCRIPT_DIR/../build/boot/boot.bin" of="$SCRIPT_DIR/../build/boot.img" bs=512 count=1 conv=notrunc
dd if="$SCRIPT_DIR/../build/boot/loader.bin" of="$SCRIPT_DIR/../build/boot.img" bs=512 count=5 seek=1 conv=notrunc
dd if="$SCRIPT_DIR/../build/kernel/kernel.bin" of="$SCRIPT_DIR/../build/boot.img" bs=512 count=100 seek=6 conv=notrunc
