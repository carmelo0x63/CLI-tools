#!/usr/bin/env python3
# Queries GitHub's API to fetch a list of repositories owned by one user 
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2022-07-21: 1.3 output re-formatted: q/quiet = list, otherwise the output will be vertical with numbers
#  2021-01-14: 1.2 module "requests" removed, no dependencies other than Python standard library
#  2020-04-05: 1.1 added argparse, quiet mode
#  2020-01-03: 1.0 initial version

import argparse, json, subprocess, sys

# Version number
__version__ = "1.3"
__build__ = "20220721"

def main():
    parser = argparse.ArgumentParser(description='Queries GitHub API returning any repositories owned by <GitHub user name>, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('username', metavar='<GitHub user name>', type=str)
    parser.add_argument('-q', '--quiet', action='store_true', help='Quiet mode, shows a list containing the repositories\' names')
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

    count = 1
    output_list = []
    for repo in repos_list:
        if args.quiet:
            output_list.append(repo['name'])
        else:
            print(str(count) + ': ' + repo['name'])
        count += 1

    if output_list:
        print(output_list)


if __name__ == '__main__':
    main()

