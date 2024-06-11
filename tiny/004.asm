.MODEL SMALL
.STACK 100h
.DATA
    screen_width EQU 80
    screen_height EQU 25
    palette DB ' .:-=+*%@#'

.CODE
main:
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Set video mode to 80x25 text mode
    MOV AX, 03h
    INT 10h

    ; Set video memory segment
    MOV AX, 0B800h
    MOV ES, AX

    ; Render plasma effect
    MOV CX, screen_height
    XOR DI, DI

render_rows:
    PUSH CX
    MOV CX, screen_width
    MOV DX, screen_height
    SUB DX, CX  ; Store current row

render_columns:
    PUSH CX
    MOV BX, screen_width
    SUB BX, CX  ; Store current column

    ; Plasma calculation
    ; Use combination of sine and cosine functions for effect
    MOV AX, DX
    MOV SI, AX
    ; Multiply SI by 10
    MOV AX, SI
    SHL AX, 1
    ADD SI, AX  ; SI = SI * 3
    MOV AX, SI
    SHL AX, 1
    ADD SI, AX  ; SI = SI * 5
    MOV AX, SI
    SHL AX, 1
    ADD SI, AX  ; SI = SI * 10

    ADD SI, BX
    MOV BX, SI
    MOV AX, BX
    ADD AX, SI
    MOV BX, 16 ; divide by 16 instead of SHR AX, 4
    DIV BX

    ; Cycle through palette based on intensity
    XOR BX, BX
    MOV BL, AL
    AND BX, 7  ; Mask to ensure the value is within the palette range

    ; Get the character from the palette
    MOV AL, palette[BX]

    ; Write character to video memory
    MOV ES:[DI], AL
    INC DI
    INC DI
    POP CX
    LOOP render_columns

    POP CX
    ADD DI, 160 - (2 * screen_width) ; Move to the next line in video memory
    LOOP render_rows

    ; Wait for key press
    MOV AH, 00h
    INT 16h

    ; Return to DOS
    MOV AX, 4C00h
    INT 21h

END main
