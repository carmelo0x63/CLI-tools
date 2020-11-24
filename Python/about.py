#!/usr/bin/env python3
# Single-sourcing the version number and other global information
# source: https://packaging.python.org/guides/single-sourcing-package-version/

about = {}
with open("__about__.py") as fp:
    exec(fp.read(), about)

print('This package\'s version is ' + about['__version__'], end = '\n\n')

