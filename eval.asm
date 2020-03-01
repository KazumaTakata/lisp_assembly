
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
    jne _eval_Terminal1

    mov rdi, [rcx+operand_Node.expr]
    call _eval_Expr
    
    mov [rsp+16], rax
    
    jmp _eval_operand2
    

_eval_Terminal1:

    mov rax ,[rcx+operand_Node.terminal]
    mov [rsp+16], rax

_eval_operand2:

    mov rdi, [rsp+0]
    mov rcx, [rdi+expr_Node.operand2] 
    mov rsi, [rcx+operand_Node.type]
    
    cmp rsi, EXPR_NODE
    jne _eval_Terminal2

    mov rdi, [rcx+operand_Node.expr]
    call _eval_Expr
    
    mov [rsp+24], rax

    jmp _eval_binary
    

_eval_Terminal2:

    mov rax ,[rcx+operand_Node.terminal]
    mov [rsp+24], rax

_eval_binary:

    mov rdi, [rsp+0]
    mov rcx, [rdi+expr_Node.op] 

    cmp rcx, PLUS

    jne _eval_SUB

    mov rax,[rsp+16]
    mov rcx,[rsp+24]

    add rax, rcx

    jmp _eval_RETURN

_eval_SUB:

 
    mov rax,[rsp+16]
    mov rcx,[rsp+24]

    sub rax, rcx

  

_eval_RETURN:

    leave
    ret



_eval_error:

    mov rdi, [error_format]
    call _printf
    
    leave
    ret
