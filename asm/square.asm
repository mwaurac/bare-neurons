global square

section .text

; int64_t square(int64_t x)
; x in RDI
; return in RAX

square:
    mov rax, rdi
    imul rax, rdi
    ret