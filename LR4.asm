ORG 100h

    MOV DL, 'A'
    MOV AL, 'Z'
    SUB AL, 'A'          ; AL = 25
    INC AL               ; AL = 26
    XOR CX, CX           ; CX = 0 
    MOV CL, AL           ; CX = 26
                             
    MOV AH, 02h          

PRINT:
    INT 21h              
    INC DL               
    LOOP PRINT           ; WHILE (CX > 0) DO CX = CX - 1

    MOV AX, 4C00h
    INT 21h
