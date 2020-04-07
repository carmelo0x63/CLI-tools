#!/usr/bin/env bash
# Checks OpenSSH config against a set of rules
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-04-06: First release

# Settings, the items in ISSUES array match some of the properties in SSHCONF
SSHCONF=/etc/ssh/sshd_config
ISSUES=(Port PermitRootLogin UseDNS PasswordAuthentication PermitEmptyPasswords)

# Colors, ANSI escape codes
# source: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
RED="\033[0;31m"
GREEN="\033[0;32m"
ORANGE="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
NC="\033[0m"         # No Color

# $1=warning type, $2=issue, $3=value
func() {
    case $1 in
       warn1)
           echo -e "${BLUE}[+]${NC} $2 is commented out"
           echo -e "${BLUE}[+]${NC} Actual value: "$3
       ;;
       warn2)
       echo "[+] $2 is set to value \""$3"\""
       if [ "$2" == "Port" ] && [ "$3" != "22" ]; then
           echo -e "${GREEN}[+]${NC} Non-standard port, awesome!"
       fi
       if [ "$2" != "Port" ] && [ "$2" != "UseDNS" ]; then
           if [ "$3" != "no" ]; then
               echo -e "${RED}[-]${NC} Unsafe option, please consider changing it!!!"
           else
               echo -e "${GREEN}[+]${NC} Recommended option!!!"
           fi
       fi
       ;;
    esac
}

echo -e "[+] Analyzing file: ${SSHCONF}\n"

ACCRIGHTS=$(stat -c "%a" "$SSHCONF")
if [ "$ACCRIGHTS" == "600" ]; then
    echo -e "${RED}[-]${NC} File cannot be read!"
    echo -e "${RED}[-]${NC} Try running again with sudo.\n"
    exit 1
fi

for issue in "${ISSUES[@]}"; do
    echo "[+] Checking: ${issue}"

    # We start by looking for the commented-out occurrence of "issue"
    # if one is found the string is passed entirely to func()
    out1=$(egrep "^#${issue}" $SSHCONF)
    if [ "$out1" != "" ]; then
#        echo ${out1}
        func warn1 ${issue} "$out1"
    fi

    # The commented-out / enabled options are not mutulally exclusive thus
    # we also search for plain "issue" then we pass func() its value too
    out2=$(egrep "^${issue}" $SSHCONF)
    if [ "$out2" != "" ]; then
#        echo ${out2}
        func warn2 ${issue} ${out2#${issue}}
    fi

    echo
done

echo -e "${GREEN}[+]${NC} Your SSH config is baked and ready for serving!\n"

