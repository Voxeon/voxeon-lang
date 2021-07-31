BITS 64
ALIGN 16

section .text
global main

main:
    ; Align the stack
    push rbp
    ; Set the frame pointer
    mov rbp, rsp

    ; Create space for one local variable
    sub rsp, 8

    ; $b: int <- 22
    mov qword[rsp], 22

    ; if $b = 22
    mov r8, [rsp]
    mov r9, 22

    cmp r8, r9
    je __IF_IF_0

__ELSE_IF_0:
    mov r8, [rsp]
    sub r8, 22
    mov [rsp], r8

    jmp __END_IF_0
__IF_IF_0:
    mov r8, [rsp]
    add r8, 22
    mov [rsp], r8

__END_IF_0: 
    mov r8, [rsp] 

    ; Free local variables
    add rsp, 8
    
    pop rbp

    ; Exit
    mov rax, r8
    ret