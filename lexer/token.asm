    extern  _malloc



    section .data

    struc Token
.type resq  1
.value resb 1
    endstruc


    section .text


_init_Token:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16 

    mov [rsp + 0], rdi
    mov [rsp + 8], sil


    mov rdi, Token_size
    call _malloc

    mov rcx, [rsp + 0]
    mov qword [rax + Token.type], rcx

    mov cl, [rsp + 8]
    mov byte [rax + Token.value], cl




    leave
    ret
        


