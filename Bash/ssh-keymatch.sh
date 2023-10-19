#!/usr/bin/env bash
# Checks whether a public/private keypair matches
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-11-24: First release

# Setup
#set -Eeuo pipefail
#set -x

# ANSI colors
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"         # No Color

usage() {
    echo "Usage: ${0##*/} [command] <key1> <key2>"
    echo "Command list:"
    echo -e "\t-h: Help"
    echo -e "\t-c: Compare keypair\n"
}

compare() {
  # The 2nd and 3rd CLI arguments become 1st and 2nd within the context of compare() function
  /usr/bin/diff <(ssh-keygen -yef "$1") <(ssh-keygen -yef "$2") &>/dev/null && echo -e "${GREEN}OK${NC}\n" || echo -e "${RED}NOK${NC}\n"
}

while getopts ":hc:" opt; do
  case ${opt} in
    h ) # help
      usage
      exit 0
      ;;
    c ) # compare
      if [ "$#" -gt 3 ]; then
        echo -e "${RED}[-]${NC} Too many arguments\n"
        exit 10
      fi
      compare $2 $3
      exit 0
      ;;
    \? )
      echo -e "${RED}[-]${NC} Invalid option\n"
      usage
      exit 255
      ;;
  esac
done

shift $((OPTIND -1))

if [ "$OPTIND" -lt 2 ]; then
  usage
  exit 1
fi

