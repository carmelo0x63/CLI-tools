#!/usr/bin/env bash
# Small utility checking the status of DNS servers
# Checks include ICMP (ping) reachability and DNS responsiveness (dig)
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-04-07: First issue

ALLHOSTS=(1.1.1.1 8.8.4.4 8.8.8.8 208.67.220.220 208.67.222.222)
TESTRECORD="www.corriere.it"
DNSTIMEOUT="1"

# ANSI colors
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"         # No Color

usage() {
    echo "Usage: ${0##*/} [-h] [-l] [-d] [-p]"
    echo -e "\th: Help"
    echo -e "\tl: List available hosts"
    echo -e "\td: Send sample query to DNS servers"
    echo -e "\tp: Ping (ICMP) the DNS servers\n"
}

testOK() {
    echo -e "[+] $ipaddr:  \t"$1" ${GREEN}OK${NC}"
}

testNOK() {
    echo -e "[+] $ipaddr:  \t"$1" ${RED}OK${NC}"
}

while getopts ":hdlp" opt; do
  case ${opt} in
    h ) # help
      usage
      exit 0
      ;;
    d ) # dig
      echo "[+] DIG test started"
      for ipaddr in "${ALLHOSTS[@]}"; do
        dig @"$ipaddr" "$TESTRECORD" +short +time="$DNSTIMEOUT" &>/dev/null
        if [ "$?" -eq 0 ]; then
          testOK DIG
        else
          testNOK DIG
        fi
      done
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
          testOK ICMP
        else
          testNOK ICMP
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

