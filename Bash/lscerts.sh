#!/usr/bin/env bash
# Lists X.509 PEM certificates in a given directory
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2023-10-19: Hardcoded target directory replaced with input argument
#  2023-10-12: First release

# Setup
#set -Eeuo pipefail
#set -x

# Settings
VERSION="1.1"

# ANSI colors
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"         # No Color

usage() {
    echo "Usage: ${0##*/} [command] <target directory>"
    echo "Command list:"
    echo -e "\t-h: Help"
    echo -e "\t-V: Version"
    echo -e "\t-c: Compact output"
    echo -e "\t-v: Verbose output\n"
}

listcerts() {
    if [ -d "${CERTDIR}" ]; then
        if [ "$VERBOSE" -gt 0 ]; then
            echo -e "${GREEN}[+]${NC} Target directory: ${CERTDIR}"
            echo -e "${GREEN}[+]${NC} Certificate directory found..."
        fi
        for CERT in "${CERTDIR}/"*pem; do
            echo -e "${GREEN}[+]${NC} $CERT"
            openssl x509 -in "${CERT}" -text -noout | egrep "Issuer:|Subject:"
            if [ "$VERBOSE" -gt 0 ]; then
                openssl x509 -in "${CERT}" -text -noout | egrep -A1 "X509v3" | egrep -v "^\-\-"
                echo -e "\n"
            fi
        done
    else
        echo -e "${RED}[-]${NC} Target directory: ${CERTDIR}"
        echo -e "${RED}[-]${NC} Certificate directory NOT found!\n"
        exit 200
    fi
}

while getopts ":hc:v:V" opt; do
  case ${opt} in
    h ) # help
      usage
      exit 0
      ;;
    c ) # compact
      VERBOSE=0
      CERTDIR=$OPTARG
      listcerts
      exit 0
      ;;
    v ) # verbose
      VERBOSE=1
      CERTDIR=$OPTARG
      listcerts
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

