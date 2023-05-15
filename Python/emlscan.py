#!/usr/bin/env python3
# Scans .eml files for headers and info, summarizes important info
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history:
#  2023-03-08: 1.0 initial version

# Import some modules
import argparse     # Parser for command-line options, arguments and sub-commands
import email        # An email and MIME handling package
import sys          # System-specific parameters and functions

# Version number
__version__ = "1.0"
__build__ = "20230308"

# Global variables
BASICHEADERS = ['Delivered-To', 'Return-Path', 'From', 'Reply-To', 'To', 'Subject', 'Date']

def parseBasicHeaders(msg):
    for header in BASICHEADERS:
        print(f'[+] {header}:\t', end= '')
        print(msg[header])

def parseAllHeaders(msg):
    for header in msg.keys():
        print(f'[+] {header}:\t', end= '')
        print(msg[header])

def main():
    parser = argparse.ArgumentParser(description='Scans .eml files for headers and info, summarizes important info, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('fileName', metavar = '<File name>', type = str, help = 'Path to filename to be parsed')
    parser.add_argument('-v', '--version', action = 'version', version = '%(prog)s ' + __version__)
    group = parser.add_mutually_exclusive_group()
    group.add_argument('-a', '--all', action = 'store_true', help = 'Shows all headers')
    group.add_argument('-b', '--basic', action = 'store_true', help = 'Shows essential info')

    # In case of no arguments print help message then exits
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    else:
        args = parser.parse_args() # else parse command line

    fileName = args.fileName

    try:
        emlFile = open(fileName, 'r')
    except IOError:
        print("[-] Filename \"" + fileName + "\" not found!!!", end = '\n\n')
        sys.exit(2)

    msg = email.message_from_file(emlFile)
    emlFile.close()

    if args.all:
        parseAllHeaders(msg)
    else:
        parseBasicHeaders(msg)
    
if __name__ == '__main__':
    main()

