#!/usr/bin/env zsh
# Iterates through the local repositories, assumed to be under TARGETDIR
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2022-01-12: Refactored for ZSH
#  2020-04-06: First release

# Settings
SEPARATOR="==============================================="

echo "[+] Checking your GIT repositories..."
echo

for Repo in ./*(/)
    (
        echo "$SEPARATOR"
        echo "$Repo..."
        cd $Repo
        echo "$SEPARATOR"
        git fetch
        echo -e "$SEPARATOR\n\n"
    )
echo -e "[+] Done!\n"

