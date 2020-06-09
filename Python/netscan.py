#!/usr/bin/env python3
# Subnet scanner for open ports
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history:
#  1.0 First version

import argparse
import socket
import sys

# Version number
__version__ = "1.0"
__build__ = "20200520"

def main():
    parser = argparse.ArgumentParser(description='Network scanner looking for open ports, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('subnet', metavar='<subnet>', type=str, help='Subnet either in CIDR (e.g. 192.168.1.0/24) or subnet mask (e.g. 192.168.1.0/255.255.255.0) format')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s ' + __version__)

    # Set the default timeout in seconds (float) for new socket objects
    socket.setdefaulttimeout(1)

    # Check the argument list, in case of no args we quit
    if len(sys.argv) == 1:
        sys.exit(1)

    target = sys.argv[1]
    for port in [22, 80, 123, 443, 8080]:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        conn = s.connect_ex((target, port))

        if conn == 0:
             STATE = 'OPEN'
        else:
             STATE = 'CLOSED'

        print('[+] Scanning port ' + str(port) + ': ' + STATE)

        s.close()

if __name__ == '__main__':
    main()

