#!/usr/bin/env bash
# Small utility checking the status of DNS servers
# Checks include ICMP (ping) reachability and DNS responsiveness (dig)
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-04-17: Added check for the existence of dig, unified test functions
#  2020-04-07: First issue

ALLHOSTS=(10.0.2.1 10.0.2.2 1.1.1.1 8.8.4.4 8.8.8.8 208.67.220.220 208.67.222.222)
TESTRECORD="www.corriere.it"
DNSTIMEOUT="1"
DIGCMD="/usr/bin/dig"

# ANSI colors
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"         # No Color

usage() {
    echo "Usage: ${0##*/} [-h] [-l] [-p] [-d]"
    echo -e "\th: Help"
    echo -e "\tl: List available hosts"
    echo -e "\tp: Ping (ICMP) the DNS servers"
    echo -e "\td: Test port 53 by sending one sample query to hosts\n"
}

# testOut: $1=0|1, $2=test_name
testOut() {
    if [ "$1" = "0" ]; then
      echo -e "${GREEN}[+]${NC} $ipaddr:  \t"$2" ${GREEN}OK${NC}"
    else
      echo -e "${RED}[-]${NC} $ipaddr:  \t"$2" ${RED}NOK${NC}"
    fi
}

while getopts ":hdlp" opt; do
  case ${opt} in
    h ) # help
      usage
      exit 0
      ;;
    d ) # dig
      echo "[+] DIG test started"
      if [ -e "${DIGCMD}" ]; then
        for ipaddr in "${ALLHOSTS[@]}"; do
          "${DIGCMD}" @"$ipaddr" "$TESTRECORD" +short +time="$DNSTIMEOUT" &>/dev/null
          if [ "$?" -eq 0 ]; then
            testOut 0 DIG
          else
            testOut 1 DIG
          fi
        done
      else
        echo -e "${RED}[-]${NC} ${DIGCMD} not available, skipping.\n"
      fi
      exit 0
      ;;
    l ) # list
      for ipaddr in "${ALLHOSTS[@]}"; do
        echo "[+] $ipaddr"
      done
      echo
      exit 0
      ;;
    p ) # ping
      echo "[+] ICMP test started"
      for ipaddr in "${ALLHOSTS[@]}"; do
        ping -c1 -W1 $ipaddr &>/dev/null
        if [ "$?" -eq 0 ]; then
          testOut 0 ICMP
        else
          testOut 1 ICMP
        fi
      done
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

