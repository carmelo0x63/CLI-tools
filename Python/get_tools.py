#!/usr/bin/env python3
# The ultimate tool to download missing tools 
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history:
#  1.0: First version: Golang, Terraform, docker-compose

import os

# Global variables
SWDEPOT = '/Downloads/'

def chkswdepot():
#    print(os.path.abspath(__file__))
#    print(os.path.dirname(os.path.abspath(__file__)))
#    print(os.getcwd())
    if not os.path.exists(os.getcwd() + SWDEPOT):
        print('[+] Creating: ' + os.getcwd() + SWDEPOT)
        os.mkdir(os.getcwd() + SWDEPOT)
    elif os.path.isdir(os.getcwd() + SWDEPOT):
        print('[!] WARN: directory ' + os.getcwd() + SWDEPOT + ' is already present')
    else:
        print('[-] ERROR: file ' + os.getcwd() + SWDEPOT + ' is already present')

def main():
    chkswdepot()

if __name__ == '__main__':
    main()

