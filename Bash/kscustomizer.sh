#!/usr/bin/env bash
# Generates a Kickstart file from a template with some essential customizations
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2023-11-16: Subnet name moved to a global variable, default IPADDR*
#  2023-05-19: if-then split and re-ordered
#  2023-05-17: First release

TEMPLATENAME="ks-template-v9.tmpl"
DESTDIR="$HOME/KVM"
SUBNETNAME="homenet.lan.internal"
# source: https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! -d "$DESTDIR" ]; then
    echo "[-] Destination directory '${DESTDIR}.cfg' is not present"
    echo -e "[-] Terminating!!!\n"
    exit 10
fi

echo -en "Enter hostname: "
read HOSTNAME

if [ -f "$DESTDIR/ks-${HOSTNAME}.cfg" ]; then
    echo "[-] File 'ks-${HOSTNAME}.cfg' is already present"
    echo "[-] Overwriting not allowed!!!"
    echo -e "[-] Terminating!!!\n"
    exit 20
fi

echo -n "[!] Generating 'ks-${HOSTNAME}.cfg' from template... "
cp "$SCRIPT_DIR/$TEMPLATENAME" "ks-${HOSTNAME}.cfg"
sed -i "s/THISHOSTNAME/${HOSTNAME}-kvm/" "ks-${HOSTNAME}.cfg"
sed -i "s/THISSUBNET/${SUBNETNAME}/" "ks-${HOSTNAME}.cfg"
echo "done!"

read -p "Enter 1st interface IP address (e.g. 198.51.100.117): " IPADDR1
IPADDR1=${IPADDR1:-198.51.100.117}
read -p "Enter 2nd interface IP address (e.g. 192.0.2.117): " IPADDR2
IPADDR2=${IPADDR2:-192.0.2.117}

echo -n "[!] Customizing 1st interface... "
sed -i "s/THISIPADDR1/${IPADDR1}/" "ks-${HOSTNAME}.cfg"
echo "done!"

echo -n "[!] Customizing 2nd interface... "
sed -i "s/THISIPADDR2/${IPADDR2}/" "ks-${HOSTNAME}.cfg"
echo "done!"

echo "[+] Customization complete!"
echo "[+] Destination directory: ${DESTDIR}"

echo -n "[+] Moving file into $DESTDIR... "
mv "ks-${HOSTNAME}.cfg" "${DESTDIR}"
echo -e "OK!\n"

