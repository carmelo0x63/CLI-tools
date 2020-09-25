#!/usr/bin/env bash
# Small utility checking the status of remote hosts
# Checks include ICMP (ping) reachability, DNS responsiveness (dig),
# availability of SSH
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-04-17: Added check for the existence of dig, unified test functions,
#              moved the list of IPs to a positional argument
#  2020-04-07: First issue

set -f   # disable glob
IFS=","  # split on commas
TESTRECORD="www.example.org"
TIMEOUT="1"
DIGCMD="/usr/bin/dig"
PINGCMD="/bin/ping"
NCCMD="/bin/nc"
SSHPORT="22"

# ANSI colors
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"         # No Color

usage() {
    echo "Usage: ${0##*/} [option] [comma-separated IPs]"
    echo -e "\t-h: Help"
    echo -e "\t-p [comma-separated IPs]: Ping (ICMP) the targets hosts"
    echo -e "\t-d [comma-separated IPs]: Test port 53 by sending one sample query"
    echo -e "\t-s [comma-separated IPs]: Test port 22 by means of nc/netcat\n"
}

# testOut: $1=0=OK|1=NOK, $2=test_name
testOut() {
    if [ "$1" = "0" ]; then
      echo -e "${GREEN}[+]${NC} $ipaddr:  \t"$2" ${GREEN}OK${NC}" | column -t
    else
      echo -e "${RED}[-]${NC} $ipaddr:  \t"$2" ${RED}NOK${NC}" | column -t
    fi
}

while getopts ":hd:p:s:" opt; do
  case ${opt} in
    h ) # help
      usage
      exit 0
      ;;
    d ) # dig
      echo "[+] DIG test started"
      ALLHOSTS=($OPTARG)
      if [ -e "${DIGCMD}" ]; then
        for ipaddr in "${ALLHOSTS[@]}"; do
          "${DIGCMD}" @"$ipaddr" "$TESTRECORD" +short +time="$TIMEOUT" &>/dev/null
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
    p ) # ping
      echo "[+] ICMP test started"
      ALLHOSTS=($OPTARG)
      for ipaddr in "${ALLHOSTS[@]}"; do
        "${PINGCMD}" -c1 -W1 $ipaddr &>/dev/null
        if [ "$?" -eq 0 ]; then
          testOut 0 ICMP
        else
          testOut 1 ICMP
        fi
      done
      exit 0
      ;;
    s ) # nc/netcat/ssh
      echo "[+] SSH test started, port: "${SSHPORT}
      ALLHOSTS=($OPTARG)
      if [ -e "${NCCMD}" ]; then
        for ipaddr in "${ALLHOSTS[@]}"; do
          output=$("$NCCMD" -w"$TIMEOUT" "$ipaddr" "$SSHPORT" 2>/dev/null)
          if [ "${output:0:3}" = "SSH" ]; then
            testOut 0 SSH
          else
            testOut 1 SSH
          fi
        done
      else
        echo -e "${RED}[-]${NC} ${NCCMD} not available, skipping.\n"
      fi
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

