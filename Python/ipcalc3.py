#!/usr/bin/env python3
# Extremely basic subnet calculator, Python3-based + ipaddress
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history:
#  1.1 Added: argument parsing
#  1.0 First version

import argparse
import ipaddress
import sys

# Version number
__version__ = "1.1"
__build__ = "20200420"

def ipdecode(subnet):
    try:
        ipif = ipaddress.ip_interface(subnet)
    except:
        print('[-] An exception occurred')
        sys.exit(2)

    print("Address:   " + str(ipif.ip))
    print("Mask:      " + str(ipif.netmask))
    print("CIDR:      " + str(ipif.network).split('/')[1])
    print("Network:   " + str(ipif.network).split('/')[0])
    print("Broadcast: " + str(ipif.network.broadcast_address), end='\n\n')

def main():
    parser = argparse.ArgumentParser(description='Calculates IP subnet from <ip_addr>/<mask>, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('subnet', metavar='<subnet>', type=str, help='Subnet either in CIDR (e.g. 192.168.1.0/24) or subnet mask (e.g. 192.168.1.0/255.255.255.0) format')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s ' + __version__)

    # In case of no arguments print help message then exit
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    else:
        args = parser.parse_args() # else parse command line

    ipdecode(args.subnet)

if __name__=="__main__":
    main()

