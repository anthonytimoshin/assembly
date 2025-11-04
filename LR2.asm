ORG 100h

START: 
    MOV SI, [CEIL]
    MOV BX, [FLOOR] ; BX = base (floor) value of X  
   
Y1:
    MOV AX, [D]
    MUL AX          ; D^2
    ADD AX, BX      ; D^2+X
    IMUL [B]        ; (D^2+X)*B
    CALL PRINT  
    CALL INCREASE

Y2:
    MOV AX, [C]      
    ADD AX, [B]     ; C+B
    CWD             ; AX -> DX:AX
    IDIV [D]        ; (C+B)/D
    CALL PRINT 
    CALL INCREASE

Y3:
    MOV AX, BX
    IMUL AX         ; X^2
    MOV CX, [A]
    SUB CX, [B]     ; A-B
    CWD             ; AX -> DX:AX
    IDIV CX         ; (X^2)/(A-B) 
    CALL PRINT 
    CALL INCREASE   

INCREASE:
    INC BX
    
COMPARATOR:  
    CMP BX, SI
    JG END_PROGRAM 
    
    CMP BX, 0h  
    JS Y1           ; BX < 0 
    JE Y2           ; BX = 0   
    JG Y3           ; BX > 0 
    
PRINT PROC          ; print procedure
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    
    TEST AX, AX     ; IF AX < 0 THEN SF=1 
    JNS POSITIVE    ; IF SF = 0 (AX >= 0) THEN GOTO POSITIVE
    NEG AX          
    PUSH AX         ; temporary push then pop value of AX
    MOV DL, '-'
    MOV AH, 02h     ; DOS function to print symbol
    INT 21h         
    POP AX
    
POSITIVE:
    MOV CX, 0       ; counter of symbols in the number
    MOV BX, 10      ; divisor for conversion to the 10-base

PUSH_DIGITS:
    MOV DX, 0
    DIV BX          ; DX:AX: remainder -> DX; result -> AX
    PUSH DX         ; save symbol in stack
    INC CX
    TEST AX, AX     ; WHILE AX!=0 DO PUSH_DIGITS
    JNZ PUSH_DIGITS 

POP_DIGITS:
    POP DX
    ADD DL, '0'     ; making ASCII-symbol
    MOV AH, 02h
    INT 21h         
    LOOP POP_DIGITS ; WHILE CX>0 DO CX-1
    
    MOV DL, 0Dh     ; newline
    MOV AH, 02h
    INT 21h
    MOV DL, 0Ah
    MOV AH, 02h
    INT 21h
    
    POP SI          ; restore pushed registers
    POP CX
    POP BX
    POP AX
    RET
PRINT ENDP
                                     
END_PROGRAM:
    MOV AH, 4Ch
    INT 21h  
    
A DW 1
B DW -3
C DW 12
D DW 4 

FLOOR DW -3
CEIL DW 4

END START
