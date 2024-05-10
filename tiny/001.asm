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
    mov bh, bl
    mov di, 0h

frame_row_group:
    mov al, bh
    add al, 80
    mov cx, 320*10
    rep stosb
    dec bh
    jnc no_reset_al
    mov bh, 23

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


IFDEF RELEASE
    jmp frame_loop
ELSE
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
ENDIF

END entry_point