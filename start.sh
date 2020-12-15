xhyve \
    -A \
    -m 1G \
    -s 0,hostbridge \
    -s 2,virtio-net \
    -s 31,lpc \
    -l com1,stdio \
    -f "kexec,boot/vmlinuzfocal64,boot/initrd.gz,earlyprintk=serial console=ttyS0"
