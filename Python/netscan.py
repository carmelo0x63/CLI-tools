#!/usr/bin/env python3
# Subnet scanner for open ports
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#   1.1: Small improvement to argument parsing
#   1.0: First version

import argparse
import ipaddress
import socket
import sys

# Version number
__version__ = "1.1"
__build__ = "20200928"

def main():
    parser = argparse.ArgumentParser(description='Network scanner looking for open ports, version ' + __version__ + ', build ' + __build__ + '.')
#    parser.add_argument('subnet', metavar='<subnet>', type=str, help='Subnet either in CIDR (e.g. 192.168.1.0/24) or subnet mask (e.g. 192.168.1.0/255.255.255.0) format')
    parser.add_argument('host', metavar='<host>', type=str, help='Host / literal IP address')
    parser.add_argument('-V', '--version', action='version', version='%(prog)s ' + __version__)

    # Set the default timeout in seconds (float) for new socket objects
    socket.setdefaulttimeout(1)

    # In case of no arguments shows help message
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(10)  # ERROR: no arguments
    else:
        args = parser.parse_args() # parse command line

    target = sys.argv[1]
    try:
        ipaddress.ip_address(target)
    except ValueError as e:
        print('Error: ' + str(e))
        sys.exit(20)  # ERROR: input is not an IP address

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

