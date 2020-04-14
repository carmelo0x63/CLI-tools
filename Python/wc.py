#!/usr/bin/env python
# Personal version of wc written in Python
# source: https://github.com/mellowiz/wcPython
# history, date format ISO 8601:
#  2018-01-11 1.0 initial version

from __future__ import print_function	# future statement definitions
import argparse				# Parser for command-line options, arguments and sub-commands
import sys				# system-specific parameters and functions

# Version number
__version__ = 1.0
__build__ = 180111

def Rows(f):
  rTotal = 0
  for row in f:
    rTotal += 1
  print(str(rTotal) + " rows", end='\r')

def Words(f):
  wTotal = 0
  for row in f:
    words = len(row.split())
    wTotal += words
  print(str(wTotal) + " words")

def Chars(f):
  cTotal = 0
  while f.read(1):
    cTotal += 1
  print(str(cTotal) + " characters")

def main():
  parser = argparse.ArgumentParser(description='wc command written in Python, version {version}, build {build}.'.format(version=__version__, build=__build__))
  parser.add_argument('fileName', metavar='<File name>', type=str, help='Path to filename to be parsed')
  parser.add_argument('-m', '--mode', metavar="<Mode>", type=str, help='Counts Rows, Words or Characters')
  parser.add_argument('-V', '--version', action='version', version='%(prog)s {version}'.format(version=__version__))

  # In case of no arguments print help message then exit
  if len(sys.argv) == 1:
    parser.print_help()
    sys.exit(1)
  else:
    args = parser.parse_args() # else parse command line

  fileName = args.fileName

  try:
    file1 = open(fileName, 'r')
  except IOError:
    print("Filename \"" + fileName + "\" not found!!!")
    sys.exit(2)
#    return 1
#    raise SystemExit

  if args.mode == "R":
    Rows(file1)
  elif args.mode == "W":
    Words(file1)
  elif args.mode == "C":
    Chars(file1)
  else:
    print("Argument not available")
    print()
    sys.exit(3)

  file1.close()
  print()

if __name__ == '__main__':
  main()
