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
#   2025-02-24: 3.1 search with 'ALL' keyword, case insensitive, JSON config
#   2024-11-23: 3.0 ported to Python from Bash


# Import necessary modules
import argparse               # Command-line parsing library
import json                   # JSON encoder and decoder
import os                     # Miscellaneous operating system interfaces
import re                     # Support for regular expressions (RE)
import sys                    # System-specific parameters and functions


# Global settings
__version__ = '3.1'
__build__ = '20250224'
LOCALHOSTS = '/etc/hosts'
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


def main() -> None:
    parser = argparse.ArgumentParser(description = 'Search local hosts by name or IP address, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('-q', '--query', metavar = '<string>', type = str, help = '<hostname>, <IP address>, or `ALL` (literal)')
    parser.add_argument('-V', '--version', action = 'version', version = '%(prog)s {version}'.format(version=__version__))

    args = parser.parse_args()  # parse command line

    # In case of no arguments shows help
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    elif len(sys.argv) == 3:
        searchString(sys.argv[2])


if __name__ == '__main__':
    main()
