#!/usr/bin/env python
# description: Exercises on Linear-Feedback Shift Registers (LFSR).
#              Inspired by: http://blog.stephenwolfram.com/2016/05/solomon-golomb-19322016/
#              Info: https://en.wikipedia.org/wiki/Linear-feedback_shift_register
#              Colored print: http://stackoverflow.com/questions/287871/print-in-terminal-with-colors-using-python
# author: mellowizAThotmailDOTcom
# date (ISO 8601): 2016-06-01

# Import some modules
from __future__ import print_function	# print() as a function not as a statement
import argparse	# Parser for command-line options, arguments and sub-commands

# Version number
__version__ = 1.0

def prtReg(L):
  '''
  Nicely prints out the list as a sequence of bits
  '''
#  R = []
#  for bit in L:
#    if L[bit] == 0:
#      R.append("_")
#    else:
#      R.append("#")
#  for bit in R:
  for bit in L:
    print(bit, end="")
  print()

def lShift(L):
  '''
  Shifts left the list's contents. The last element is filled in according to the formula
  at the end of the function.
  '''
  A = L[0]
  B = L[len(L)-2]
  C = L[len(L)-1]
  for j in range(len(L)-1):
    L[j] = L[j+1]
  L[len(L)-1] = A ^ B ^ C

def rShift(L):
  '''
  Shifts right the list's contents. The last element is filled in according to the formula
  at the end of the function.
  '''
  A = L[len(L)-1]
  B = L[len(L)-3]
  for j in range(len(L)-1, 0, -1):
    L[j] = L[j-1]
  L[0] = A ^ B 
  
def main():
# L0 is the initial value of the list/register.
#  L0 = [0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1]
  L0 = [0, 1, 0, 0, 1]
  L = list(L0) # "L" is created as a new list (i.e. not a copy), holding the same values
  print("Iteration:\t", 0, end="\t")
  print("\033[91m", end="")
  for bit in L0:
    print(bit, end="")
  print("\033[0m")
  for n in range(2**len(L)):
    rShift(L)
    print("Iteration:\t", n+1, end="\t")
    prtReg(L)
    if L == L0:
      break

if __name__ == '__main__':
  main()
