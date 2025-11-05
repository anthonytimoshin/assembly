ORG 100h

START: 
    MOV SI, [CEIL]
    MOV BX, [FLOOR] ; BX = base (floor) value of X 

COMPARATOR:  
    CMP BX, SI
    JG END_PROGRAM 
    
    CMP BX, 0h  
    JS Y1           ; BX < 0 
    JE Y2           ; BX = 0
Y3:                 ; BX > 0
    MOV AX, BX
    IMUL AX         ; X^2
    MOV CX, [A]
    SUB CX, [B]     ; A-B
    CWD             ; AX -> DX:AX
    IDIV CX         ; (X^2)/(A-B) 
    JMP INCREASE       
Y1:
    MOV AX, [D]
    IMUL AX         ; D^2
    ADD AX, BX      ; D^2+X
    MOV CX, [B]     
    IMUL CX         ; (D^2+X)*B 
    JMP INCREASE
Y2:
    MOV AX, [C]      
    ADD AX, [B]     ; C+B
    CWD             ; AX -> DX:AX
    MOV CX, [D]     
    IDIV CX         ; (C+B)/D

INCREASE:
    CALL PRINT
    
    INC BX
    JMP COMPARATOR

PRINT PROC
    PUSH AX
    PUSH BX
    
    MOV [temp_Y], AX
    
    ;print "x: "
    MOV DX, offset msg_x
    MOV AH, 09h
    INT 21h
    
    ;print x
    MOV AX, BX
    CALL PRINT_NUMBER
    
    ;print " y: "
    MOV DX, offset msg_y
    MOV AH, 09h
    INT 21h
    
    ;print y
    MOV AX, [temp_Y]
    CALL PRINT_NUMBER
    
    ;print newline
    MOV DX, offset newline
    MOV AH, 09h
    INT 21h
    
    POP BX
    POP AX
    RET
PRINT ENDP

PRINT_NUMBER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
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
    XOR DX, DX      ; clear senior ranks of DX
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
    
    POP DX
    POP CX          ; restore pushed registers
    POP BX
    POP AX
    RET
PRINT_NUMBER ENDP

A DW 1
B DW -3
C DW 12
D DW 4 
FLOOR DW -3
CEIL DW 4

temp_Y DW ?
msg_x DB 'x: $'
msg_y DB ' y: $'
newline DB 13,10,'$'

END_PROGRAM:
    MOV AH, 4Ch
    INT 21h

END START
