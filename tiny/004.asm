.MODEL small
.STACK 100h

.DATA
x1 DW 50
y1 DW 50
x2 DW 100
y2 DW 150
x3 DW 150
y3 DW 80

.CODE
main PROC
    MOV AX, @data
    MOV DS, AX

    MOV AX, 0013h
    INT 10h

    MOV AX, 0A000h
    MOV ES, AX

    CALL sort_vertices

    MOV AX, y2
    SUB AX, y1
    MOV DX, AX         ; dy1 = y2 - y1
    MOV AX, y3
    SUB AX, y1
    MOV BX, AX         ; dy2 = y3 - y1

    MOV AX, x2
    SUB AX, x1
    IMUL AX, DX
    IDIV BX
    ADD AX, x1
    MOV CX, AX         ; xLeft

    MOV AX, x3
    SUB AX, x1
    IDIV BX
    MOV DI, AX         ; dxRight = (x3 - x1) / (y3 - y1)

    MOV AX, y1
    MOV BX, y2

fill_bottom_part:
    CMP AX, BX
    JGE fill_top_part
    CALL draw_horizontal_line
    INC AX
    ADD CX, SI
    JMP fill_bottom_part

fill_top_part:
    MOV BX, y3

fill_top_loop:
    CMP AX, BX
    JG end_fill
    CALL draw_horizontal_line
    INC AX
    ADD CX, SI
    JMP fill_top_loop

end_fill:
    MOV AX, 0003h
    INT 10h

    MOV AX, 4C00h
    INT 21h
main ENDP

sort_vertices PROC
    MOV AX, y1
    CMP AX, y2
    JLE no_swap_12
    XCHG y1, y2
    XCHG x1, x2
no_swap_12:
    MOV AX, y1
    CMP AX, y3
    JLE no_swap_13
    XCHG y1, y3
    XCHG x1, x3
no_swap_13:
    MOV AX, y2
    CMP AX, y3
    JLE no_swap_23
    XCHG y2, y3
    XCHG x2, x3
no_swap_23:
    RET
sort_vertices ENDP

draw_horizontal_line PROC
    MOV DI, 320
    MUL AX
    ADD AX, CX
    MOV DI, AX
    MOV AL, 15

draw_pixel_loop:
    CMP CX, DI
    JG end_line
    MOV [ES:CX], AL
    INC CX
    JMP draw_pixel_loop

end_line:
    RET
draw_horizontal_line ENDP

END main
