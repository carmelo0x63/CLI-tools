#!/usr/bin/env bash

# Setup
#set -Eeuo pipefail
#set -x

# Settings
VERSION="0.9"
EMPTY="empty"

# ANSI colors
RED="\033[0;31m"     # red = Error
GREEN="\033[0;32m"   # green = OK
ORANGE="\033[0;33m"  # orange = Warning
NC="\033[0m"         # No Color


usage() {
    echo "Usage: ${0##*/} [command] ..."
    echo "Command list:"
    echo -e "\t-h: Help"
    echo -e "\t-V: Version"
    echo -e "\t-a: Option A (1)"
    echo -e "\t-b: Option B"
    echo -e "\t-c: Option C (1)\n"
}


main() {
    if [ -n "$OPT_A" ] && [ -n "$OPT_C" ]; then
        echo -e "$RED[!]${NC} Option A and Option C are mutually exclusive!\n"
        exit 255
    fi
    echo -e "${ORANGE}[!]${NC} main program:"
    echo -e "${GREEN}[+]${NC}   Option A: ${OPT_A:-$EMPTY}"
    echo -e "${GREEN}[+]${NC}   Option B: ${OPT_B:-$EMPTY}"
    echo -e "${GREEN}[+]${NC}   Option C: ${OPT_C:-$EMPTY}"

    echo -e "${GREEN}[+]${NC}   OPTARG: ${OPTARG:-$EMPTY}"
    echo -e "${GREEN}[+]${NC}   OPTIND: $OPTIND\n"
}


while getopts ":ha:b:c:V" opt; do
    case ${opt} in
        h ) # help
          usage
          exit 0
          ;;
        a ) # Option A
          CMD_ARGS=("$@")
          echo -e "${ORANGE}[!]${NC} Args length: ${#CMD_ARGS[@]}"
          OPT_A="$OPTARG"
          echo -e "${ORANGE}[!]${NC} Option A block:"
          echo -e "${ORANGE}[!]${NC}   OPTARG: $OPTARG"
          echo -e "${ORANGE}[!]${NC}   OPTIND: $OPTIND\n"
#          main
#          exit 0
          ;;
        b ) # Option B
          CMD_ARGS=("$@")
          echo -e "${ORANGE}[!]${NC} Args length: ${#CMD_ARGS[@]}"
          OPT_B="$OPTARG"
          echo -e "${ORANGE}[!]${NC} Option B block:"
          echo -e "${ORANGE}[!]${NC}   OPTARG: $OPTARG"
          echo -e "${ORANGE}[!]${NC}   OPTIND: $OPTIND\n"
#          main
#          exit 0
          ;;
        c ) # Option C
          CMD_ARGS=("$@")
          echo -e "${ORANGE}[!]${NC} Args length: ${#CMD_ARGS[@]}"
          OPT_C="$OPTARG"
          echo -e "${ORANGE}[!]${NC} Option C block:"
          echo -e "${ORANGE}[!]${NC}   OPTARG: $OPTARG"
          echo -e "${ORANGE}[!]${NC}   OPTIND: $OPTIND\n"
#          main
#          exit 0
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

# Finally...
main
