#!/usr/bin/env bash
# Script to search and remove old kernels, Debian+Ubuntu only
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-06-09: First issue
# source: https://forums.linuxmint.com/viewtopic.php?f=46&t=256436

purge() {
    OLDCONF=$(dpkg -l | grep "^rc" | awk '{print $2}')
    echo -e "[+] The following outdated packages have been found:\n$OLDCONF"

    CURKERNEL=$(uname -r | sed 's/-*[a-z]//g' | sed 's/-386//g')
    echo -e "\n[+] The currently used kernel is: $CURKERNEL"

    LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
    METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
    OLDKERNELS=$(dpkg -l | awk '{print $2}' | grep -E $LINUXPKG  | grep -vE $METALINUXPKG | grep -v $CURKERNEL)
    echo -e "\n[+] The following packages will be removed: $OLDKERNELS"

#    sudo apt purge $OLDKERNELS
    echo "[+] Done!"
}

if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" == "debian" ] || [ "$ID_LIKE" == "ubuntu" ]; then
        purge
    fi
else
    OS=$(uname -s)
    VER=$(uname -r)
    ARCH=$(uname -m)
    echo -e "[-] You're running $OS, version $VER on $ARCH"
    echo -e "[-] This command is not applicable here\n"
    exit 1
fi

