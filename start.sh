xhyve \
    -A \
    -m 1G \
    -s 0:0,hostbridge \
    -s 31,lpc \
    -l com1,stdio \
    -f kexec,boot/vmlinuz,boot/initrd.gz,"earlyprintk=serial console=ttyS0"
