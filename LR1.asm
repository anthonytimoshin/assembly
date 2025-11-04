ORG 100h

START:
    MOV AX, 13
    ADD AX, [C]        ; AX = 13 + c
    
    MOV BX, AX        
    MOV AX, [A]        ; AX = a
    CWD                 
    IDIV BX            ; DX:AX/BX
    MOV AX, DX         ; AX = (a mod (13+c))
    
    MOV BX, 2
    IMUL BX            ; AX = 2*(a mod (13+c))
    MOV CX, AX         
    
    MOV AX, [B]        ; AX = b
    MOV BX, [D]        ; BX = d
    IMUL BX            ; AX = b*d
    
    SUB CX, AX         ; CX = CX - AX
    MOV [REZ], CX      
    
    MOV AX, [REZ]  

PRINT_NUMBER:
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    TEST AX, AX        ; IF AX < 0 THEN SF=1
    JNS POSITIVE       ; IF SF = 0 (AX >= 0) THEN GOTO POSITIVE

    PUSH AX
    MOV DL, '-'
    MOV AH, 02h        ; DOS function to print symbol
    INT 21h
    POP AX
    NEG AX         
    
POSITIVE:
    MOV CX, 0          ; counter of symbols in the number
    MOV BX, 10         ; divisor for conversion to the 10-base
    
CONVERT_LOOP:
    MOV DX, 0          ; clear DX
    DIV BX             ; DX:AX: remainder -> DX; result -> AX
    PUSH DX            ; save symbol in stack
    INC CX
    CMP AX, 0          ; WHILE AX!=0 DO PUSH_DIGITS
    JNZ CONVERT_LOOP
    
PRINT_LOOP:
    POP DX
    ADD DL, '0'        ; making ASCII-symbol
    MOV AH, 02h
    INT 21h
    LOOP PRINT_LOOP    ; WHILE CX>0 DO CX-1
    
    POP DX             ; restore pushed registers
    POP CX             
    POP BX
    POP AX
    RET
    

A DW 43
B DW -6
C DW 10
D DW -17
REZ DW ?

END START
