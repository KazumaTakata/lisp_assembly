
    section .text

eval_message: db "value is %d",10,0


_eval_Expr:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16 


    mov [rsp+0], rdi

    mov rax, [rdi+expr_Node.op]

    cmp rax, PLUS
    
    jne _else_eval1 


    mov rdi, [rsp+0]
    mov rcx, [rdi+expr_Node.operand1] 
    mov rdx, [rdi+expr_Node.operand2]
    add rcx, rdx

    
    lea rdi, [eval_message]
    mov rsi, rcx
    call _printf


    jmp _else_eval_fi

_else_eval1:
 
    mov [rsp+0], rdi

    mov rax, [rdi+expr_Node.op]

    cmp rax, MINUS
    
    jne _eval_error


    mov rdi, [rsp+0]
    mov rcx, [rdi+expr_Node.operand1] 
    mov rdx, [rdi+expr_Node.operand2]
    sub rcx, rdx

    
    lea rdi, [eval_message]
    mov rsi, rcx
    call _printf


_else_eval_fi:


    leave
    ret



_eval_error:

    mov rdi, [error_format]
    call _printf
    
    leave
    ret
