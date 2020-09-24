Bash tools

`bakessh.sh`:
Checks OpenSSH config against a set of rules

`chkdns.sh`:
Small utility checking the status of DNS servers

`git_fetch_all.sh`:
Iterates through the local repositories, assumed to be under TARGETDIR

`git_status_all.sh`:
Iterates through the local repositories, assumed to be under TARGETDIR

`mybkp.sh`:
Backs-up files to the backup directory

`testos.sh`:
Simple script to check + display OS version

`get_golang.sh`:
- case first install:
```
[!] It looks as if you don't have a Go binary on your system
[+] Fetching the latest version of Go/Golang from https://golang.org
[+] Found archive go1.15.2.linux-amd64.tar.gz, v. 1.15.2
[+] Installing Go 1.15.2
[+] /home/<user>/Downloads exists, storing archive locally
[+] File go1.15.2.linux-amd64.tar.gz already exists
[+] Installing Go/Golang v. 1.15.2
[+] You're now running Go v. 1.15.2
```

- case upgrade:
```
[+] Your current Go/Golang version is 1.15.1
[+] Fetching the latest version of Go/Golang from https://golang.org
[+] Found archive go1.15.2.linux-amd64.tar.gz, v. 1.15.2
[!] Upgrading: 1.15.1 -> 1.15.2
[+] /home/<user>/Downloads exists, storing archive locally
[+] File go1.15.2.linux-amd64.tar.gz already exists
[!] Removing previous installation...
[!] .. sudo credentials are requested
[+] Installing Go/Golang v. 1.15.2
[+] You're now running Go v. 1.15.2
```

- case up-to-date:
```
[+] Your current Go/Golang version is 1.15.2
[+] Fetching the latest version of Go/Golang from https://golang.org
[+] Found archive go1.15.2.linux-amd64.tar.gz, v. 1.15.2
[+] You are up-to-date
```

