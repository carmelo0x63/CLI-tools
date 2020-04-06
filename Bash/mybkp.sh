#!/bin/bash
# Backs-up files to the backup directory
# author: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-04-06: Entirely rewritten by moving files -> array

# Settings
DESTDIR="/tmp"
HOSTNAME=$(hostname -s)
DATE=$(date "+%Y%m%d")
LABEL="xmonad"
OUTFILE="$DESTDIR""/""$HOSTNAME""_""$LABEL""_bkp-""$DATE"
FILES=(\.zshrc \.zsh_history \.vimrc \.screenrc \.sqliterc \.ghci \.xmobarrc \.xmonad/xmonad.hs \.Xresources \.vnc/xstartup /etc/ssh/sshd_config /usr/bin/vncserver)

#set -x

archive() {
    echo "[+] Archiving $1"
    tar -rhf "$OUTFILE".tar "$1" 2>/dev/null
}

echo "+----------------------------------------------------------+"
echo "| Backing up your personal files and settings"
echo "| to the following destination: $OUTFILE.tgz"
echo "| WARNING: any existing files with the same names will be"
echo "|          overwritten!"
echo "|          (although that should be just fine)"
echo -e "+----------------------------------------------------------+\n"

if [ "$HOME" != "$PWD" ]; then
    echo "[-] This command is best run from your HOME directory!"
fi

echo "[+] Output file: $OUTFILE.tgz"
echo "[+] Archiving ${#FILES[@]} elements."
echo "[+] Archiving ~/scripts/ directory..."
tar -cf "$OUTFILE".tar "$HOME"/scripts/ 2>/dev/null

for file in "${FILES[@]}"; do
    if [ "${file:0:1}" == "." ]; then
        if [ -e "$HOME/$file" ]; then
            archive "$HOME"/"$file"
        fi
    elif [ "${file:0:1}" == "/" ]; then
        if [ -e "$file" ]; then
            archive "$file"
        fi
    fi
done

echo "[+] Compressing..."
gzip "$OUTFILE".tar

echo -e "[+] Backup complete!!!\n"

echo "+----------------------------------------------------------------------------+"
echo "| Additionally you may want to:"
echo "| 1. $ cd $DESTDIR"
echo "| 2. $ scp $OUTFILE.tgz carmelo@employees.org:WWW/files/"
echo -e "+----------------------------------------------------------------------------+\n"

