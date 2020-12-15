#!/usr/bin/env bash


PatchCore() {
  mkdir -p initrd
  ( cd initrd ; zcat < ../dCore*.gz | sudo cpio -idm )
  sudo gsed -i '/^# ttyS0$/s#^..##' initrd/etc/securetty 
  sudo gsed -i '/^tty1:/s#tty1#ttyS0#g' initrd/etc/inittab
  ( cd initrd ; find . | sudo cpio -o -H newc ) | gzip -c > initrd.gz
}

MakeDisk() {
  if [ -f tmp.iso ]; then
    rm -rf tmp.iso
  fi
  dd if=/dev/zero of=tmp.iso bs=$[2*1024] count=1
  dd if="$1" bs=$[2*1024] skip=1 >> tmp.iso

  diskinfo=$(hdiutil attach tmp.iso)
  mnt=$(echo "$diskinfo" | perl -ne '/(\/Volumes.*)/ and print $1')
  echo $mnt
}

CopyBootFiles() {
  # this will copy vmlinuz and the initramfs
  cp $mnt/vmlinuz* boot
  cp $mnt/dCore* boot
}

CleanDisk() {
  disk=$(echo "$diskinfo" |  cut -d' ' -f1)
  hdiutil eject "$disk"
  rm tmp.iso
}

set -euo pipefail

if [ -z "$1" ]; then
    echo "missing path to iso"
    exit 1
fi

mnt=
diskinfo=

Main() {
  mkdir -p boot

  MakeDisk $1

  CopyBootFiles

  (cd boot;PatchCore)

  CleanDisk
}


Main $1


