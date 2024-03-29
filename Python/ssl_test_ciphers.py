#!/usr/bin/env python3
# Scans a remote host to display all available common TLS ciphers
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#   2020-04-03: 2.0 moved to Python3, polished a few quirks
#   2016-10-14: 1.0 initial version
# Ported to Python from http://superuser.com/questions/109213/how-do-i-list-the-ssl-tls-cipher-suites-a-particular-website-offers


# Import some modules
import argparse				# write user-friendly command-line interfaces
import os				# use operating system dependent functionalities
import subprocess			# spawn new processes, connect to their input/output/error pipes, and obtain their return codes
import sys				# variables used or maintained by the interpreter and functions that interact strongly with the interpreter
from multiprocessing import Process

# Version number
__version__ = '2.0'
__build__ = '20240318'
EPILOG=' '

# https://svn.blender.org/svnroot/bf-blender/trunk/blender/build_files/scons/tools/
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def validIP(ipAddrs):
    # Split the input string into a list of octets
    octList = ipAddrs.split('.')
    # Must contain 4 octets
    if len(octList) != 4:
        return False
    # Each octet must be a digit AND between 0 and 255
    for x in octList:
        if not x.isdigit():
            return False
        i = int(x)
        if i < 0 or i > 255:
            return False
    return True

def clientConnect(cipher, ipaddr, portn):
    # Here we build the command string, stderr is redirected to stdout to keep output clean
    cmdstr = 'echo -n | openssl s_client -cipher ' + cipher + ' -connect ' + ipaddr + ':' + portn + ' 2>&1'
    # Send the command string to subprocess for execution
    try:
        sslout = subprocess.check_output(cmdstr, shell = True, stderr = subprocess.STDOUT)
    except:
        sslout = b':error:'

    if ":error:" in sslout.decode():
        print(bcolors.FAIL + '[-] ' + cipher + ' NOT supported!' + bcolors.ENDC)
    else:
        print(bcolors.OKBLUE + '[+] ' + cipher + ' supported!!!' + bcolors.ENDC)

def main():
    parser = argparse.ArgumentParser(description = 'Scans <IP address>:<IP address> querying all the supported TLS ciphers, version ' + __version__ + ', build ' + __build__ + '.', epilog=EPILOG)
    parser.add_argument('ipAdd', metavar = '<IP address>', type = str, help = 'IP address of the host to scan for ciphers')
    parser.add_argument('whichPort', metavar = '<Port number>', type = str, help = 'Port number, usually equals 443')
    parser.add_argument('-V', '--version', action = 'version', version = '%(prog)s ' + __version__ + '')

    # In case of no arguments print help message then exits
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    else:
        args = parser.parse_args() # else parse command line

    # Let's validate input
    if not validIP(args.ipAdd):
        print('[-] Address is not a valid IPv4 one!')
        print('[-] Exiting...', end='\n\n')
        sys.exit(2)

    if (int(args.whichPort) < 1) or (int(args.whichPort) > 65535):
        print('[-] Port out of range!')
        print('[-] Exiting...', end='\n\n')
        sys.exit(3)

    # If input is OK we can continue. First we fetch the output of openssl ciphers run on the local machine
    # this will give us a string with all the locally supported ciphers
    sslVer = subprocess.check_output(['openssl', 'version'])
    print('[+] ' + os.uname()[0] + ' version ' + os.uname()[2] + ' running on ' + os.uname()[4] + ' platform')
    print('[+] ' + sslVer.decode().rstrip() + ', fetching the list of locally supported ciphers...')
    myCiphers = subprocess.check_output(['openssl', 'ciphers', 'ALL:eNULL'])

    # Transform string into a list
    lCiphers = myCiphers.decode().rstrip('\n').split(':')

    for cipher in lCiphers:
        result = Process(target=clientConnect, args=(cipher, args.ipAdd, args.whichPort,))
        result.start()
        result.join(timeout = 1)
        result.terminate()
      
if __name__ == '__main__':
  main()

