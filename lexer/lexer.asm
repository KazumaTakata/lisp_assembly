    default  rel


%include "token.asm"


    section .data

    struc Lexer 
.value resq  1
.pos    resq  1
    endstruc



    section .text


LPAREN equ 0
RPAREN equ 1
NUMBER equ 2
PLUS   equ 3
MINUS  equ 4
MULTI    equ 5



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
        

print_Token:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16


    mov rax, qword [rdi+Token.type]


    cmp rax, RPAREN 
    jne _print_else1


    lea  rdi, [lparen]
    xor  rax, rax
    call  _printf
    
    jmp _print_fi


_print_else1:


    cmp rax, LPAREN
    jne _print_else2
 


    lea  rdi, [rparen]
    xor  rax, rax
    call  _printf
    
    jmp _print_fi



_print_else2:

    cmp rax, NUMBER
    jne _print_else3
 


    lea  rdi, [number]
    xor  rax, rax
    call  _printf
    
    jmp _print_fi


_print_else3:

    cmp rax, PLUS
    jne _print_else4
 


    lea  rdi, [plus]
    xor  rax, rax
    call  _printf
    
    jmp _print_fi


_print_else4:

_print_fi:

 
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

    mov  rdi, LPAREN
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


    mov  rdi, RPAREN
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

    mov  rdi, NUMBER
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

    mov  rdi, PLUS
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



