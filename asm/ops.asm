section .rodata

section .text

; void relu_forward(const float *z, float *a, i64 n)
; rdi=z, rsi=a, rdx=n
;
global relu_forward
relu_forward:
  vxorps ymm15, ymm15, ymm15
  mov rax, rdx
  and rax, -8
  xor rcx, rcx ; index counter starting at 0

.rf_vec:
  cmp rcx, rax
  jge .rf_vec_done
  vmovups ymm0, [rdi + rcx*4] ; load 8 floats from input
  vmaxps ymm0, ymm0, ymm15 ; max of values
  vmovups [rsi + rcx*4], ymm0
  add rcx, 8
  jmp .rf_vec

.rf_vec_done:
.rf_tail:
  ; I guess this is why we prefer powers of 2 in matrices
  ; after proceeding with a block of 8 using avx do elementwise for the reset
  cmp rcx, rdx
  jge .rf_tail_done
  vmovss xmm0, [rdi + rcx*4]
  vmaxss xmm0, xmm0, xmm15
  vmovss [rsi + rcx*4], xmm0
  inc rcx
  jmp .rf_tail

.rf_tail_done:
  vzeroupper
  ret
