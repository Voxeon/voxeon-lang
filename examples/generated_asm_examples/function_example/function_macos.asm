BITS 64
ALIGN 16

; Function calling convention
;  - Caller
; save rsp to rbp
; align the stack
; pad with 8 bytes if required
; push arguments onto stack from right - to - left
; call function
; restore rsp to rbp, freeing the stack arguments.
;
; ------------------------------------------------------------
;  - Callee
; push rbp
; function body
; pop rbp
; return (store return value in rax)


section .text
global _main

_main:
    ; Align the stack
    push rbp
    ; Set the frame pointer
    mov rbp, rsp

    ; Function call
    mov rbp, rsp
    and rsp, -16 ; 16 byte aligned
    push qword 13
    push qword 12

    call add_two_numbers

    ; Free the arguments
    mov rsp, rbp

    ; Store the new local variable
    push rax

    mov r8, [rsp]
    ; Remove local variables and reset the frame pointer
    add rsp, 8
    pop rbp

    ; Exit
    mov rax, r8
    ret

add_two_numbers:
    push rbp

    mov r8, [rsp + 16]
    mov r9, [rsp + 24]

    add r8, r9

    mov rax, r8

    pop rbp
    ret