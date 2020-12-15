mkdir initrd
( cd initrd ; zcat < ../core.gz | sudo cpio -idm )
sudo gsed -i '/^# ttyS0$/s#^..##' initrd/etc/securetty 
sudo gsed -i '/^tty1:/s#tty1#ttyS0#g' initrd/etc/inittab
( cd initrd ; find . | sudo cpio -o -H newc ) | gzip -c > initrd.gz
