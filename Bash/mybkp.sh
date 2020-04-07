#!/usr/bin/env bash
# Backs-up files to the backup directory
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-04-06: Entirely rewritten by moving files -> array

# Settings
DESTDIR="/tmp"
HOSTNAME=$(hostname -s)
DATE=$(date "+%Y%m%d")
LABEL="xmonad"
OUTFILE="$DESTDIR""/""$HOSTNAME""_""$LABEL""_bkp-""$DATE"
FILES=(\.zshrc \.zsh_history \.vimrc \.screenrc \.sqliterc \.ghci \.xmobarrc \.xmonad/xmonad.hs \.Xresources \.vnc/xstartup /etc/ssh/sshd_config /usr/bin/vncserver)
DIRS=(scripts KVM)

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
        echo "[+] Archiving $1"
        tar -rhf "$OUTFILE".tar "$1" 2>/dev/null
    else
        echo -e "${BLUE}[+]${NC} Skipping file $1..."
    fi
}

echo "+----------------------------------------------------------+"
echo "| Backing up your personal files and settings"
echo "| to the following destination: $OUTFILE.tgz"
echo -e "| ${RED}WARNING${NC}: any existing files with the same names will be"
echo "|          overwritten!"
echo "|          (although that should be just fine)"
echo -e "+----------------------------------------------------------+\n"

if [ "$HOME" != "$PWD" ]; then
    echo -e "${RED}[-]${NC} This command is best run from your HOME directory!"
fi

echo -e "[+] Creating empty output file: $OUTFILE.tar\n"
tar -cf "$OUTFILE".tar -T /dev/null

echo "[+] Archiving ${#DIRS[@]} directories."
for dir in "${DIRS[@]}"; do
    if [ -d "$HOME"/"$dir" ]; then
        archive "$HOME"/"$dir"
    else
        echo -e "${BLUE}[+]${NC} Skipping ~/""$dir""/ directory..."
    fi
done

echo

echo "[+] Archiving ${#FILES[@]} files."
for file in "${FILES[@]}"; do
    if [ "${file:0:1}" == "." ]; then
        archive "$HOME"/"$file"
    elif [ "${file:0:1}" == "/" ]; then
        archive "$file"
    fi
done

echo -e "\n[+] Compressing $OUTFILE.tar..."
gzip "$OUTFILE".tar

echo -e "[+] Backup complete!!!\n"

echo "+----------------------------------------------------------------------------+"
echo "| Additionally you may want to:"
echo "| 1. $ cd $DESTDIR"
echo "| 2. $ scp $OUTFILE.tgz carmelo@employees.org:WWW/files/"
echo -e "+----------------------------------------------------------------------------+\n"

