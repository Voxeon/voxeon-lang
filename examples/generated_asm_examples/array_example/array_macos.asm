BITS 64
ALIGN 16
extern _malloc, _free

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
    push qword 8
    push qword 10

    call __new_array

    ; Free the arguments
    mov rsp, rbp

    ; Store the new local variable
    push rax

    ; $array:0 <- 3
    mov r8, [rsp]
    mov qword[r8 + 8 * (0 + 1)], 3

    ; $array:9 <- 12
    mov r8, [rsp]
    mov qword[r8 + 8 * (9 + 1)], 12
    
    ; The stack contains the address of the array to free
    mov rbp, rsp
    mov rdi, [rsp]
    and rsp, -16
    call _free
    mov rsp, rbp

    ; Remove local variables and reset the frame pointer
    add rsp, 8
    pop rbp

    ; Exit
    mov rax, 0
    ret

; rax contains a pointer to the array
__new_array:
    push rbp

    mov r8, [rsp + 16] ; arg 1 - count
    mov r9, [rsp + 24] ; arg 2 - size
    mov rax, r8
    mul r9
    mov r8, rax
    add r8, 8 ; Add 8 bytes to store the length of the array

    mov rdi, r8
    mov rbp, rsp
    and rsp, -16
    call _malloc

    mov rsp, rbp
    ; Check if malloc failed
    test rax, rax

    ; Move the address to rdi
    mov rdi, rax

    ; Store the length
    mov r8, [rsp + 16] ; arg 1 - count
    mov [rdi], r8

    ; Reset the address to rax
    mov rax, rdi

    ; Return
    pop rbp
    ret