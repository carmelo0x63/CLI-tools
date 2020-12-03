#!/usr/bin/env bash
# Downloads and install the latest version of Terraform
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-12-03: Added  armv6/7 architecture
#  2020-11-29: First release

# Setup
#set -Eeuo pipefail
#set -x
GETTFURL="https://www.terraform.io/downloads.html"
GETTFURL1="https://releases.hashicorp.com/terraform"
SWDEPOT="$HOME/Downloads"
TFPATH="/usr/local/bin/terraform"
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

# First off, we check for an existing terraform binary on the system
if [ -e "$TFPATH" ]; then
    if [ "$OS" == "linux" ]; then
        tfcurrver="$($TFPATH version | grep -oP "([0-9\\.]+)" | cut -d"." -f1-3 | head -n1)"
    else
        tfcurrver="$($TFPATH version | ggrep -oP "([0-9\\.]+)" | cut -d"." -f1-3 | head -n1)"
    fi
    echo "[+] Your current Terraform version is $tfcurrver"
else
    echo "[!] It looks as if you don't have a Terraform binary on your system"
fi

# We get the latest file name by scraping the download page with curl/grep/head
# Along the process we build the version string and full download URL
echo "[+] Fetching the latest version of Terraform from $GETTFURL"
if [ "$OS" == "linux" ]; then
    tffile="$(curl -s "$GETTFURL" | grep -oP "terraform_([0-9\\.]+)\\_$OS\\_$ARCH\\.zip" | head -n1)"
    lastver=$(echo "$tffile" | grep -oP "([0-9\\.]+)" | head -n1 | cut -d"." -f1-3)
    tfurl="$GETTFURL1/$lastver/$tffile"
else
    tffile="$(curl -s "$GETTFURL" | ggrep -oP "terraform_([0-9\\.]+)\\_$OS\\_$ARCH\\.zip" | head -n1)"
    lastver=$(echo "$tffile" | ggrep -oP "([0-9\\.]+)" | head -n1 | cut -d"." -f1-3)
    tfurl="$GETTFURL1/$lastver/$tffile"
fi
echo "[+] Terraform.io: found archive $tffile, v. $lastver"

if [ "$tfcurrver" == "$lastver" ]; then
    echo "[+] You are up-to-date"
    exit 0
elif [ "$tfcurrver" == "" ]; then
    echo "[+] Installing Terraform $lastver"
else
    echo "[!] Upgrading: $tfcurrver -> $lastver "
fi

# The following lines check whether the destination directory exists
if [ -d "$SWDEPOT" ]; then
    echo "[+] Storage \"$SWDEPOT\" exists, saving local copy"
else
    echo "[+] Storage \"$SWDEPOT\" does not exist, creating directory"
    mkdir "$SWDEPOT"
fi

# Likewise, no need to re-download the archive if it's already present
if [ -e "$SWDEPOT/$tffile" ]; then
    echo "[+] Archive $tffile already exists"
else
    echo "[+] Downloading $tffile from $GETTFURL1..."
    (cd "$SWDEPOT"; curl -LO --progress-bar $tfurl)
fi

# The actual installation/upgrade process starts here
if [ "$(id -u)" != "0" ]; then
    echo "[!] sudo credentials are required..."
    sudo -v
fi

if [ -e "$TFPATH" ]; then
    echo "[!] Removing previous installation..."
    sudo rm -f "$TFPATH"
fi

echo "[+] Installing Terraform v. $lastver"
sudo unzip -q "$SWDEPOT"/terraform_"$lastver"_"$OS"_"$ARCH".zip -d /usr/local/bin/
echo "[+] You're now running Terraform v. $lastver"

# Checking the shell's environment is set up correctly
#if [ "$OS" == "linux" ]; then
#    if [ "$(echo "$PATH" | grep -oP '/usr/local/go/bin')" != "/usr/local/go/bin" ]; then
#        echo "[!] Please, make sure your environment contains something such as:"
#        echo -e "[!] export PATH=\$PATH:/usr/local/go/bin"
#    fi
#else
#    if [ "$(echo "$PATH" | ggrep -oP '/usr/local/go/bin')" != "/usr/local/go/bin" ]; then
#        echo "[!] Please, make sure your environment contains something such as:"
#        echo -e "[!] export PATH=\$PATH:/usr/local/go/bin"
#    fi
#fi

