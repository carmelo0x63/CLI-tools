#!/usr/bin/env python3
# Single-sourcing the verion number and other global information

about = {}
with open("__about__.py") as fp:
    exec(fp.read(), about)

print('This package\'s version is ' + about['__version__'], end = '\n\n')

