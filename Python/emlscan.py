#!/usr/bin/env python3
# Scans .eml files for headers and info, summarizes important info
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#   2025-03-18: 1.2 added `-c/--clean` and `-H/--headers` arguments
#   2023-09-20: 1.1 output column-formatted and cleaned-up
#   2023-03-08: 1.0 initial version

# Import some modules
import argparse     # Parser for command-line options, arguments and sub-commands
import email        # An email and MIME handling package
import re           # Support for regular expressions (RE)
import sys          # System-specific parameters and functions

# Version number
__version__ = '1.2'
__build__ = '20250318'

# Global variables
BASICHEADERS = ['Delivered-To', 'Return-Path', 'From', 'Reply-To', 'To', 'Subject', 'Date']


def ShowHeaders(msg):
    for header in msg.keys():
        print(header)


def parseBasicHeaders(msg):
    for header in BASICHEADERS:
#        print(f'[+] {header:12}:  ', end= '')
        print(f'{header:12}:  ', end= '')
        print(msg[header])


def FilterHeaders(msg, mode):
    maxCol = 1
    for key in msg.keys():
        maxLen = len(key)
        if maxLen > maxCol:
            maxCol = maxLen
    maxCol += 2

    for header in msg.keys():
        if mode == 0:
            print('{:<{maxCol}}'.format(header + ':', maxCol=maxCol), end= '')
            print(msg[header].replace('\n', ''))
        elif mode == 1:
            if re.search('^x', header, re.IGNORECASE) is None:
                print('{:<{maxCol}}'.format(header + ':', maxCol=maxCol), end= '')
                print(msg[header].replace('\n', ''))

def main():
    parser = argparse.ArgumentParser(description='Scans .eml files for headers and info, summarizes important info, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('fileName', metavar = '<File name>', type = str, help = 'Path to filename to be parsed')
    parser.add_argument('-V', '--version', action = 'version', version = '%(prog)s ' + __version__)
    group = parser.add_mutually_exclusive_group()
    group.add_argument('-a', '--all', action = 'store_true', help = 'Shows all headers')
    group.add_argument('-b', '--basic', action = 'store_true', help = 'Shows basic info')
    group.add_argument('-c', '--clean', action = 'store_true', help = 'Shows essential info')
    group.add_argument('-H', '--headers', action = 'store_true', help = 'Shows headers only')

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
        print(f'[-] Filename \"{fileName}\" not found!!!', end = '\n\n')
        sys.exit(2)

    msg = email.message_from_file(emlFile)
    emlFile.close()

    if args.all:
        FilterHeaders(msg, 0)
    elif args.basic:
        parseBasicHeaders(msg)
    elif args.clean:
        FilterHeaders(msg, 1)
    else:
        ShowHeaders(msg)
    
if __name__ == '__main__':
    main()

