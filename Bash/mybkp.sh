#!/usr/bin/env bash
# Backs-up files to the backup directory
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2024-10-22: Added `Private CA`
#  2023-01-07: Added `pass` data (https://www.passwordstore.org/)
#  2022-10-06: Added GPG data
#  2021-04-19: Added kubeconfig
#  2021-03-07: Added conky.conf (BunsenLabs Linux)
#  2021-01-12: Shrunk OMZ backup to custom/ only
#  2021-01-08: Added ~/.ssh, private + public keys
#  2020-04-14: Polished output, added more items to FILES
#              (also split on multiple lines) and DIRS
#  2020-04-06: Entirely rewritten by moving files -> array

# Settings
DESTDIR="/tmp"
HOSTNAME=$(hostname -s)
DATE=$(date "+%Y%m%d")
LABEL="LABEL"
OUTFILE="$DESTDIR""/""$HOSTNAME""_""$USER""_""$LABEL""_bkp-""$DATE"
# Individual files, full path
FILES=(\.zshrc \.zsh_history
       \.bashrc \.profile \.bash_history
       \.vimrc \.screenrc \.sqliterc
       \.kube/config
       /etc/ssh/sshd_config
       /etc/profile /etc/profile/colorls.sh
       /etc/ansible/ansible.cfg /etc/ansible/hosts
       \.ghci \.xmobarrc \.xmonad/xmonad.hs
       \.Xresources \.vnc/xstartup /usr/bin/vncserver
       \.config/conky/conky.conf)
# Directories, relative to $HOME
DIRS=(scripts \.ssh \.rsync \.gnupg
      \.password-store \.oh-my-zsh/custom
      KVM YAML HCL
      Private\ CA)

# Colors, ANSI escape codes
# source: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
RED="\033[0;31m"
GREEN="\033[0;32m"
ORANGE="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
NC="\033[0m"         # No Color

#set -x

archive() {
    if [ -e "$1" ]; then
        echo -e "${GREEN}[+]${NC} Archiving $1"
        tar --exclude=.terraform -rhf "$OUTFILE".tar "$1" 2>/dev/null
    else
        echo -e "${BLUE}[+]${NC} Skipping file $1..."
    fi
}

echo "+----------------------------------------------------------+"
echo "| Backing up your personal files and settings"
echo "| to the following destination:"
echo -e "|\t\t$OUTFILE.tar.gz"
echo -e "| ${RED}WARNING${NC}: any existing files with the same names will"
echo "|          be overwritten!"
echo "|          (although that should be just fine)"
echo -e "+----------------------------------------------------------+\n"

if [ "$HOME" != "$PWD" ]; then
    echo -e "${RED}[-]${NC} This command is best run from your HOME directory!"
fi

echo -e "[+] Creating empty output file: $OUTFILE.tar\n"
tar -cf "$OUTFILE".tar -T /dev/null

echo "[+] Attempting to archive ${#DIRS[@]} directories."
for dir in "${DIRS[@]}"; do
    if [ -d "$HOME"/"$dir" ]; then
        archive "$HOME"/"$dir"
    else
        echo -e "${BLUE}[+]${NC} Skipping ~/""$dir""/ directory..."
    fi
done

echo

echo "[+] Attempting to archive ${#FILES[@]} files."
for file in "${FILES[@]}"; do
    if [ "${file:0:1}" == "." ]; then
        archive "$HOME"/"$file"
    elif [ "${file:0:1}" == "/" ]; then
        archive "$file"
    fi
done

echo -e "\n[+] Compressing $OUTFILE.tar.gz ..."
gzip "$OUTFILE".tar

echo -e "[+] Backup complete!!!\n"

echo "+--------------------------------------------------------------------+"
echo "| Additionally you may want to:"
echo "| 1. $ cd $DESTDIR"
echo "| 2. $ scp $OUTFILE.tar.gz <user>@<server>:<path>"
echo -e "+--------------------------------------------------------------------+\n"

