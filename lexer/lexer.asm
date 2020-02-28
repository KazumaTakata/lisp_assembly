
    section .text

format: db "%c", 10, 0
lparen: db " <LPAREN> ", 0
rparen: db " <RPAREN> ", 0
number: db " <NUMBER> ", 0
space: db " <SPACE> ", 0
plus: db " <PLUS> ", 0





;rdi *string_data
;rsi pos

get_Token:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16

    xor rbx, rbx
    mov bl, byte [rdi+rsi]

;switch 
;case '(':
    cmp bl, '('
    jne _else1

 
    lea  rdi, [lparen]
    xor  rax, rax
    call  _printf
    jmp  _fi

_else1:
;case ')'    
 
    cmp bl, ')'
    jne _else2

 
    lea  rdi, [rparen]
    xor  rax, rax
    call  _printf
    jmp  _fi


_else2:
;case '[0-9]' 
    cmp bl, '0'
    jl _else3

    cmp bl, '9'
    jg _else3


 
    lea  rdi, [number]
    xor  rax, rax
    call  _printf
    jmp  _fi


_else3:
;case ' '
 
    cmp bl, ' '
    jne _else4
    ;lea  rdi, [space]
    ;xor  rax, rax
    ;call  _printf
    jmp  _fi


_else4:
;case '+'
 
    cmp bl, '+'
    jne _else5

 
    lea  rdi, [plus]
    xor  rax, rax
    call  _printf
    jmp  _fi

_else5:


_fi:

    leave
    ret




