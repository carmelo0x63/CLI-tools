Python tools:
- git_repos.py
- rndpwgen.py
- ssl_test_ciphers.py


```
./git_repos.py -h
usage: git_repos.py [-h] [-q] [-v] <GitHub user name>

Queries GitHub API returning any repositories owned by <GitHub user name>,
version 1.1, build 20200405.

positional arguments:
  <GitHub user name>

optional arguments:
  -h, --help          show this help message and exit
  -q, --quiet         Quiet mode, displays on the repositories' names
  -v, --version       show program's version number and exit
```

```
./rndpwgen.py -h
usage: rndpwgen.py [-h] [-a] [-r REMOVE] [-s] [-v] <password length>

Generate random password, version 3.0, build 20200403.

positional arguments:
  <password length>     Integer number, must be 3(!) or more

optional arguments:
  -h, --help            show this help message and exit
  -a, --alpha           alphanumeric only
  -r REMOVE, --remove REMOVE
                        list of characters to be skipped
  -s, --safe            alphanumeric + "safe" special characters
  -v, --version         show program's version number and exit
```

```
./ssl_test_ciphers.py -h
usage: ssl_test_ciphers.py [-h] [-v] <IP address> <Port number>

Scans <IP address>:<IP address> querying all the supported TLS ciphers,
version 2.0, build 20200403.

positional arguments:
  <IP address>   IP address of the host to scan for ciphers
  <Port number>  Port number, usually equals 443

optional arguments:
  -h, --help     show this help message and exit
  -v, --version  show program's version number and exit
```
