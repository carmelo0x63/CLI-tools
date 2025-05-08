#!/usr/bin/env python3
# ipv4pingsweep: pings an entire subnet, multithreaded
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#   2025-05-08: 1.4 added IP-to-name conversion
#   2024-07-19: 1.3 moved default threads into parser option
#   2023-07-07: 1.2 UP/DOWN logic, replaced subprocess.Popen w/ subprocess.call
#   2023-05-31: 1.1 improved UP/DOWN logic
#   2022-07-10: 1.0 initial version
# Adapted from: https://github.com/gh0x0st/python3_multithreading
# Useful link(s): https://gist.github.com/sourceperl/10288663

# Import some modules
import argparse         # Parser for command-line options, arguments and sub-commands
import ipaddress        # IPv4/IPv6 manipulation library
import queue            # A synchronized queue class
import subprocess       # Subprocess management
import sys              # System-specific parameters and functions
import threading        # Thread-based parallelism
import time             # Time access and conversions

# Settings
ICMPCOUNT = '1'
ICMPWAIT = '1'
HOSTS_FILE = '/etc/hosts'

# Version number
__version__ = '1.4'
__build__ = '20250508'


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


def worker():
    while True:
        target = q.get()
        send_ping(str(target))
        q.task_done()


def get_hostname(target):
    hostname = target
    for host in HOSTS_LIST:
        if not host.startswith("#") and target in host:
            hostname = host.split('\t')[1].rstrip()

    return(hostname)


def send_ping(target):
    icmp_response = subprocess.call(['ping', '-c', ICMPCOUNT, '-W', ICMPWAIT, target], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    with thread_lock:
        if icmp_response == 0: 
            if IS_NAME:
                target_name = get_hostname(target)
                print(bcolors.OKGREEN + '[+]' + bcolors.ENDC + f' {target_name} is UP')
            else:
                print(bcolors.OKGREEN + '[+]' + bcolors.ENDC + f' {target} is UP')
        else:
            if IS_VERBOSE:
                print(bcolors.FAIL + '[-]' + bcolors.ENDC + f' {target} is DOWN')


def main():
    parser = argparse.ArgumentParser(description='IPv4 ping/ICMP sweeper, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('-n', '--name', action = 'store_true', help = 'IP-to-name conversion')
    parser.add_argument('-s', '--subnet', metavar = '<subnet>', type = str, help = 'subnet as aa.bb.cc.dd/xx, in case of no subnet mask xx = 32')
    parser.add_argument('-t', '--threads', metavar = '<threads>', type = int, default = 20, help = 'number of threads (default = 20)')
    parser.add_argument('-v', '--verbose', action = 'store_true', help = 'print extended information')
    parser.add_argument('-V', '--version', action = 'version', version = '%(prog)s ' + __version__)

    # In case of no arguments shows help message
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(10)  # ERROR: no arguments
    else:
        args = parser.parse_args() # parse command line

    # A global variable is instantiated in case of -v/--verbose argument
    global IS_VERBOSE
    IS_VERBOSE = args.verbose

    # A global variable is instantiated in case of -n/--name argument
    global IS_NAME
    IS_NAME = args.name
    if IS_NAME:
        with open(HOSTS_FILE) as f:
            global HOSTS_LIST
            HOSTS_LIST = f.readlines()

    # "subnet" is parsed from input and validated with "ipaddress"
    if args.subnet:
        subnet = args.subnet
        try:
            ipaddress.ip_network(subnet)
        except ValueError:
            print(f'[-] {subnet} does not appear to be an IPv4 or IPv6 network')
            sys.exit(20)  # ERROR: input must be an IPv4 subnet

    subnet_valid = ipaddress.ip_network(subnet)

    if not isinstance(subnet_valid, ipaddress.IPv4Network) and IS_VERBOSE:
        print(f'[-] {subnet_valid} is an INVALID IPv4 network address')
        sys.exit(20)  # ERROR: input must be an IPv4 subnet

    # The number of threads is set to a safe value, 10, but can be changed from command-line
#    threads = 10
#    if(args.threads):
#        threads = args.threads

    for r in range(args.threads):
        t = threading.Thread(target = worker)
        t.daemon = True
        t.start()

    # Start timer before sending tasks to the queue
    start_time = time.time()

    all_hosts = list(ipaddress.ip_network(subnet).hosts())

    if IS_VERBOSE:
        print(f'[!] Creating a task request for each host in {subnet_valid}')

    # send task requests to the worker
    for item in all_hosts:
        q.put(item)

    # block until all tasks are done
    q.join()

    if IS_VERBOSE:
        print(f'[!] All workers completed their tasks after {round(time.time() - start_time, 2)} seconds')


if __name__ == '__main__':
    # Define a print lock
    thread_lock = threading.Lock()
    # Create our queue
    q = queue.Queue()

    main()
 
