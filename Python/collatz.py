# Obsolete: this script lives in its own repository now
# git@github.com:carmelo0x99/Collatz-Conjecture.git
#!/usr/bin/env python
# description: Calculating Collatz conjecture convergence
# author: Carmelo C
# email: carmelo.califano@gmail.com
# date (ISO 8601): 2017-11-13
# source: https://en.wikipedia.org/wiki/Collatz_conjecture

from __future__ import print_function # print() as a function not as a statement

steps = big = bigin = 0	# Initializing some variables, needed for the computation
sut = []	# Initializing an empty list, it will contain all the results of the calculations
#seq = []

def collatz(n):
    global steps, sut, big, bigin
    sut.append(n) # appending the first and any intermediate result, algorithm is based on recursion
    if n > big:
        big = n
        bigin = steps
    if n == 1:
        print('Number of steps to converge: {}\n'.format(steps))
        return 
    steps += 1
    if n % 2 == 0:
        return collatz(n/2)
    if (n % 2 != 0):
        return collatz(3 * n + 1)

def main():
    collatz(1)
    print(sut)

if __name__ == '__main__':
  main()
