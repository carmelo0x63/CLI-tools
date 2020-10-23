#!/usr/bin/env bash

echo "Temperature monitoring on Raspberry Pi"

while true
    do sleep 5 && sudo /opt/vc/bin/vcgencmd measure_temp
done

