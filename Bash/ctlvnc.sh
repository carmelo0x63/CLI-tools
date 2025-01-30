#!/usr/bin/env bash
# Script to start/stop a VNC connection with pre-defined settings
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2025-01-30: Fixed awk code
#  2024-11-06: Added '-nolisten tcp'
#  2023-12-14: Stable release

# Settings
PREFIX="590"
VNCPORT="9"
VNCEXE="vnc"

echo "Currently open connections:"
echo -n "[+] "
ps -AFww | grep -E $VNCEXE | grep -E -v "grep|xstartup|bash" | awk '{ for(i=1; i<=NF; i++) { if($i ~ /59[0-9][0-9]/) { print "process = " $11 "  PID = " $2 "  port = " $i } } }'
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
    vncserver :$VNCPORT -geometry 1400x1004 -nolisten tcp
    echo "[+] port forwarding is active on" "$(ps -AFww | grep -E $VNCEXE | grep -E -v "grep|xstartup|bash" | awk '{ for(i=1; i<=NF; i++) { if($i ~ /59[0-9][0-9]/) { print "process = " $11 "  PID = " $2 "  port = " $i } } }')"
    ;;
    2)
    echo Starting VNC server with the following settings:
    echo "[+] port "$PREFIX$VNCPORT
    echo "[+] geometry 1600x1004"
    vncserver :$VNCPORT -geometry 1600x1004 -nolisten tcp
    echo "[+] port forwarding is active on" "$(ps -AFww | grep -E $VNCEXE | grep -E -v "grep|xstartup|bash" | awk '{ for(i=1; i<=NF; i++) { if($i ~ /59[0-9][0-9]/) { print "process = " $11 "  PID = " $2 "  port = " $i } } }')"
    ;;
    9)
    vncserver -kill :$VNCPORT
    ;;
    *)
    echo "Exiting..."
    exit 1
    ;;
esac

