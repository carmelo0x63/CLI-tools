#!/usr/bin/env python3
# Scans a remote host to display all available common TLS ciphers
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2021-01-14: 1.2 module "requests" removed, no dependencies other than Python standard library
#  2020-04-05: 1.1 added argparse, quiet mode
#  2020-01-03: 1.0 initial version

import argparse, json, subprocess, sys

# Version number
__version__ = "1.2"
__build__ = "20210114"

def main():
    parser = argparse.ArgumentParser(description='Queries GitHub API returning any repositories owned by <GitHub user name>, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('username', metavar='<GitHub user name>', type=str)
    parser.add_argument('-q', '--quiet', action='store_true', help='Quiet mode, displays only the repositories\' names')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s ' + __version__)

    # In case of no arguments print help message then exits
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    else:
        args = parser.parse_args() # else parse command line

    # Documentation available at https://developer.github.com/
    url = 'https://api.github.com/users/' + args.username + '/repos'

    repos = subprocess.check_output(['curl', '-sSL', url])
    repos_list = json.loads(repos)
    N = len(repos_list)
    SPACER = ''

    if not args.quiet:
        print('User \"' + args.username + '\" owns ' + str(N) + ' repositories:')
        SPACER = '-> '

    for repo in repos_list:
        print(SPACER + repo['name'])

if __name__ == '__main__':
    main()

