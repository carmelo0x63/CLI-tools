#!/usr/bin/env python3
# Variable-length random password generator
# author: mellowizAThotmailDOTcom
# history, date format ISO 8601:
#  2020-04-05 3.0 Refactored to Python3
#  2017-01-17 2.4 added ability to remove some characters from the original strings
#  2016-09-26 2.3 added an "owasp" and a "safe" option
#  2.2 added constraint to include at least one Capital letter + one Numeric char
#  2.1 added "-a" to generate aplhanumeric-only passwords
#  2.0 variable length passwords
#  1.0 initial version

# Import some modules
import string    # Common string operations
import argparse  # Parser for command-line options, arguments and sub-commands
import random    # Generate pseudo-random numbers
import sys       # System-specific parameters and functions

# Version number
__version__ = "3.0"
__build__ = "20200403"

# Here we build the string of allowed characters
# as "a-z" + "A-Z" + "0-9"
alphaChars = string.ascii_letters + string.digits
# as "a-z" + "A-Z" + "0-9" + "safe" special characters
safeChars = string.ascii_letters + string.digits + '!@#$%^&*()'
# https://www.owasp.org/index.php/Password_special_characters
owaspChars = string.ascii_letters + string.digits + '!"#$%&()*+,-./:;<=>?@[\]^_`{|}~'
# Minimum length for the final password
minLen = 3

def main():
    parser = argparse.ArgumentParser(description='Generate random password, version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('pwLen', metavar='<password length>', type=int, help='Integer number, must be 3(!) or more')
    parser.add_argument('-a', '--alpha', action='store_true', help='alphanumeric only')
    parser.add_argument('-r', '--remove', help='list of characters to be skipped')
    parser.add_argument('-s', '--safe', action='store_true', help='alphanumeric + "safe" special characters')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s ' + __version__)

    # In case of no arguments print help message then exit
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    else:
        args = parser.parse_args() # else parse command line

    if args.pwLen < minLen:
        print('[+] Password too short, exiting!')
        sys.exit(2)

    # Finally feed arguments to the actual random password generator
    if args.alpha:
        print(generate_password(args.pwLen, "a", args.remove))
    elif args.safe:
        print(generate_password(args.pwLen, "s", args.remove))
    else:
        print(generate_password(args.pwLen, "", args.remove))

# Actual random password generator, takes three arguments:
# lenN: password length
# flavour: if eq 'a', password will contain alphanumeric characters only
# flavour: if eq 's', password will contain alphanumeric characters + a restricted set of special ones
# flavour: if empty, password will contain the full list
# remC: string of characters to be excluded
def generate_password(lenN, flavour, remC):
    # We first build a "mask", whose length is the same as the password itself,
    # to hold the "position" of at least one Capital letter and one Numeric character
    pwMask = ['-'] * lenN
    # reqChar is a non-repeating list of "positions" within the boundaries of the password length
    reqChar = random.sample(range(lenN),2)
    pwMask[reqChar[0]] = 'C'
    pwMask[reqChar[1]] = 'N'

    result = ''

    if flavour == "a": # switch "-a" or "--alpha" present
        pwChars = alphaChars
    elif flavour == "s": # switch "-s" or "--safe" present
        pwChars = safeChars
    else: # no switches, full power
        pwChars = owaspChars

    # If the characters-to-be-skipped string is not empty
    if remC:
        pwChars = rmChars(pwChars, remC)

    for ij in range(lenN): # add one password character for each "position" in list pwMask
        if pwMask[ij] == 'C': # force Capital letter
            result += random.choice(string.ascii_uppercase)
        elif pwMask[ij] == 'N': # force Numeric character
            result += random.choice(string.digits)
        else: # truly random character
            result += random.choice(pwChars)

    return result

# Function parsing "snd" string and, if present, removes its characters from "fst"
def rmChars(fst, snd):
    newChars = fst
    for char in snd:
        pos = newChars.find(char)
        if pos >= 0:
            newChars = ''.join(newChars[i] for i in range(len(newChars)) if i != pos)
    return newChars

# Main function
if __name__ == '__main__':
    main()

