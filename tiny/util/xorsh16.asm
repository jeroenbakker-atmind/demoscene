xorshift16:
    mov ax, cs:[seed]
    mov bx, ax
    mov cl, 7
    shl bx, cl
    xor ax, bx
    mov bx, ax
    mov cl, 9
    shr bx, cl
    xor ax, bx
    mov bx, ax
    mov cl, 8
    shl bx, cl
    xor ax, bx
    mov cs:[seed], ax
    ret

seed dw 1h
