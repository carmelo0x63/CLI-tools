#!/usr/bin/env bash
# Downloads and install the latest version of docker-compose
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-12-18: First release

# Setup
#set -Eeuo pipefail
#set -x
BASEURL="https://github.com/docker/compose/releases"
SWDEPOT="$HOME/Downloads"
BINPATH="/usr/local/bin/docker-compose"
# Global variable "OS" is set to match the operating system
if [ "$(uname -s)" == "Linux" ]; then
    OS="Linux"
elif [ "$(uname -s)" == "Darwin" ]; then
    OS="Darwin"
fi
# Global variable "ARCH" is set to match the hardware architecture
if [ "$(uname -m)" == "x86_64" ]; then
    ARCH="x86_64"
#elif [ "$(uname -m)" == "armv6l" ] || [ "$(uname -m)" == "armv7l" ]; then
#    ARCH="armv6l"
#elif [ "$(uname -m)" == "aarch64" ]; then
#    ARCH="arm64"
fi
# Setup ends

echo "[+] Target platform is $OS on $ARCH"

# First off, we check for an existing docker-compose binary on the system
if [ -e "$BINPATH" ]; then
    if [ "$OS" == "Linux" ]; then
        dccurrver="$($BINPATH version | grep -oP "([0-9\\.]+)" | cut -d"." -f1-3 | head -n1)"
    else
        dccurrver="$($BINPATH version | ggrep -oP "([0-9\\.]+)" | cut -d"." -f1-3 | head -n1)"
    fi
    echo "[+] Your current docker-compose version is $dccurrver"
else
    echo "[!] It looks as if you don't have a docker-compose binary on your system"
fi

# We get the latest file name by scraping the download page with curl/grep/head
# Along the process we build the version string and full download URL
echo "[+] Fetching the latest version of docker-compose from $BASEURL"
#if [ "$OS" == "linux" ]; then
#    tffile="$(curl -s "$GETTFURL" | grep -oP "terraform_([0-9\\.]+)\\_$OS\\_$ARCH\\.zip" | head -n1)"
#    lastver=$(echo "$tffile" | grep -oP "([0-9\\.]+)" | head -n1 | cut -d"." -f1-3)
#    tfurl="$GETTFURL1/$lastver/$tffile"
#else
#    tffile="$(curl -s "$GETTFURL" | ggrep -oP "terraform_([0-9\\.]+)\\_$OS\\_$ARCH\\.zip" | head -n1)"
#    lastver=$(echo "$tffile" | ggrep -oP "([0-9\\.]+)" | head -n1 | cut -d"." -f1-3)
#    tfurl="$GETTFURL1/$lastver/$tffile"
#fi
lastver="$(curl -sSL $BASEURL/latest | awk '/<title>/ {print $2}')"
dcfile="docker-compose-$OS-$ARCH-$lastver"
echo "[+] docker-compose: found v. $lastver"

if [ "$dccurrver" == "$lastver" ]; then
    echo "[+] You are up-to-date"
    exit 0
elif [ "$dccurrver" == "" ]; then
    echo "[+] Installing docker-compose $lastver"
else
    echo "[!] Upgrading: $dccurrver -> $lastver "
fi

# The following lines check whether the destination directory exists
if [ -d "$SWDEPOT" ]; then
    echo "[+] Storage \"$SWDEPOT\" exists, saving local copy"
else
    echo "[+] Storage \"$SWDEPOT\" does not exist, creating directory"
    mkdir "$SWDEPOT"
fi

# Likewise, no need to re-download the archive if it's already present
if [ -e "$SWDEPOT/$dcfile" ]; then
    echo "[+] Archive $dcfile already exists"
else
    echo "[+] Downloading $dcfile from $BASEURL..."
    (cd "$SWDEPOT"; curl -LO --progress-bar $BASEURL/download/$lastver/docker-compose-$OS-$ARCH; mv docker-compose-$OS-$ARCH $dcfile)
fi

#sudo cp $SWDEPOT/docker-compose-$OS-$ARCH-$LATEST $BINPATH
#sudo chmod +x /usr/local/bin/docker-compose

