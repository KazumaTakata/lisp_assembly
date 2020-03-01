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
    sub     rsp, 32

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
;rsi if_peek
get_Token:

    push rbp
    mov  rbp, rsp
    sub  rsp, 48

    mov [rsp+0], rdi
    mov [rsp+40], rsi

    mov rdi, 1000
    mov rsi, 8
    call _calloc
    mov [rsp+16], rax



    ;get current char
    mov rdi, [rsp+0]
    mov rax, [rdi+Lexer.value]
    mov rcx, [rdi+Lexer.pos]
    xor rbx, rbx
    mov bl, byte [rax+rcx]

    ;save cur pos
    mov rcx, [rdi+Lexer.pos]
    mov qword [rsp+32], rcx


;switch 
;case '(':

begin:

    cmp bl, '('
    jne _else1
 
    mov rax, [rsp+16]
    mov byte [rax], bl 
    

    mov  rdi, LPAREN
    mov  rsi, rax
    call _init_Token
    mov [rsp+8], rax

    jmp  _fi

_else1:
;case ')'    
 
    cmp bl, ')'
    jne _else2

 
    mov rax, [rsp+16]
    mov byte [rax], bl 


    mov  rdi, RPAREN
    mov  rsi, rax 
    call _init_Token
    mov [rsp+8], rax


    jmp  _fi


_else2:
;case '[0-9]' 
    cmp bl, '0'
    jl _else3

    cmp bl, '9'
    jg _else3

 
    mov rax, [rsp+16]
    mov byte [rax], bl 

    mov qword [rsp+24], 1
    

number_loop:

    
    mov rdi, [rsp+0]
    mov rax, [rdi+Lexer.value]
    mov rcx, [rdi+Lexer.pos]
    mov bl, byte [rax+rcx+1]

    cmp bl, '0'
    jl number_loop_end 

    cmp bl, '9'
    jg number_loop_end


    mov rcx, [rsp+24]
    mov rax, [rsp+16]
    mov byte [rax+rcx], bl 

    inc rcx
    mov [rsp+24], rcx 

 
    mov rdi, [rsp+0]
    ;increment pos
    mov rax, [rdi+Lexer.pos]
    inc rax
    mov [rdi+Lexer.pos], rax



    jmp number_loop


number_loop_end:
 

    mov  rdi, NUMBER
    mov  rsi, [rsp+16]
    call _init_Token
    mov [rsp+8], rax

 

    jmp  _fi


_else3:
;case ' '
 
    cmp bl, ' '
    jne _else4
 
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

  
    mov rax, [rsp+16]
    mov byte [rax], bl 
 

    mov  rdi, PLUS
    mov  rsi, rax
    call _init_Token
    mov [rsp+8], rax


    jmp  _fi

_else5:
    cmp bl, '-'
    jne _else6

  
    mov rax, [rsp+16]
    mov byte [rax], bl 

    mov  rdi, MINUS
    mov  rsi, rax
    call _init_Token
    mov [rsp+8], rax

    jmp  _fi

_else6:


_fi:

 
    mov rdi, [rsp+0]
   
    mov rax, [rdi+Lexer.pos]
    inc rax
    mov [rdi+Lexer.pos], rax

    mov rcx, [rsp+40]
    cmp rcx, 1

    jne return

    mov rdi, [rsp+32]
    mov rsi, [rsp+0]
    mov [rsi+Lexer.pos], rdi


return:



    ;return token
    mov rax, [rsp+8]

    leave
    ret



