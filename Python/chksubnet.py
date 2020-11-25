#! /usr/bin/python

import socket
import os
import sys
baseIP = '172.16.31.'

def retBanner(ip, port):
    try:
        socket.setdefaulttimeout(2)
        s = socket.socket()
        s.connect((ip, port))
        banner = s.recv(024)
        return banner
    except:
        return

def checkVulns(banner, filename):
    f = open(filename, 'r')
    for line in f.readlines():
        if line.strip('\n') in banner:
            print('[+] Server is vulnerable: ' + banner.strip('\n'))

def main():
    if len(sys.argv) == 4:
        startip = int(sys.argv[1])
        endip = int(sys.argv[2])
        filename = sys.argv[3]
        if not os.path.isfile(filename):
            print('[-]' + filename + 'does not exist')
            exit(0)
        if not os.access(filename, os.R_OK):
            print('[-]' + filename + 'access denied')
            exit(0)
    else:
        print('[-] Usage: ' + str(sys.argv[0]) + ' <start IP> <end IP> <vuln filename>')
        print('[-]        network is hardcoded: ' + baseIP + '0 \n')
        exit(0)
    portList = [21,22,25,80,110,443]
    for x in range(startip, endip):
#        ip = '10.58.8.' + str(x)
        ip = baseIP  + str(x)
        print('[+] Checking IP: ' + ip + ' [+]')
        for port in portList:
            banner = retBanner(ip, port)
            if banner:
                print('[+] ' + ip + ': ' + banner)
                checkVulns(banner, filename)
            else:
                print('[-] No response from: ' + ip + ' on port: ' + str(port))
        print('[++++++++++++++++++++++]\n')

if __name__ == '__main__':
    main()
