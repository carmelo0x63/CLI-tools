#!/usr/bin/env python3
# HomeHostS2: pings a list of hosts to check their up/down status
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2023-05-15: 1.3 Added output colors
#  2022-02-10: 1.2 Fixed an issue by which the external file wasn't loaded
#  2022-01-21: 1.1 moved HOSTS to external file (CFGFILE)
#  2022-01-11: 1.0 initial version

import argparse      # Parser for command-line options, arguments and sub-commands
import json          # JSON encoder and decoder
import os            # Miscellaneous operating system interfaces
import socket        # Low-level networking interface
import subprocess    # Subprocess management
import sys           # System-specific parameters and functions

# Global variables
__version__ = "1.3"
__build__ = "20230515"
CFGFILE = os.path.abspath(os.path.dirname(__file__)) + '/hhs2.cfg'

# https://svn.blender.org/svnroot/bf-blender/trunk/blender/build_files/scons/tools/
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def pingscan(host, ipaddr):
    process = subprocess.Popen(['ping', '-c1', '-W1', ipaddr], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

    if stderr == b'':
        if b'1 packets received' in stdout:
            print(bcolors.OKGREEN + '[+]' + bcolors.ENDC + ' Host ' + host + ' (' + ipaddr + ') is UP')
        else:
            print(bcolors.WARNING + '[-]' + bcolors.ENDC + ' Host ' + host + ' is unreachable')
    else:
        print('[!] ERROR: ' + stdout.decode())


def scan22(host, ipaddr):
    process = subprocess.Popen(['nc', '-w1', '-G1', ipaddr, '22'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

    if stderr == b'':
        print(bcolors.OKGREEN + '[+]' + bcolors.ENDC + ' Host ' + host + ' (' + ipaddr + ') ' + ': ' + str(stdout))
    else:
        print(bcolors.WARNING + '[!]' + bcolors.ENDC + ' ERROR: ' + stdout.decode())


def iterate(mode):
    for host in HOSTS:
        try:
            ipaddr = socket.gethostbyname(host)
        except:
            print(bcolors.FAIL + '[!]' + bcolors.ENDC + ' Host ' + host + ' is NOT available')
            continue

        if (mode == 1):
            pingscan(host, ipaddr)

        if (mode == 2):
            scan22(host, ipaddr)


def main():
    parser = argparse.ArgumentParser(description='HomeHostS2: pings a list of hosts to check their up/down status, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('-p', '--ping', action='store_true', help='Ping (ICMP) hosts')
    parser.add_argument('-s', '--ssh', action='store_true', help='Attempts OS detection through TCP/22')
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

    if args.ping:
        print(bcolors.OKGREEN + '>>>' + bcolors.ENDC + ' Starting ICMP (ping) scan...')
        iterate(1)

    if args.ssh:
        print(bcolors.OKGREEN + '>>>' + bcolors.ENDC + ' Starting TCP port 22 scan...')
        iterate(2)


if __name__ == '__main__':
    main()

