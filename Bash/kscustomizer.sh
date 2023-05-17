#!/usr/bin/env bash
# Generates a Kickstart file from a template with some essential customizations
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2023-05-17: First release

TEMPLATENAME="ks-template-v9.tmpl"
DESTDIR="$HOME/KVM"
# source: https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo -en "Enter hostname: "
read HOSTNAME
echo -en "Enter 1st interface IP address: "
read IPADDR1
echo -en "Enter 2nd interface IP address: "
read IPADDR2

echo -n "[!] Generating 'ks-${HOSTNAME}.cfg' from template... "
cp "$SCRIPT_DIR/$TEMPLATENAME" "ks-${HOSTNAME}.cfg"
sed -i "s/THISHOSTNAME/${HOSTNAME}/" "ks-${HOSTNAME}.cfg"
echo "done!"

echo -n "[!] Customizing 1st interface... "
sed -i "s/THISIPADDR1/${IPADDR1}/" "ks-${HOSTNAME}.cfg"
echo "done!"

echo -n "[!] Customizing 2nd interface... "
sed -i "s/THISIPADDR2/${IPADDR2}/" "ks-${HOSTNAME}.cfg"
echo "done!"

echo "[+] Customization complete!"

if [ -f "$DESTDIR/ks-${HOSTNAME}.cfg" ]; then
    echo "[-] $DESTDIR/ks-${HOSTNAME}.cfg is already present"
    echo "[-] Skipping copy/move!!!"
else
    echo "[+] ks-${HOSTNAME}.cfg does not exist inside the destination directory"
    echo -n "[+] Moving file into $DESTDIR... "
    mv "ks-${HOSTNAME}.cfg" "${DESTDIR}"
    echo "OK!"
fi

