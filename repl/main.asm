    global  _main
    extern  _printf
    extern  _read
    extern  _fflush
    default  rel


    section .text

prompt: db ">>", 0


_main:
    push rbp
    mov  rbp, rsp
    sub  rsp, 16 ;16 bit stack alignment

loop:

    lea   rdi, [prompt]
    call  _printf

    mov   rdi, 0
    call  _fflush


    mov   rdi, 0
    lea   rsi, [buffer]
    mov   rdx, 64

    call  _read


    lea   rdi, [buffer]
    call  _printf

    jmp loop

    leave
    ret


clear_buffer:
    






    section   .bss

buffer:   resb    64   
