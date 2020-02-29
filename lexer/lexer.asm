    default  rel


%include "token.asm"


    section .data

    struc Lexer 
.value resq  1
.pos    resq  1
    endstruc



    section .text

format: db "%c", 10, 0
lparen: db " <LPAREN> ", 0
rparen: db " <RPAREN> ", 0
number: db " <NUMBER> ", 0
space: db " <SPACE> ", 0
plus: db " <PLUS> ", 0


_init_Lexer:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16 

    mov [rsp + 0], rdi
    mov [rsp + 8], rsi 


    mov rdi, Lexer_size
    call _malloc

    mov rcx, [rsp + 0]
    mov qword [rax + Lexer.value], rcx

    mov rcx, [rsp + 8]
    mov qword [rax + Lexer.pos], rcx

    leave
    ret
        




;rdi *Lexer

get_Token:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16

    xor rbx, rbx

    mov rax, [rdi+Lexer.value]
    mov rcx, [rdi+Lexer.pos]

    mov bl, byte [rax+rcx]

    mov [rsp+0], rdi


;switch 
;case '(':

begin:

    cmp bl, '('
    jne _else1
 
    ;lea  rdi, [lparen]
    ;xor  rax, rax
    ;call  _printf

    mov  rdi, 0
    mov  sil, '('
    call _init_Token

    mov [rsp+8], rax

    jmp  _fi

_else1:
;case ')'    
 
    cmp bl, ')'
    jne _else2

 
    ;lea  rdi, [rparen]
    ;xor  rax, rax
    ;call  _printf


    mov  rdi, 1
    mov  sil, ')'
    call _init_Token

    mov [rsp+8], rax





    jmp  _fi


_else2:
;case '[0-9]' 
    cmp bl, '0'
    jl _else3

    cmp bl, '9'
    jg _else3


 
;    lea  rdi, [number]
    ;xor  rax, rax
    ;call  _printf

    mov  rdi, 2 
    mov  sil, bl 
    call _init_Token

    mov [rsp+8], rax



    jmp  _fi


_else3:
;case ' '
 
    cmp bl, ' '
    jne _else4
    ;lea  rdi, [space]
    ;xor  rax, rax
    ;call  _printf

 
    mov rdi, [rsp+0]
   
    ;increment pos
    mov rax, [rdi+Lexer.pos]
    inc rax
    mov [rdi+Lexer.pos], rax

    ;get char
    mov rax, [rdi+Lexer.value]
    mov rcx, [rdi+Lexer.pos]
    mov bl, byte [rax+rcx]

    jmp  begin 


_else4:
;case '+'
 
    cmp bl, '+'
    jne _else5

 
    ;lea  rdi, [plus]
    ;xor  rax, rax
    ;call  _printf

    mov  rdi, 3
    mov  sil, '+'
    call _init_Token

    mov [rsp+8], rax


    jmp  _fi

_else5:


_fi:

 
    mov rdi, [rsp+0]
   
    mov rax, [rdi+Lexer.pos]
    inc rax
    mov [rdi+Lexer.pos], rax


    mov rax, [rsp+8]

    leave
    ret




