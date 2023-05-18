#!/usr/bin/env bash
HOUR=0
MIN=0
SEC=10
while [ $HOUR -ge 0 ]; do
    while [ $MIN -ge 0 ]; do
        while [ $SEC -ge 0 ]; do
            echo -ne "$HOUR:$MIN:$SEC\033[0K\r"
            let "SEC=SEC-1"
            sleep 1
        done
    SEC=59
    let "MIN=MIN-1"
    done
MIN=59
let "HOUR=HOUR-1"
done

