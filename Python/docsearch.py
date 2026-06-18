#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "argparse",
#     "re",
#     "sys",
# ]
# ///


# Search documents locally, by name or by contents
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#   2026-03-27: replaced `depth` option with optional `deep` flag
#   2026-03-06: shallowsearch -> case insensitive, deepsearch -> color = ALWAYS
#   2026-03-04: v. 1.1, added `deepsearch`, verbose mode
#   2025-12-05: initial version, 1.0


# Import necessary modules
import argparse               # Command-line parsing library
import glob                   # Unix style pathname pattern expansion
#import json                   # JSON encoder and decoder
import os                     # Miscellaneous operating system interfaces
#import re                     # Support for regular expressions (RE)
import subprocess             # Spawn new processes, connect to their input/output/error pipes, and obtain their return codes
import sys                    # System-specific parameters and functions
from pathlib import Path


# Global settings
__version__ = '1.2'
__build__ = '20260327'
LOCATIONS = ["Documents", "Dropbox", ".cache/SSHFS"]
HOME = str(Path.home())
#CONFIG = os.path.abspath(os.path.dirname(__file__)) + '/subnets_lshosts.json'
#HOSTS = []

def shallowsearch(query_string, target_dir):
    target_dir = target_dir + "/**/*"
    query_lower = query_string.lower()
    for filename in glob.iglob(target_dir, recursive = True):
        if query_lower in filename.lower():
            print(f"[+] {filename}")


def deepsearch(query_string, target_dir):
    try:
        result = subprocess.run([
            'grep', '-irHn', '--color=always', '--include=*.txt', '--include=*.md', query_string, target_dir
        ], capture_output=True, text=True)
        if result.stdout:
            for line in result.stdout.strip().split('\n'):
                print(f"[+] {line}")
    except Exception as e:
        print(f"[-] grep error: {e}")


def searchString(query_string, is_deep) -> None:
    if IS_VERBOSE:
        print(f"[!] Verbose mode enabled")
        if not is_deep:
            print(f"[!] Searching for '{query_string}' by 'filename'")
        else:
            print(f"[!] Searching for '{query_string}' by 'contents'")

        print(f"[!] Scanning {LOCATIONS}", end = "\n\n")

    for location in LOCATIONS:
        print(f"[+] ::: {location} :::")

        target_dir = HOME + "/" + location
        if not is_deep:
            shallowsearch(query_string, target_dir)
        else:
            deepsearch(query_string, target_dir)

        print(f"[+] :::::::::::::::::", end = "\n\n")


def main() -> None:
    parser = argparse.ArgumentParser(description = 'Search documents locally by name or by contents, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('-d', '--deep', action = 'store_true', help = 'search file contents instead of filenames')
    parser.add_argument('-q', '--query', metavar = '<string>', type = str, required = True, help = 'query string')
    parser.add_argument('-v', '--verbose', action = 'store_true', help = 'shows additional information during execution')
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

    searchString(args.query, args.deep)


if __name__ == '__main__':
    main()
