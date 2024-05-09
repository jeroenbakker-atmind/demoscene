.MODEL TINY

.DATA

.CODE
entry_point:
enter_vga:
    mov ax, 13h  
    int 10h

    mov ax, 0a000h
    mov es, ax


    xor bl, bl
frame_loop:
    mov dl, 200/10
    mov al, bl
    add al, 80
    mov di, 0h

frame_row_group:
    mov cx, 320*10
    rep stosb
    inc al
    cmp al, 80+24
    jne no_reset_al
    mov al, 80
no_reset_al:
    dec dl
    jnz frame_row_group

    inc bl
    cmp bl, 24
    jne no_reset
    xor bl, bl
no_reset:


wait_vertical_sync:
    mov dx,03DAh
wait_vertical_sync_start:
    in al,dx
    test al,8
    jz wait_vertical_sync_start


wait_for_key:
    mov ah, 1
    int 16h
    jz frame_loop

exit_to_txt:
    mov ax, 3h  
    int 10h

exit:

    mov ax, 4C00h
    int 21h

END entry_point