### Assembly
#### x86_64
Source code: `hello_x64.s`
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
Source code: `hello_a64.s`
<pre>
.data

/* Data segment: define our message string and calculate its length. */
msg:
    .ascii        "Hello, worldZ!\n"
len = . - msg

.text

/* Our application's entry point. */
.globl _start
_start:
    /* syscall write(int fd, const void *buf, size_t count) */
    mov     x0, #1      /* fd := STDOUT_FILENO */
    ldr     x1, =msg    /* buf := msg */
    ldr     x2, =len    /* count := len */
    mov     w8, #64     /* write is syscall #64 */
    svc     #0          /* invoke syscall */

    /* syscall exit(int status) */
    mov     x0, #0      /* status := 0 */
    mov     w8, #93     /* exit is syscall #93 */
    svc     #0          /* invoke syscall */
</pre>

Check:
<pre>
$ as -o hello_a64.o hello_a64.s

$ ld -s -o hello_a64.exe hello_a64.o

$ ./hello_a64.exe
Hello, worldZ!
</pre>

----

### C
Source code: `hello_c.c`
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
Source code: `hello.py`
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
Source code: `hello.jl`
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
Source code: `hello.go`
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

### Node.js
Source code: `hello.js`
<pre>
console.log("Hello, worldZ!")
</pre>

Check:
<pre>
$ node hello.js
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


