#!/usr/bin/env python3
# Pings a list of hosts to check their up/down status
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2021-06-29: 1.0 initial version

import socket        # Low-level networking interface
import subprocess    # Subprocess management

HOSTS = ['raspi1-eth', 'gigetto', 'raspi3-eth', 'raspi3p-eth', 'zero1', 'zero2', 'zero3', 'zero4', 'raspi4-eth', 'jetson2gb', 'zerow1', 'pico1', 'pico2', 'pico3', 'pico4', 'pico5', 'uk3s1', 'uk3s2', 'uk3s3']

for host in HOSTS:
    try:
        ipaddr = socket.gethostbyname(host)
    except:
        print('[!] Host ' + host + ' is NOT available')
        continue

    process = subprocess.Popen(['ping', '-c1', '-W1', ipaddr], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

    if stderr == b'':
        if b'1 packets received' in stdout:
            print('[+] Host ' + host + ' (' + ipaddr + ') is UP')
        else:
            print('[-] Host ' + host + ' is unreachable')
    else:
        print('[!] ERROR: ' + stdout.decode())

