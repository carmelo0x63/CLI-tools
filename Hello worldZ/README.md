### Assembly
#### x86_64
Source code:
<pre>
global _start

section .text

_start:
  mov rax, 1        ; write(
  mov rdi, 1        ;   STDOUT_FILENO,
  mov rsi, msg      ;   "Hello, world!\n",
  mov rdx, msglen   ;   sizeof("Hello, world!\n")
  syscall           ; );

  mov rax, 60       ; exit(
  mov rdi, 0        ;   EXIT_SUCCESS
  syscall           ; );

section .rodata
  msg: db "Hello, world!", 10
  msglen: equ $ - msg
</pre>

Check:
<pre>
$ nasm -f elf64 hello_x64.s -o hello_x64.o

$ ld hello_x64.o -o hello_x64.exe

$ ./hello_x64.exe
Hello, world!
</pre>

#### AArch64

----

### C
Source code:
<pre>
#include <stdio.h>

int main(void) {
    printf("Hello, world!\n");
    return 0;
}</pre>

Check:
<pre>
$ gcc hello_c.c -o hello_c.exe

$ ./hello_c.exe
Hello, world!
</pre>

----

### Python
Source code:
<pre>
#!/usr/bin/env python3

print('Hello, world!')
</pre>

Check:
<pre>
$ python3 hello.py
Hello, world!
</pre>

----

### Julia
Source code:
<pre>
print("Hello World!\n")
</pre>

Check:
<pre>
$ julia hello.jl
Hello World!
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
