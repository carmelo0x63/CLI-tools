#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "argparse",
#     "re",
#     "sys",
# ]
# ///


# Search local hosts, e.g. '/etc/hosts', by name or IP address
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#   2025-07-01: 4.0 verbose info from SSH config
#   2025-02-24: 3.1 search with 'ALL' keyword, case insensitive, JSON config
#   2024-11-23: 3.0 ported to Python from Bash


# Import necessary modules
import argparse               # Command-line parsing library
import json                   # JSON encoder and decoder
import os                     # Miscellaneous operating system interfaces
import re                     # Support for regular expressions (RE)
import sys                    # System-specific parameters and functions
from pathlib import Path


# Global settings
__version__ = '4.0'
__build__ = '20250701'
LOCALHOSTS = '/etc/hosts'
SSHCONFIG = '.ssh/config'
HOME = str(Path.home())
CONFIG = os.path.abspath(os.path.dirname(__file__)) + '/lshosts.json'
HOSTS = []

def readConf():
    with open(CONFIG, 'r') as f:
        config = json.load(f)

    return config['SUBNETS']


def searchString(query_string) -> None:
    subnets = readConf()

    with open(LOCALHOSTS, 'r') as f:
        for line in f:
            if re.search(subnets, line):
                HOSTS.append(line)
    HOSTS.sort()

    if query_string != 'ALL':
        for host in HOSTS:
            if re.search(query_string, host, re.IGNORECASE) is not None:
                print(host, end = '')
    else:
        for host in HOSTS:
            if '#' not in host:
                print(host, end = '')

    if IS_VERBOSE:
        print('\n[+] SSH config:')

        # SSH config is dumped into a list
        with open(HOME + '/' + SSHCONFIG, 'r') as c:
            lines = c.readlines()

        r = re.compile(query_string)

        # we search for lines containing `query_string` in a specific position,
        # according to the pattern: `Host <hostname>`
        # when that occurs, we only print some pre-defined parts of the config
        for i in range(len(lines)):
            if r.search(lines[i]):
                if r.search(lines[i]).start() == 5:
                    print(lines[i], lines[i + 1], lines[i + 3])


def main() -> None:
    parser = argparse.ArgumentParser(description = 'Search local hosts by name or IP address, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('-q', '--query', metavar = '<string>', type = str, required = True, help = '<hostname>, <IP address>, or `ALL` (literal)')
    parser.add_argument('-v', '--verbose', action = 'store_true', help = 'shows additional info from SSH config')
    parser.add_argument('-V', '--version', action = 'version', version = '%(prog)s {version}'.format(version=__version__))

    # In case of no arguments shows help
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    else:
        args = parser.parse_args()  # parse command line

    # A global variable is instantiated in case of -v/--verbose argument
    global IS_VERBOSE
    IS_VERBOSE = args.verbose

    if args.query:
        searchString(args.query)


if __name__ == '__main__':
    main()
