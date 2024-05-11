.MODEL TINY

SCREEN_WIDTH = 320
SCREEN_HEIGHT = 200
COLOR_WHITE = 15
COLOR_RED = 4
COLOR_LIGHT_RED = 12

.DATA
.CODE
entry_point:

enter_vga:
    mov ax, 13h  
    int 10h

    mov ax, 0a000h
    mov es, ax

frame_init:
    mov al, COLOR_WHITE
    mov cx, SCREEN_WIDTH * SCREEN_HEIGHT
    xor di, di
    rep stosb

    mov di, SCREEN_WIDTH * 25
    mov cx, SCREEN_WIDTH * 12
    mov al, COLOR_RED
    rep stosb

frame_loop:
    xor dl, dl
frame_update:

    call pseudo_random

    mov di, ax
    mov al, es:[di]
    cmp al, COLOR_RED
    jne dry_up_blood

    call pseudo_random
    mov cl, al
    and cl, 15
drip:
    stosb
    add di, SCREEN_WIDTH-1
    jc drip_exit
    loop drip
drip_exit:
    jmp drip_done

dry_up_blood:
    mov al, COLOR_WHITE
    mov es:[di-320], al
    mov es:[di-1], al
    mov es:[di+1], al
    mov es:[di+320], al

drip_done:

    dec dl
    jnz frame_update


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

pseudo_random:
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

END entry_point
