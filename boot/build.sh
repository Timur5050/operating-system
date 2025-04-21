#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$SCRIPT_DIR/../build/boot"

dd if=/dev/zero of="$SCRIPT_DIR/../build/boot.img" bs=512 count=20480
nasm -f bin -o "$SCRIPT_DIR/../build/boot/boot.bin" "$SCRIPT_DIR/src/boot.asm"
nasm -f bin -o "$SCRIPT_DIR/../build/boot/loader.bin" "$SCRIPT_DIR/src/loader.asm"
nasm -f bin -o "$SCRIPT_DIR/../build/boot/kernel.bin" "$SCRIPT_DIR/../kernel/src/kernel.asm"
dd if="$SCRIPT_DIR/../build/boot/boot.bin" of="$SCRIPT_DIR/../build/boot.img" bs=512 count=1 conv=notrunc
dd if="$SCRIPT_DIR/../build/boot/loader.bin" of="$SCRIPT_DIR/../build/boot.img" bs=512 count=5 seek=1 conv=notrunc
dd if="$SCRIPT_DIR/../build/boot/kernel.bin" of="$SCRIPT_DIR/../build/boot.img" bs=512 count=100 seek=6 conv=notrunc
