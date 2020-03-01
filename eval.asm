
    section .text

eval_message: db "value is %d",10,0


_eval_Expr:

    push rbp
    mov  rbp, rsp
    sub  rsp, 32


    mov [rsp+0], rdi

    mov rdi, [rsp+0]
    mov rcx, [rdi+expr_Node.operand1] 
    mov rsi, [rcx+operand_Node.type]
    
    cmp rsi, EXPR_NODE
    jne _eval_Term    

    mov rdi, [rcx+operand_Node.expr]
    call _eval_Expr
    
    mov [rsp+16], rax
    

_eval_Term:

    mov rax ,[rcx+operand_Node.terminal]
    mov rdx, [rdi+expr_Node.operand2]
    mov rcx ,[rdx+operand_Node.terminal]
 
    add rcx, rax

    
    lea rdi, [eval_message]
    mov rsi, rcx
    call _printf


    jmp _else_eval_fi

_else_eval_fi:


    leave
    ret



_eval_error:

    mov rdi, [error_format]
    call _printf
    
    leave
    ret
