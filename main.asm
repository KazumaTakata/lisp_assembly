    global  _main
    extern  _printf
    default  rel


%include "lexer.asm"
%include "parser.asm"
%include "eval.asm"

    section .text


string: db "(- (+ 33 4) 109)", 0
message: db "helloworld",10,0

lexer equ 0



_main:
    push rbp
    mov  rbp, rsp
    sub  rsp, 16 

    mov  al, byte [string]


    lea rdi, [string]
    mov rsi, 0


    call _init_Lexer

    mov  qword [rsp+lexer], rax

_loop:

    mov rdi, qword [rsp+lexer]
    call _parse_Expr

    mov rdi, rax

    call _eval_Expr

    lea rdi, [eval_message]
    mov rsi, rax

    call _printf



    ;mov rdi, qword [rsp+lexer]
    ;call get_Token
    ;mov rdi, rax
    ;call print_Token
 


    ;lea rdi, [format]
    ;mov sil, byte [rax + Token.value] 
    ;xor  rax, rax
    ;call  _printf

    ;mov rax, qword [rsp + lexer]   
    ;mov rcx, qword [rax + Lexer.pos]

    ;cmp rcx, 7 
    ;jne _loop


    xor  rax, rax
    leave
    ret


