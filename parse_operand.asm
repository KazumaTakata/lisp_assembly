
    extern _atoi

    section .data


    struc operand_Node
.type     resq 1
.expr     resq 1
.terminal resq 1
    endstruc



    section .text

EXPR_NODE equ 0
TERMINAL_NODE equ 1


;rdi *Lexer
_parse_Operand:

    push rbp
    mov  rbp, rsp
    sub  rsp, 16 


    mov [rsp+0], rdi
    
    mov rdi, operand_Node_size
    call _malloc
    mov [rsp+8], rax

    ;check if expr
    mov rdi, [rsp+0]
    mov rsi, 1
    call get_Token
    mov rdi, rax
    mov rax, qword [rdi+Token.type]
    cmp rax, LPAREN 
    jne _parse_Terminal


    mov rdi, [rsp+0]
    call _parse_Expr

    ;move operand_node
    mov rcx, [rsp+8]
    mov qword [rcx+operand_Node.expr], rax
    mov qword [rcx+operand_Node.type], EXPR_NODE
        

    jmp _parse_Operand_end


_parse_Terminal:


    mov rdi, [rsp+0]
    mov rsi, 0
    call get_Token
    mov rdi, rax
  

    mov rax, qword [rdi+Token.value]
    mov rdi, rax
    call _atoi    
 
    
    mov rcx, [rsp+8]
    mov qword [rcx+operand_Node.terminal], rax
    mov qword [rcx+operand_Node.type], TERMINAL_NODE 
        
   

    mov rsi, qword [rcx+operand_Node.terminal]
    lea rdi, [int_message] 
    call _printf



_parse_Operand_end:

    ;return expr_Node
    mov rax, [rsp+8]

    leave
    ret

