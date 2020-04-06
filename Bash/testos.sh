#!/usr/bin/env bash
# source: https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script
# also: https://unix.stackexchange.com/questions/432816/grab-id-of-os-from-etc-os-release

if [ -f /etc/os-release ]; then
    source /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    ARCH=$(uname -m)
else
    OS=$(uname -s)
    VER=$(uname -r)
    ARCH=$(uname -m)
fi

echo "You're running $OS, version $VER on $ARCH."

