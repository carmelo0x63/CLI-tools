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
TFPATH="/usr/local/bin/docker-compose"
# Global variable "OS" is set to match the operating system
if [ "$(uname -s)" == "Linux" ]; then
    OS="Linux"
elif [ "$(uname -s)" == "Darwin" ]; then
    OS="darwin"
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

LATEST="$(curl -sSL $BASEURL/latest | awk '/<title>/ {print $2}')"
echo $LATEST
echo $BASEURL/download/$LATEST/docker-compose-$OS-$ARCH

(cd "$SWDEPOT"; curl -LO --progress-bar $BASEURL/download/$LATEST/docker-compose-$OS-$ARCH; mv docker-compose-$OS-$ARCH docker-compose-$OS-$ARCH-$LATEST)

sudo cp $SWDEPOT/docker-compose-$OS-$ARCH-$LATEST /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

