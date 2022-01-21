#!/usr/bin/env python3
# HomeHostS2: pings a list of hosts to check their up/down status
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2022-01-21: 1.1 moved HOSTS to external file (CFGFILE)
#  2022-01-11: 1.0 initial version

import argparse      # Parser for command-line options, arguments and sub-commands
import json          # JSON encoder and decoder
import socket        # Low-level networking interface
import subprocess    # Subprocess management
import sys           # System-specific parameters and functions

# Global variables
__version__ = "1.1"
__build__ = "20220121"
CFGFILE = 'hhs2.cfg'

def ping(host, ipaddr):
    process = subprocess.Popen(['ping', '-c1', '-W1', ipaddr], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

    if stderr == b'':
        if b'1 packets received' in stdout:
            print('[+] Host ' + host + ' (' + ipaddr + ') is UP')
        else:
            print('[-] Host ' + host + ' is unreachable')
    else:
        print('[!] ERROR: ' + stdout.decode())


def osinfo(host, ipaddr):
    process = subprocess.Popen(['ssh', '-l pi', ipaddr, '"uname -a"'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

    if stderr == b'':
        print('[+] Host ' + host + ': ' + str(stdout))
    else:
        print('[!] ERROR: ' + stdout.decode())


def iterate(mode):
    for host in HOSTS:
        try:
            ipaddr = socket.gethostbyname(host)
        except:
            print('[!] Host ' + host + ' is NOT available')
            continue

        if (mode == 1):
            ping(host, ipaddr)

        if (mode == 2):
            osinfo(host, ipaddr)


def main():
    parser = argparse.ArgumentParser(description='HomeHostS2: pings a list of hosts to check their up/down status, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('-o', '--osinfo', action='store_true', help='Attempts OS detection')
    parser.add_argument('-p', '--ping', action='store_true', help='Ping (ICMP) hosts')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s ' + __version__)

    # In case of no arguments print help message then exits
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    else:
        args = parser.parse_args() # else parse command line

    with open(CFGFILE, 'r') as f:
        cfg = f.read()
        global HOSTS
        HOSTS = json.loads(cfg)

    if args.ping: iterate(1)
    if args.osinfo: iterate(2)


if __name__ == '__main__':
    main()

