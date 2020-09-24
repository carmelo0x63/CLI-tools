#!/usr/bin/env bash
# Downloads and install the latest version of Go/Golang
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-09-24: First release

# Settings
#set -Eeuo pipefail
#set -x
GETGOURL="https://golang.org"
SWDEPOT="$HOME/Downloads"
GOPATH="/usr/local/go"

# First off, we check for an existing go binary on the system
if [ -d "$GOPATH" ]; then
#    gocurrver="$(cat /usr/local/go/VERSION)"
    gocurrver="$($GOPATH/bin/go version | grep -oP "([0-9\\.]+)" | cut -d"." -f1-3 | head -n1)"
    echo "[+] Your current Go/Golang version is $gocurrver"
else
    echo "[!] It looks as if you don't have a Go binary on your system"
fi

# We get the latest file name by scraping the download page with curl/grep/head
# Along the process we build the version string and full download URL
echo "[+] Fetching the latest version of Go/Golang from $GETGOURL"
gofile="$(curl -s "$GETGOURL"/dl/ | grep -oP 'go([0-9\\.]+)\.linux-amd64\.tar\.gz' | head -n1)"
gourl="$GETGOURL/dl/$gofile"
lastver=$(echo "$gofile" | grep -oP "([0-9\\.]+)" | head -n1 | cut -d"." -f1-3)
echo "[+] Golang.org: found archive $gofile, v. $lastver"

if [ "$gocurrver" == "$lastver" ]; then
    echo "[+] You are up-to-date"
    exit 0
elif [ "$gocurrver" == "" ]; then
    echo "[+] Installing Go $lastver"
else
    echo "[!] Upgrading: $gocurrver -> $lastver "
fi

# The following lines check whether the destination directory exists
if [ -d "$SWDEPOT" ]; then
    echo "[+] $SWDEPOT exists, storing archive locally"
else
    echo "[+] $SWDEPOT does not exist, creating directory"
    echo "mkdir $SWDEPOT"
fi

# Likewise, no need to re-download the archive if it's already present
if [ -e "$SWDEPOT/$gofile" ]; then
    echo "[+] File $gofile already exists"
else
    echo "[+] Downloading..."
    (cd "$SWDEPOT"; curl -LO --progress-bar $gourl)
fi

# The actual installation/upgrade process starts here
if [ "$(id -u)" != "0" ]; then
    echo "[!] .. sudo credentials are required"
    sudo -v
fi

if [ -d "$GOPATH" ]; then
    echo "[!] Removing previous installation..."
    sudo rm -rf "$GOPATH"
fi

echo "[+] Installing Go/Golang v. $lastver"
sudo tar -xzf "$SWDEPOT/go$lastver".linux-amd64.tar.gz -C /usr/local/
echo "[+] You're now running Go v. $lastver"

# Checking the shell's environment is set up correctly
if [ "$(echo "$PATH" | grep -oP '/usr/local/go/bin')" != "/usr/local/go/bin" ]; then
    echo "[!] Please, make sure your environment contains something such as:"
    echo -e "[!] export PATH=\$PATH:/usr/local/go/bin"
fi

