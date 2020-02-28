    global  _main
    extern  _printf
    default  rel


%include "lexer.asm"

    section .text


string: db "(+ 5 3)", 0

i equ 0



_main:
    push rbp
    mov  rbp, rsp
    sub  rsp, 16 

    mov  al, byte [string]

    mov  rax, 0 
    mov  qword [rsp+i], rax

_loop:



    lea rdi, [string]
    mov rsi, [rsp+i]
    call get_Token

    mov rax, qword [rsp+i]   
    inc rax
    mov qword [rsp+i], rax

    cmp rax, 7 
    jne _loop


    xor  rax, rax
    leave
    ret
