#!/usr/bin/env bash
# Iterates through the local repositories, assumed to be under TARGETDIR
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-04-06: First release

# Settings
TARGETDIR="$HOME/github"
SEPARATOR="==============================================="

echo "[+] Checking your GIT repositories..."
echo

for Repo in $(ls "$TARGETDIR"); do
        cd "$TARGETDIR"/"$Repo"
        echo "$SEPARATOR"
        echo "$PWD"
        echo "$SEPARATOR"
        git fetch
        echo "$SEPARATOR"
        echo -e "\n"
done

echo -e "[+] Done!\n"

