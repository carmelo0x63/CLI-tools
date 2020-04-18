#!/usr/bin/env python3
# Extremely basic subnet calculator, Python3-based + ipaddress
# author: Carmelo C
# email: carmelo.califano@gmail.com
# date (ISO 8601): 2020-04-17
# history:
#  1.1 Added: argument parsing
#  1.0 First version

import argparse
import ipaddress
import sys

# Version number
__version__ = "1.1"
__build__ = "20200418"

def ipdecode():
    ipif = ipaddress.ip_interface(sys.argv[1])
    print("Address:   " + str(ipif.ip))
    print("Mask:      " + str(ipif.netmask))
    print("CIDR:      " + str(ipif.network).split('/')[1])
    print("Network:   " + str(ipif.network).split('/')[0])
    print("Broadcast: " + str(ipif.network.broadcast_address), end='\n\n')

def main():
    parser = argparse.ArgumentParser(description='Calculates IP subnet from <ip_addr>/<mask>, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('pwLen', metavar='<password length>', type=int, help='Integer number, must be 3(!) or more')
    parser.add_argument('-a', '--alpha', action='store_true', help='alphanumeric only')
    parser.add_argument('-r', '--remove', help='list of characters to be skipped')
    parser.add_argument('-s', '--safe', action='store_true', help='alphanumeric + "safe" special characters')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s ' + __version__)

if __name__=="__main__":
    main()
