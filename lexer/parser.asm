

    section .data


    struc expr_Node
.op       resq 1
.operand1 resb 1
.operand2 resb 1
    endstruc



    section .text

error_format: db "parser error %c", 10, 0
sample: db "sample message"
_parse_Expr:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16 


    mov [rsp+0], rdi
    
    mov rdi, expr_Node_size
    call _malloc
    mov [rsp+8], rax




    ;get token
    mov rdi, [rsp+0]
    call get_Token

    mov rdi, rax

    mov rax, qword [rdi+Token.type]

    ;eat ( 
    cmp rax, LPAREN 
    jne _parse_Error
    
 
    ;get token
    mov rdi, [rsp+0]
    call get_Token

 
    mov rdi, rax
    mov rax, qword [rdi+Token.type]
    
    cmp rax, PLUS 
    jne _minus_op

    mov rax, [rsp+8]
    mov qword [rax+expr_Node.op], PLUS
    
    jmp _op_fi

_minus_op:
 


    cmp rax, MINUS
    jne _mul_op

    mov rax, [rsp+8]
    mov qword [rax+expr_Node.op], MINUS
    
    
    jmp _op_fi



_mul_op:
 
    cmp rax, MULTI
    jne _parse_Error 

    mov rax, [rsp+8]
    mov qword [rax+expr_Node.op], MULTI
    
    jmp _op_fi


_op_fi:
    ;return expr_Node





    mov rax, [rsp+8]

    leave
    ret

_parse_Error:



    lea  rdi, [error_format]

    mov  rcx, [rsp+0]

    mov  sil, [rcx+Token.value]
    xor  rax, rax
    call  _printf


    leave
    ret



