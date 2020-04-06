#!/usr/bin/env python3
# Scans a remote host to display all available common TLS ciphers
# author: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2020-04-05: 1.1 added argparse, quiet mode
#  2020-01-03: 1.0 initial version

import argparse, requests, sys

# Version number
__version__ = "1.1"
__build__ = "20200405"

def main():
    parser = argparse.ArgumentParser(description='Queries GitHub API returning any repositories owned by <GitHub user name>, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('username', metavar='<GitHub user name>', type=str)
    parser.add_argument('-q', '--quiet', action='store_true', help='Quiet mode, displays on the repositories\' names')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s ' + __version__)

    # In case of no arguments print help message then exits
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    else:
        args = parser.parse_args() # else parse command line

    # Documentation available at https://developer.github.com/
    url = 'https://api.github.com/users/' + args.username + '/repos'

    r = requests.get(url)
    R = r.json()
    N = len(R)
    SPACER = ''

    if not args.quiet:
        print('User \"' + args.username + '\" owns ' + str(N) + ' repositories:')
        SPACER = '-> '

    for repo in R:
        print(SPACER + repo.get('name'))

if __name__ == '__main__':
    main()

