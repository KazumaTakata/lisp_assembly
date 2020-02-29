    extern  _malloc
    extern  _calloc



    section .data

    struc Token
.type resq  1
.value resq 1
    endstruc


    section .text


_init_Token:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16 

    mov [rsp + 0], rdi
    mov [rsp + 8], rsi 


    mov rdi, Token_size
    call _malloc

    mov rcx, [rsp + 0]
    mov qword [rax + Token.type], rcx

    mov rcx, [rsp + 8]
    mov qword [rax + Token.value], rcx 



    leave
    ret
        


print_Token:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16

    mov [rsp+0], rdi

    mov rax, qword [rdi+Token.type]


    cmp rax,LPAREN 
    jne _print_else1


    lea  rdi, [lparen]
    xor  rax, rax
    call  _printf
    

    mov rax, [rsp+0]
    mov rdi, qword [rax+Token.value]
    xor  rax, rax
    call  _printf
    




    jmp _print_fi


_print_else1:


    cmp rax, RPAREN
    jne _print_else2
 


    lea  rdi, [rparen]
    xor  rax, rax
    call  _printf
    


    mov rax, [rsp+0]
    mov rdi, qword [rax+Token.value]
    xor  rax, rax
    call  _printf
    



    jmp _print_fi



_print_else2:

    cmp rax, NUMBER
    jne _print_else3
 


    lea  rdi, [number]
    xor  rax, rax
    call  _printf
    

    mov rax, [rsp+0]
    mov rdi, qword [rax+Token.value]
    xor  rax, rax
    call  _printf
    



    jmp _print_fi


_print_else3:

    cmp rax, PLUS
    jne _print_else4
 


    lea  rdi, [plus]
    xor  rax, rax
    call  _printf
    

    mov rax, [rsp+0]
    mov rdi, qword [rax+Token.value]
    xor  rax, rax
    call  _printf
    



    jmp _print_fi


_print_else4:

_print_fi:

 
    leave
    ret




