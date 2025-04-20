#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' 

bash boot/build.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}[!] error while exec build.sh${NC}"
    exit 1
fi

IMG_PATH="$(realpath build/boot.img)"
LOG_PATH="$(realpath logs/bochslog.txt)"

if [ ! -f "$IMG_PATH" ]; then
    echo -e "${RED}[!] $IMG_PATH not found ${NC}"
    exit 1
fi

TMP_BOCHSRC="config/bochsrc.tmp"
cp config/bochsrc "$TMP_BOCHSRC"

sed -i "s|path=.*|path=\"$IMG_PATH\"|" "$TMP_BOCHSRC"
sed -i "s|log: .*|log: $LOG_PATH|" "$TMP_BOCHSRC"

echo -e "${GREEN}[*] running bochs ${NC}"
bochs -f "$TMP_BOCHSRC"
