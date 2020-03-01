


    section .text

;rdi *Lexer
_parse_Operator:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16 

    ;get token
    call get_Token
 
    mov rdi, rax
    mov rax, qword [rdi+Token.type]
    
    cmp rax, PLUS 
    jne _minus_op

    mov rax, PLUS
    
    jmp _op_fi

_minus_op:

    cmp rax, MINUS
    jne _mul_op

    mov rax, MINUS
    
    jmp _op_fi

   

_mul_op:

    cmp rax, MULTI
    jne _parse_Error 

    mov rax, MULTI

    jmp _op_fi


_op_fi:



    leave
    ret

