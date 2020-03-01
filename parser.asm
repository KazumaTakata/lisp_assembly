
    extern _atoi


%include "parse_operand.asm"
%include "parse_op.asm"



    section .data


    struc expr_Node
.op       resq 1
.operand1 resq 1
.operand2 resq 1
    endstruc



    section .text

error_format: db "parser error %c", 10, 0
sample: db "sample message", 10, 0
string_message: db "string is %s", 10, 0
int_message: db "int value is %d", 10, 0


_parse_Expr:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16 


    mov [rsp+0], rdi
    
    mov rdi, expr_Node_size
    call _malloc
    mov [rsp+8], rax

    ;eat (
    mov rdi, [rsp+0]
    call get_Token
    mov rdi, rax
    mov rax, qword [rdi+Token.type]
    cmp rax, LPAREN 
    jne _parse_Error
   
    ;parse operator
    mov rdi, [rsp+0]
    call _parse_Operator
    mov rcx,  [rsp+8]
    mov qword [rcx+expr_Node.op], rax
    
    ;parse operand1
    mov rdi, [rsp+0]
    call _parse_Operand
    mov rcx, [rsp+8]
    mov qword [rcx+expr_Node.operand1], rax

    ;parse operand2
    mov rdi, [rsp+0]
    call _parse_Operand
    mov rcx, [rsp+8]
    mov qword [rcx+expr_Node.operand2], rax


    ;eat )
    mov rdi, [rsp+0]
    call get_Token
    mov rdi, rax
    mov rax, qword [rdi+Token.type]
    cmp rax, RPAREN 
    jne _parse_Error


    ;return expr_Node
    mov rax, [rsp+8]

    leave
    ret

_parse_Error:



    lea  rdi, [error_format]
    xor  rax, rax
    call  _printf


    leave
    ret



