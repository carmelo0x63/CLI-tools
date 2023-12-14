#!/usr/bin/env bash
# Script to start/stop a VNC connection with pre-defined settings
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2023-12-14: Stable release

# Settings
PREFIX="59"
VNCPORT="10"
VNCEXE="Xtightvnc"

echo "Currently open connections:"
echo -n "[+] "
ps -efwww | grep $VNCEXE | awk '{ for(i=1; i<=NF; i++) { tmp = match($i, /59[0-9][0-9]/); if (tmp) { print "process = " $8 "  port = " $i "  PID = " $2 } } }'
echo
echo "Available resolutions, please choose:"
echo "1) 1400x1004 on port "$PREFIX$VNCPORT
echo "2) 1600x1004 on port "$PREFIX$VNCPORT
echo "9) Kill VNC :"$VNCPORT
echo "*) Quit"
read vncres

case "$vncres" in
    1)
    echo Starting VNC server with the following settings:
    echo "[+] port "$PREFIX$VNCPORT
    echo "[+] geometry 1400x1004"
    vncserver :$VNCPORT -geometry 1400x1004
    echo "[+] port forwarding is active on" "$(ps -efwww | grep $VNCEXE | awk '{ for(i=1; i<=NF; i++) { tmp = match($i, /590[0-9]/); if (tmp) { print "port = " $i ", PID = " $2 } } }')"
    ;;
    2)
    echo Starting VNC server with the following settings:
    echo "[+] port "$PREFIX$VNCPORT
    echo "[+] geometry 1600x1004"
    vncserver :$VNCPORT -geometry 1600x1004
    echo "[+] port forwarding is active on" "$(ps -efwww | grep $VNCEXE | awk '{ for(i=1; i<=NF; i++) { tmp = match($i, /590[0-9]/); if (tmp) { print "port = " $i ", PID = " $2 } } }')"
    ;;
    9)
    vncserver -kill :$VNCPORT
    ;;
    *)
    echo "Exiting..."
    exit 1
    ;;
esac

