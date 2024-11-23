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
#   2024-11-23: 3.0 ported to Python from Bash


# Import necessary modules
import argparse               # Command-line parsing library
import re                     # Support for regular expressions (RE)
import sys                    # System-specific parameters and functions


# Global settings
__version__ = '3.0'
__build__ = '20241123'
LOCALHOSTS='/etc/hosts'


def searchString(query_string) -> None:
    with open(LOCALHOSTS, 'r') as f:
        for line in f:
            if re.search(query_string, line):
                print(line, end='')


def main() -> None:
    parser = argparse.ArgumentParser(description = 'Search local hosts by name or IP address, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('-q', '--query', metavar = '<string>', type = str, help = 'Query string, e.g. `hostname` or `192.168.0.1`')
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
