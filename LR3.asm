ORG 100h

START:
    ;(d AND NOT(a)) OR (NOT(b) AND c)
    
    MOV AX, [d]
    MOV BX, [a]
    NOT BX          ; BX = NOT(a)
    AND AX, BX      ; AX = d AND NOT(a)
 
    MOV BX, [b]
    NOT BX          ; BX = NOT(b)
    AND BX, [c]     ; BX = NOT(b) AND c
    
    OR AX, BX       ; AX = (d AND NOT(a)) OR (NOT(b) AND c)
    
    MOV [REZ], AX

PRINT_NUMBER:       ; standard output algorihtm
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    TEST AX, AX
    JNS POSITIVE
    
    PUSH AX
    MOV DL, '-'
    MOV AH, 02h
    INT 21h
    POP AX
    NEG AX
                    
POSITIVE:           
    MOV CX, 0
    MOV BX, 10
    
CONVERT_LOOP:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNZ CONVERT_LOOP
    
PRINT_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP PRINT_LOOP
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET   
    
a DW 43
b DW -6  
c DW 10
d DW -17
REZ DW ?

END START
