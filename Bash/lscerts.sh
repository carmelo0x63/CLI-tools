#!/usr/bin/env bash
# Lists X.509 certificates in a pre-defined directory
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2023-10-12: First release

# Setup
#set -Eeuo pipefail
#set -x

# Settings
CERTDIR="$HOME/Private CA/root-ca"
#CERTDIR="$HOME/Documents/Personal/Home Lab/myBackups/Private CA/root-ca"

# ANSI colors
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"         # No Color

usage() {
    echo "Usage: ${0##*/} [command]"
    echo -e "\t-h: Help"
    echo -e "\t-c: Compact output"
    echo -e "\t-v: Verbose output\n"
}

listcerts() {
    if [ -d "${CERTDIR}/certs" ]; then
        if [ "$VERBOSE" -gt 0 ]; then
            echo -e "${GREEN}[+]${NC} certificate directory found!"
        fi
        for CERT in "${CERTDIR}/certs/"*; do
            echo -e "${GREEN}[+]${NC} $CERT"
            openssl x509 -in "${CERT}" -text -noout | egrep "Issuer:|Subject:"
            if [ "$VERBOSE" -gt 0 ]; then
                openssl x509 -in "${CERT}" -text -noout | egrep -A1 "X509v3" | egrep -v "^\-\-"
                echo -e "\n"
            fi
        done
    else
        echo -e "${RED}[-]${NC} certificate directory NOT found!\n"
    fi
}

while getopts ":hcv" opt; do
  case ${opt} in
    h ) # help
      usage
      exit 0
      ;;
    c ) # compact
      VERBOSE=0
      listcerts
      exit 0
      ;;
    v ) # verbose
      VERBOSE=1
      listcerts
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

