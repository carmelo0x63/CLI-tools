#!/usr/bin/env bash
# Small utility checking the status of DNS servers
# checks include ICMP (ping) reachability and DNS responsiveness (dig)
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

while getopts ":hdlp" opt; do
  case ${opt} in
    h ) # help
      usage
      exit 0
      ;;
    d ) # dig
      for ipaddr in "${ALLHOSTS[@]}"; do
        dig @"$ipaddr" "$TESTRECORD" +short +time="$DNSTIMEOUT" &>/dev/null
        if [ "$?" -eq 0 ]; then
          echo -e "[+] $ipaddr: dig\t${GREEN}OK${NC}"
        else
          echo -e "[-] $ipaddr: dig\t${RED}NOK${NC}"
        fi
      done
      exit 0
      ;;
    l ) # list
      for ipaddr in "${ALLHOSTS[@]}"; do
        echo "[+] $ipaddr"
      done
      exit 0
      ;;
    p ) # ping
      for ipaddr in "${ALLHOSTS[@]}"; do
        ping -c1 -W1 $ipaddr &>/dev/null && echo -e "[+] $ipaddr:\t${GREEN}OK${NC}" || echo -e "[-] $ipaddr:\t${RED}NOK${NC}"
      done
      exit 0
      ;;
    \? )
      echo -e "${RED}[-]${NC} Invalid option"
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

