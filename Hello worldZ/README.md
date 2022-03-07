### Assembly
#### x86_64
Source code:
<pre>
global _start

section .text

_start:
  mov rax, 1        ; write(
  mov rdi, 1        ;   STDOUT_FILENO,
  mov rsi, msg      ;   "Hello, worldZ!\n",
  mov rdx, msglen   ;   sizeof("Hello, worldZ!\n")
  syscall           ; );

  mov rax, 60       ; exit(
  mov rdi, 0        ;   EXIT_SUCCESS
  syscall           ; );

section .rodata
  msg: db "Hello, worldZ!", 10
  msglen: equ $ - msg
</pre>

Check:
<pre>
$ nasm -f elf64 hello_x64.s -o hello_x64.o

$ ld hello_x64.o -o hello_x64.exe

$ ./hello_x64.exe
Hello, worldZ!
</pre>

#### AArch64
Source code:
<pre>
</pre>

Check:
<pre>
</pre>

----

### C
Source code:
<pre>
#include <stdio.h>

int main(void) {
    printf("Hello, worldZ!\n");
    return 0;
}
</pre>

Check:
<pre>
$ gcc hello_c.c -o hello_c.exe

$ ./hello_c.exe
Hello, worldZ!
</pre>

----

### Python
Source code:
<pre>
#!/usr/bin/env python3

print('Hello, worldZ!')
</pre>

Check:
<pre>
$ python3 hello.py
Hello, worldZ!
</pre>

----

### Julia
Source code:
<pre>
print("Hello, worldZ!\n")
</pre>

Check:
<pre>
$ julia hello.jl
Hello, worldZ!
</pre>

----

### Go
Source code:
<pre>
package main

import "fmt"

func main() {
	fmt.Println("Hello, worldZ!")
}
</pre>

Check:
<pre>
$ go run hello.go                                                       
Hello, worldZ!
</pre>

----

### Haskell
Source code:
<pre>
main = putStrLn "Hello, worldZ!"
</pre>

Check:
<pre>
$ ghc --make hello.hs
[1 of 1] Compiling Main             ( hello.hs, hello.o )
Linking hello ...

$ ./hello
Hello, worldZ!
</pre>

<!--
----

### C
Source code:
<pre>
</pre>

Check:
<pre>
</pre>
-->


