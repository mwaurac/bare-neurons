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

; void relu_backward(const float *grad_in, const float *z, float *grad_out, i64 n)
; rdi=grad_in, rsi = z, rdx = grad_out, rcx = n 
;
;grad_out[i] = z[i] > 0 ? grad_in[i] : 0 
;
global relu_backward
relu_backward:
  vxorps ymm15, ymm15, ymm15
  mov rax, rcx
  and rax,  -8
  xor r10, r10

.rb_vec:
  cmp r10, rax
  jge .rb_vec_done
  vmovups ymm0, [rdi + r10*4]
  vmovups ymm1, [rsi + r10*4]
  vcmpps ymm2, ymm1, ymm15, 14
  vandps ymm0, ymm0, ymm2
  vmovups [rdx + r10*4], ymm0
  add r10, 8
  jmp .rb_vec

.rb_vec_done:
.rb_tail:
  cmp r10, rcx
  jge .rb_tail_done 
  vmovss xmm0, [rdi + r10*4]
  vmovss xmm1, [rsi + r10*4]
  vcmpss xmm2, xmm1, xmm15, 14
  vandps xmm0, xmm0, xmm2
  vmovss [rdx + r10*4], xmm0
  inc r10
  jmp .rb_tail

.rb_tail_done:
  vzeroupper
  ret
