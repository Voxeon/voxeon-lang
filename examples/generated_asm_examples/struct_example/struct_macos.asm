BITS 64
ALIGN 16
extern _malloc, _free

; Struct
;struct BankAccount
;    balance(int) <- 0
;    id(int) <- 0
;    overdue(int) <- 0
;end(struct)
; TOTAL = 24 bytes,

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
    mov rax, 0
    push qword rax ; pad to 16 bytes
    mov rax, 91011
    push qword rax
    mov rax, 5678
    push qword rax
    mov rax, 1234
    push qword rax

    call bank_account_constructor_1

    ; Free the arguments
    mov rsp, rbp

    ; Store the new local variable
    push rax
    
    ; The stack contains the address of the struct to free
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

; rax contains a pointer to the BankAccount
bank_account_default:
    push rbp

    ; BankAccount size = 24
    mov rdi, 24
    mov rbp, rsp
    and rsp, -16
    call _malloc

    mov rsp, rbp
    ; Check if malloc failed
    test rax, rax

    ; Move the address to rdi
    mov rdi, rax

    ; Set the default values
    mov qword[rdi], 0
    mov qword[rdi + 8], 0
    mov qword[rdi + 16], 0

    ; Reset the address to rax
    mov rax, rdi

    ; Return
    pop rbp
    ret

bank_account_constructor_1:
    push rbp

    call bank_account_default
    push rax ; One local variable

    ; Set BankAccount.balance to arg1
    mov rax, qword[rsp + 24]
    mov rdi, [rsp]
    mov qword[rdi], rax

    ; Set BankAccount.id to arg2
    mov rax, qword[rsp + 32]
    mov rdi, [rsp]
    mov qword[rdi+8], rax

    ; Set BankAccount.overdue to arg3
    mov rax, qword[rsp + 40]
    mov rdi, [rsp]
    mov qword[rdi+16], rax

    mov rax, qword[rsp]
    add rsp, 8 ; Clear the local variable
    
    ; Return
    pop rbp
    ret