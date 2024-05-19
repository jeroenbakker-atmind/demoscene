.MODEL small
.STACK 100h

.DATA
colorTable DB 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ; Preinitialized color table for VGA mode 13h
frameCount DW 0         ; Variable to store frame count for animation

.CODE
main PROC
    MOV AX, @data
    MOV DS, AX

    ; Set video mode to 13h (320x200, 256 colors)
    MOV AX, 0013h
    INT 10h

    ; Set ES to 0A000h for VGA video memory
    MOV AX, 0A000h
    MOV ES, AX

    ; Initialize frame count
    MOV frameCount, 0

    ; Generate plasma wave
plasma_loop:
    ; Increment frame count for animation
    INC frameCount

    MOV CX, 320          ; Screen width
    MOV DX, 200          ; Screen height
    MOV DI, 0            ; Destination index for video memory

plasma_inner_loop:
    ; Calculate color index based on plasma function
    CALL plasma_function

    ; Write color index to video memory
    MOV AL, colorTable[SI]
    MOV ES:[DI], AL

    INC DI               ; Move to the next pixel
    DEC CX               ; Decrement inner loop counter
    JNZ plasma_inner_loop

    ;ADD DI, 120          ; Move to the next line (320 - 200)

    ; Delay for animation
    CALL delay

    ; Check for key press to exit
    MOV AH, 01h
    INT 16h
    JNZ exit_program

    LOOP plasma_loop

exit_program:
    ; Set video mode to 03h (text mode 80x25, 16 colors)
    MOV AX, 0003h
    INT 10h

    ; Terminate the program
    MOV AX, 4C00h
    INT 21h
main ENDP

plasma_function PROC
    ; Calculate plasma function value based on current position and frame count
    MOV AX, DI           ; X coordinate
    XOR BX, BX
    MOV CX, 32           ; Plasma frequency
    DIV CX               ; Divide by plasma frequency
    ADD AL, DL           ; Phase shift with frame count
    XOR DX, DX
    MOV DX, frameCount
    ADD AL, DL
    XOR BL, AL           ; Use AL as phase for Y
    MOV CX, 16           ; Plasma amplitude
    DIV CX               ; Divide by plasma amplitude
    XOR AL, BH           ; Use BH as phase for X
    XOR AL, 7            ; Bias to center the plasma around 8

    ; AL now contains the color index for the plasma effect
    RET
plasma_function ENDP

delay PROC
    ; Insert a delay for animation
    MOV CX, 0h
delay_loop:
    DEC CX
    JNZ delay_loop
    RET
delay ENDP

END main
