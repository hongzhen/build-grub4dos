#!/bin/sh

#Package required:
#   gcc
#   gcc-multilib
#   upx
#   nasm
#   autogen

build_grub4dos() {
    if [ ! -d  "grub4dos" ]; then
        git clone https://github.com/chenall/grub4dos.git grub4dos
    fi


    cd grub4dos

    git branch | grep build > /dev/null

    if [ $? -ne 0 ]; then
        git checkout -b build c34d9a45eae07587a88b316d74667c9fbcdebc50 
    fi

    ./autogen.sh && ./configure && make

    cd -
}

release_grub4dos() {
    TEMP=`tempfile`

    cat << EOF > $TEMP
ChangeLog
ChangeLog_GRUB4DOS.txt
ChangeLog_chenall.txt
README
COPYING
README_GRUB4DOS.txt
README_GRUB4DOS_CN.txt
stage2/badgrub.exe
stage2/bootlace.com
stage2/eltorito.sys
stage2/grldr
stage2/grldr.mbr
stage2/grldr.pbr
stage2/grldr_cd.bin
stage2/grub.exe
stage2/hmload.com
ipxegrldr.ipxe
config.sys
default
menu.lst
EOF

    mkdir -p dist
    rsync --files-from=$TEMP grub4dos dist
}

case $1 in
    build) build_grub4dos;;
    release) release_grub4dos;;
    *) build_grub4dos && release_grub4dos;;
esac

