
    extern _atoi


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


    ;get token
    mov rdi, [rsp+0]
    call get_Token


    mov rdi, rax
    mov rax, qword [rdi+Token.type]
    ;assert number
    cmp rax, NUMBER 
    jne _parse_Error


    mov rax, qword [rdi+Token.value]
    mov rdi, rax
    call _atoi    
 
    mov rcx, [rsp+8]
    mov qword [rcx+expr_Node.operand1], rax
    
 

    mov rsi, qword [rcx+expr_Node.operand1]
    lea rdi, [int_message] 
    call _printf


    

    ;get token
    mov rdi, [rsp+0]
    call get_Token


    mov rdi, rax
    mov rax, qword [rdi+Token.type]
    ;assert number
    cmp rax, NUMBER 
    jne _parse_Error


    mov rax, qword [rdi+Token.value]
    mov rdi, rax
    call _atoi    
 
    mov rcx, [rsp+8]
    mov qword [rcx+expr_Node.operand2], rax


    mov rsi, qword [rcx+expr_Node.operand2]
    lea rdi, [int_message] 
    call _printf


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



