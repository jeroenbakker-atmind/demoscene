.MODEL TINY

PALETTE_LEN = 24
PALETTE_OFFSET = 80
SCREEN_WIDTH = 320
SCREEN_HEIGHT = 200
BAR_HEIGHT = 10

.DATA

.CODE
entry_point:
enter_vga:
    mov ax, 13h  
    int 10h

    mov ax, 0a000h
    mov es, ax

frame_init:
    xor bl, bl
    
frame_loop:
    mov dl, SCREEN_HEIGHT/BAR_HEIGHT
    mov bh, bl
    xor di, di

frame_row_group:
    mov al, bh
    add al, PALETTE_OFFSET
    mov cx, SCREEN_WIDTH*BAR_HEIGHT
    rep stosb
    dec bh
    jnc no_reset_al
    mov bh, PALETTE_LEN - 1

no_reset_al:
    dec dl
    jnz frame_row_group

    inc bl
    cmp bl, PALETTE_LEN - 1
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
    ret
ENDIF

END entry_point