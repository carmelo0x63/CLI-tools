#!/usr/bin/env bash
# Checks whether a public/private keypair matches
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2025-06-11: Added `verbose` option
#  2020-11-24: First release

# Setup
#set -Eeuo pipefail
#set -x

# Settings
VERSION="1.1"
IS_VERBOSE=0

# ANSI colors
RED="\033[0;31m"     # red = Error
GREEN="\033[0;32m"   # green = OK
ORANGE="\033[0;33m"  # orange = Warning
NC="\033[0m"         # No Color


usage() {
    echo "Usage: ${0##*/} [command] <key1> <key2>"
    echo "Command list:"
    echo -e "\t-h: Help"
    echo -e "\t-V: Version"
    echo -e "\t-j: First key"
    echo -e "\t-k: Second key"
    echo -e "\t-v: Verbose output\n"
}


compare() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "${RED}[-]${NC} missing argument"
        exit 255
    fi

    /usr/bin/diff <(ssh-keygen -yef "$1") <(ssh-keygen -yef "$2") &>/dev/null
    STATUS="$?"

    if [ "$STATUS" -eq 0 ]; then
        echo -e "${GREEN}[+] OK${NC}"
        if [ "$IS_VERBOSE" -gt 0 ]; then
            echo -e "${RED}[-]${NC} key 1 and key 2 match:"
            echo -e "  fingerprint: $(ssh-keygen -lf $1)"
        fi
    else
        echo -e "${RED}[-] NOK${NC}"
        if [ "$IS_VERBOSE" -gt 0 ]; then
            echo -e "${RED}[-]${NC} key 1 and key 2 do not match:"
            echo -e "  fingerprint 1: $(ssh-keygen -lf $1)"
            echo -e "  fingerprint 2: $(ssh-keygen -lf $2)"
        fi
    fi

    echo
}


while getopts ":hj:k:vV" opt; do
    case ${opt} in
        h ) # help
          usage
          exit 0
          ;;
        j ) # first key
          KEY1="$OPTARG"
          ;;
        k ) # second key
          KEY2="$OPTARG"
          ;;
        v ) # Verbose
          IS_VERBOSE=1
          ;;
        V ) # Version
          echo -e "${0##*/} v. $VERSION\n"
          exit 0
          ;;
        \? )
          echo -e "${RED}[-]${NC} Invalid option\n"
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

compare "$KEY1" "$KEY2"
