#!/usr/bin/env bash
# Creates custom SSHd/systemd configurations to allow multiple
# instances of OpenSSH server to run on separate ports
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2025-06-11: First release

# Setup
#set -Eeuo pipefail
#set -x

# Settings
VERSION="1.0"
CONFIG_ORI="/etc/ssh/sshd_config"
SERVICE_ORI="/lib/systemd/system/ssh"

# ANSI colors
RED="\033[0;31m"     # red = Error
GREEN="\033[0;32m"   # green = OK
ORANGE="\033[0;33m"  # orange = Warning
NC="\033[0m"         # No Color


usage() {
    echo "Usage: ${0##*/} [command] <destination_port>"
    echo "Command list:"
    echo -e "\t-h: Help"
    echo -e "\t-V: Version"
    echo -e "\t-p: Port number\n"
}


main() {
    # Check whether the script is run as root or with sudo
    if [ "$EUID" -ne 0 ]; then
        echo -e "$ORANGE[-]$NC This script must be run as root or with sudo\n"
        exit 255
    fi

    echo -e "$GREEN[+]$NC Destination port: $DST_PORT\n"

    sudo ss -tunal | grep "$DST_PORT" &>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "$RED[!]$NC Port $DST_PORT is in use"
        echo -e "$RED[!]$NC Please, choose a different port"
	exit 250
    fi

    # Duplicate sshd_config
    echo -e "$GREEN[+]$NC Generating new SSHd.$DST_PORT configuration"
    sudo bash -c "grep -Ev '^#|^$' $CONFIG_ORI > $CONFIG_ORI.$DST_PORT"

    # Customize new config w/ destination port
    echo -en "$GREEN[+]$NC Customizing SSHd.$DST_PORT configuration... "
    sudo sed -i "/^Include/a Port $DST_PORT" "$CONFIG_ORI.$DST_PORT"
    echo -e "done!\n"

    # Create new systemd service
    echo -e "$GREEN[+]$NC Creating new SSH-$DST_PORT service"
    sudo cp "$SERVICE_ORI.service" "$SERVICE_ORI-$DST_PORT.service"

    echo -en "$GREEN[+]$NC Customizing SSH-$DST_PORT service... "
    sudo sed -i "s/SSHD_OPTS/SSHD_OPTS -f \/etc\/ssh\/sshd_config.$DST_PORT/" "$SERVICE_ORI-$DST_PORT.service"
    sudo sed -i "s/Alias=sshd.service/Alias=sshd-$DST_PORT.service/" "$SERVICE_ORI-$DST_PORT.service"
    echo -e "done!\n"

    # Start new service
    echo -en "$GREEN[+]$NC Starting SSH-$DST_PORT service... "
    sudo systemctl enable --now "ssh-$DST_PORT.service" &>/dev/null
    echo -e "done!\n"
}

while getopts ":hp:V" opt; do
    case ${opt} in
        h ) # help
          usage
          exit 0
          ;;
        p ) # destination port
          DST_PORT="$OPTARG"
          main
          exit 0
          ;;
        V ) # Version
          echo -e "${0##*/} v. $VERSION\n"
          exit 0
          ;;
        \? )
          echo -e "${RED}[-]${NC} Invalid option: '$OPTARG'!\n"
          usage
          exit 255
          ;;
        : )
          echo -e "${RED}[-]${NC} Invalid option: '-$OPTARG' requires an argument!\n"
          usage
          exit 254
          ;;
    esac
done

shift $((OPTIND -1))

if [ "$OPTIND" -lt 2 ]; then
  usage
  exit 1
fi
