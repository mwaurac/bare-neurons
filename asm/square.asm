global square

section .text


square:
    mov rax, rdi
    imul rax, rdi
    ret
