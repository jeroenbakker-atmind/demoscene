.MODEL SMALL
.STACK 100h
.DATA
    screen_width EQU 80
    screen_height EQU 25
    shading_chars DB ' .:-=+*%@#'
    sphere_center_x DW 40
    sphere_center_y DW 12
    sphere_center_z DW 0
    sphere_radius DW 10
    light_x DW 20
    light_y DW 20
    light_z DW 0

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

    ; Render sphere
    MOV CX, screen_height
    XOR DI, DI

render_rows:
    PUSH CX
    MOV CX, screen_width

render_columns:
    PUSH CX
    MOV AX, screen_height
    SUB AX, screen_height
    MOV BX, screen_width
    SUB BX, screen_width
    MOV DX, BX

    ; Convert screen coordinates to world coordinates
    ; Simplify to linear transformation for demonstration
    MOV AX, screen_height
    SUB AX, CX
    MOV BX, 2
    MUL BX
    MOV SI, AX

    MOV AX, screen_width
    SUB AX, screen_width
    MOV BX, 2
    MUL BX
    MOV BX, AX

    ; Calculate SDF to the sphere
    MOV AX, SI
    SUB AX, sphere_center_x
    IMUL AX
    MOV SI, AX

    MOV AX, BX
    SUB AX, sphere_center_y
    IMUL AX
    ADD SI, AX

    MOV AX, sphere_center_z
    IMUL AX
    ADD SI, AX

    ; Here SI contains the distance squared

    ; Compare distance to sphere radius
    MOV AX, sphere_radius
    IMUL AX
    CMP SI, AX
    JL inside_sphere

    ; Outside the sphere
    MOV AL, ' '
    JMP render_char

inside_sphere:
    ; Calculate lighting
    ; Simplified to a constant value for demonstration
    MOV AL, '#'

render_char:
    ; Write character to video memory
    MOV ES:[DI], AL
    INC DI
    INC DI
    POP CX
    LOOP render_columns

    POP CX
    LOOP render_rows

    ; Wait for key press
    MOV AH, 00h
    INT 16h

    ; Return to DOS
    MOV AX, 4C00h
    INT 21h

END main
