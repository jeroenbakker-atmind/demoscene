.MODEL small
.STACK 100h

.DATA
maxColor  DB 63         ; Max color intensity (using VGA palette range)
centerX   DW 160        ; Center X coordinate of the cube
centerY   DW 100        ; Center Y coordinate of the cube
halfSize  DW 50         ; Half of the cube side length (halfSize)
lightX    DW 577        ; Light direction X component (1/sqrt(3) * 1024)
lightY    DW -577       ; Light direction Y component (-1/sqrt(3) * 1024)
lightZ    DW -577       ; Light direction Z component (-1/sqrt(3) * 1024)

.CODE
main PROC
    ; Initialize DS
    MOV AX, @data
    MOV DS, AX

    ; Set video mode to 13h (320x200, 256 colors)
    MOV AX, 0013h
    INT 10h

    ; Set ES to 0A000h for VGA video memory
    MOV AX, 0A000h
    MOV ES, AX

    ; Draw the cube using SDF with lighting
    MOV CX, 320         ; Screen width
    MOV DX, 200         ; Screen height
    XOR BX, BX          ; Reset BX (y coordinate)

draw_loop_y:
    XOR SI, SI          ; Reset SI (x coordinate)
draw_loop_x:
    ; Calculate distance from the point (SI, BX) to the cube surface
    ; d = max(abs(x - centerX) - halfSize, abs(y - centerY) - halfSize)
    MOV AX, SI          ; AX = x
    SUB AX, centerX     ; AX = x - centerX
    CALL abs_val_bitwise
    SUB AX, halfSize    ; AX = abs(x - centerX) - halfSize
    MOV DI, AX          ; DI = abs(x - centerX) - halfSize

    MOV AX, BX          ; AX = y
    SUB AX, centerY     ; AX = y - centerY
    CALL abs_val_bitwise
    SUB AX, halfSize    ; AX = abs(y - centerY) - halfSize

    ; DI = max(DI, AX)
    CMP DI, AX
    JGE skip_max
    MOV DI, AX
skip_max:

    ; If DI <= 0, the point is inside or on the cube
    CMP DI, 0
    JG skip_pixel

    ; Determine the normal direction based on which face is closest
    MOV AX, SI          ; AX = x
    SUB AX, centerX     ; AX = x - centerX
    CALL abs_val_bitwise
    CMP AX, halfSize
    JG face_y
    MOV AX, BX          ; AX = y
    SUB AX, centerY     ; AX = y - centerY
    CALL abs_val_bitwise
    CMP AX, halfSize
    JG face_x

    ; Face normal is along Z-axis
    MOV AX, lightZ
    JMP calc_intensity

face_x:
    ; Face normal is along X-axis
    MOV AX, lightX
    JMP calc_intensity

face_y:
    ; Face normal is along Y-axis
    MOV AX, lightY

calc_intensity:
    ; Calculate intensity based on dot product L . N
    ; Normalize intensity to range [0, 63]
    IMUL AX, 1024       ; AX = Lx * Nx * 1024
    MOV CX, 10
    SAR AX, CL          ; Divide by 1024 (right shift by 10 bits)
    CMP AX, 0
    JG intensity_positive
    XOR AX, AX          ; AX = 0
intensity_positive:
    CMP AX, maxColor
    JLE skip_max_color
    MOV AX, maxColor    ; Cap the intensity at maxColor
skip_max_color:

    ; Plot the pixel (SI, BX) with calculated intensity
    MOV DI, AX          ; DI = intensity
    MOV AX, 320         ; 320 bytes per scanline
    MUL BX              ; AX = 320 * y
    ADD AX, SI          ; AX = 320 * y + x
    MOV DI, AX          ; DI = offset
    MOV AL, BL
    MOV ES:[DI], AL     ; Write intensity to video memory

skip_pixel:
    INC SI              ; Increment x coordinate
    CMP SI, CX
    JL draw_loop_x

    INC BX              ; Increment y coordinate
    CMP BX, DX
    JL draw_loop_y

    ; Wait for a key press
    MOV AH, 00h
    INT 16h

    ; Set video mode to 03h (text mode 80x25, 16 colors)
    MOV AX, 0003h
    INT 10h

    ; Terminate the program
    MOV AX, 4C00h
    INT 21h
main ENDP

; Function to calculate absolute value using bitwise operations
abs_val_bitwise PROC
    MOV DX, AX
    SAR DX, 15          ; Get the sign bit (0 for positive, -1 for negative)
    XOR AX, DX
    SUB AX, DX          ; Perform XOR and subtraction to get the absolute value
    RET
abs_val_bitwise ENDP

END main