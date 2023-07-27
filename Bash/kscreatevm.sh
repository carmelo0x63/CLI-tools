#!/usr/bin/env bash
# Generates a Virtual Machine from a given Kickstart file`
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2023-07-27: Removed '--os-type'
#  2023-05-17: First release

# Settings
DESTDIR="$HOME/KVM"                          # Kickstart files repository
SEC=5                                        # Countdown timer initial value
#MEM_SIZE=1024                                # Memory setting in MiB
#VCPUS=1                                      # CPU Cores count
#OS_VARIANT="generic"                         # List with osinfo-query os
IMAGES_DIR="/var/lib/libvirt/images"         # Path to images directory
ISO_DIR="/var/lib/libvirt/images2"           # Path to ISO directory
ISO_FILE="AlmaLinux-9.2-x86_64-minimal.iso"  # Path to ISO file

echo -en "Enter Kickstart file name (e.g. 'ks-xxx-yyy.cfg'): "
read KSNAME

if [ ! -f "$DESTDIR/$KSNAME" ]; then
#    echo "[+] Configuration file '$KSNAME exists..."
#else
    echo "[-] '$KSNAME' does not exist inside the destination directory"
    echo -e "[-] Terminating!!!\n"
    exit 255
fi

DOMNAME=${KSNAME%%.*}
DOMNAME=$(tr '[:lower:]' '[:upper:]' <<< ${DOMNAME:3:1})${DOMNAME:4}

virsh list --all --name | grep $DOMNAME &> /dev/null

if [ $? == 0 ]; then
    echo "[-] Domain name '$DOMNAME' exists!"
    echo -e "[-] Terminating!!!\n"
    exit 254
fi

read -p "Enter desired RAM size (1024): " MEM_SIZE
MEM_SIZE=${MEM_SIZE:-1024}

read -p "Enter number of vCPU's (1): " VCPUS
VCPUS=${VCPUS:-1}

read -p "Enter desired disk size (10): " DISK_SIZE
DISK_SIZE=${DISK_SIZE:-10}

read -p "Enter OS variant (almalinux9): " OS_VARIANT
OS_VARIANT=${OS_VARIANT:-almalinux9}

echo "Installing with the following parameters:"
echo "  domain name: ${DOMNAME}"
echo "  RAM size: ${MEM_SIZE}"
echo "  number of vCPU's: ${VCPUS}"
echo "  OS variant: ${OS_VARIANT}"
echo "  disk: ${IMAGES_DIR}/${DOMNAME}.qcow2"
echo "  disk size: ${DISK_SIZE}"
echo "  ISO file: ${ISO_DIR}/${ISO_FILE}"

# Countdown timer
while [ $SEC -ge 0 ]; do
    echo -ne "Wait timer: $SEC\033[0K\r"
    let "SEC=SEC-1"
    sleep 1
done

sudo virt-install \
    --name ${DOMNAME} \
    --memory ${MEM_SIZE} \
    --vcpus ${VCPUS} \
    --os-variant ${OS_VARIANT} \
    --disk path=${IMAGES_DIR}/${DOMNAME}.qcow2,size=${DISK_SIZE} \
    --location ${ISO_DIR}/${ISO_FILE} \
    --network type=direct,source=enp1s0f0,source_mode=bridge,model=rtl8139 \
    --network type=direct,source=enp1s0f1,source_mode=bridge,model=rtl8139 \
    --graphics none \
    --initrd-inject=${DESTDIR}/${KSNAME} \
    --extra-args "inst.ks=file:/${KSNAME} console=ttyS0,115200n8"

