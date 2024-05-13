.MODEL TINY

SCREEN_WIDTH = 320
SCREEN_HEIGHT = 200
COLOR_WHITE = 15
COLOR_RED = 4
COLOR_LIGHT_RED = 12

DO_DRY_BLOOD = 0

.DATA
seed dw 1h

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
    xor dx, dx
frame_update:

    call xorshift16
    mov di, ax

    xor ax, ax
    mov al, es:[di]

    cmp al, COLOR_RED
    jne dry_up_blood

drop_start:
    call xorshift16
    mov cx, ax
    and cx, 15
    inc cx
    mov al, COLOR_RED
drip:
    mov es:[di], al
    add di, SCREEN_WIDTH
    jc drip_done
    loop drip

dry_up_blood:
    mov al, COLOR_WHITE
    mov es:[di], al
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

include util\xorsh16.asm

END entry_point
