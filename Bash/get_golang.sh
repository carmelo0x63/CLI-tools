#!/usr/bin/env bash
# Downloads and install the latest version of Go/Golang
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2022-01-06: Replaced golang.org with go.dev
#  2021-03-07: Fixed a bug due to the length of Go version
#  2020-12-03: Added armv6/7 architecture
#  2020-09-25: Added platform check: Mac/Linux, amd64, arm64
#  2020-09-24: First release

# Setup
#set -Eeuo pipefail
#set -x
GETGOURL="https://go.dev"
SWDEPOT="$HOME/Downloads"
GOPATH="/usr/local/go"
# Global variable "OS" is set to match the operating system
if [ "$(uname -s)" == "Linux" ]; then
    OS="linux"
elif [ "$(uname -s)" == "Darwin" ]; then
    OS="darwin"
fi
# Global variable "ARCH" is set to match the hardware architecture
if [ "$(uname -m)" == "x86_64" ]; then
    ARCH="amd64"
elif [ "$(uname -m)" == "armv6l" ] || [ "$(uname -m)" == "armv7l" ]; then
    ARCH="armv6l"
elif [ "$(uname -m)" == "aarch64" ]; then
    ARCH="arm64"
fi
# Setup ends

echo "[+] Target platform is $OS on $ARCH"

# First off, we check for an existing go binary on the system
if [ -d "$GOPATH" ]; then
    if [ "$OS" == "linux" ]; then
        gocurrver="$($GOPATH/bin/go version | grep -oP "([0-9\\.]+)" | cut -d"." -f1-3 | head -n1)"
    else
        gocurrver="$($GOPATH/bin/go version | ggrep -oP "([0-9\\.]+)" | cut -d"." -f1-3 | head -n1)"
    fi
    echo "[+] Your current Go/Golang version is $gocurrver"
else
    echo "[!] It looks as if you don't have a Go binary on your system"
fi

# We get the latest file name by scraping the download page with curl/grep/head
# Along the process we build the version string and full download URL
echo "[+] Fetching the latest version of Go/Golang from $GETGOURL"
if [ "$OS" == "linux" ]; then
    gofile="$(curl -s "$GETGOURL"/dl/ | grep -oP "go([0-9\\.]+)\\.$OS-$ARCH\\.tar\\.gz" | head -n1)"
    gourl="$GETGOURL/dl/$gofile"
    lastverlen="$(awk -F"." '{print NF-1}' <<< $gofile)"  # "1.16" -> "4", "1.16.0" -> "5"
    if [ "$lastverlen" == "5" ]; then
        lastver=$(echo "$gofile" | grep -oP "([0-9\\.]+)" | head -n1 | cut -d"." -f1-3)
    else
        lastver=$(echo "$gofile" | grep -oP "([0-9\\.]+)" | head -n1 | cut -d"." -f1-2)
    fi
else
    gofile="$(curl -s "$GETGOURL"/dl/ | ggrep -oP "go([0-9\\.]+)\\.$OS-$ARCH\\.tar\\.gz" | head -n1)"
    gourl="$GETGOURL/dl/$gofile"
    lastverlen="$(awk -F"." '{print NF-1}' <<< $gofile)"  # "1.16" -> "4", "1.16.0" -> "5"
    if [ "$lastverlen" == "5" ]; then
        lastver=$(echo "$gofile" | ggrep -oP "([0-9\\.]+)" | head -n1 | cut -d"." -f1-3)
    else
        lastver=$(echo "$gofile" | ggrep -oP "([0-9\\.]+)" | head -n1 | cut -d"." -f1-2)
    fi
fi
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
    echo "[+] Storage \"$SWDEPOT\" exists, saving local copy"
else
    echo "[+] Storage \"$SWDEPOT\" does not exist, creating directory"
    mkdir "$SWDEPOT"
fi

# Likewise, no need to re-download the archive if it's already present
if [ -e "$SWDEPOT/$gofile" ]; then
    echo "[+] Archive $gofile already exists"
else
    echo "[+] Downloading $gofile from $GETGOURL..."
    (cd "$SWDEPOT"; curl -LO --progress-bar $gourl)
fi

# The actual installation/upgrade process starts here
if [ "$(id -u)" != "0" ]; then
    echo "[!] sudo credentials are required..."
    sudo -v
fi

if [ -d "$GOPATH" ]; then
    echo "[!] Removing previous installation..."
    sudo rm -rf "$GOPATH"
fi

echo "[+] Installing Go/Golang v. $lastver"
sudo tar -xzf "$SWDEPOT/go$lastver".$OS-$ARCH.tar.gz -C /usr/local/
echo "[+] You're now running Go v. $lastver"

# Checking the shell's environment is set up correctly
if [ "$OS" == "linux" ]; then
    if [ "$(echo "$PATH" | grep -oP '/usr/local/go/bin')" != "/usr/local/go/bin" ]; then
        echo "[!] Please, make sure your environment contains something such as:"
        echo -e "[!] export PATH=\$PATH:/usr/local/go/bin"
    fi
else
    if [ "$(echo "$PATH" | ggrep -oP '/usr/local/go/bin')" != "/usr/local/go/bin" ]; then
        echo "[!] Please, make sure your environment contains something such as:"
        echo -e "[!] export PATH=\$PATH:/usr/local/go/bin"
    fi
fi

