ORG 100h

START:   
                                    ; display input program
    MOV AH, 09h
    MOV DX, offset msg_input
    INT 21h
                                    ; read string from keyboard
    MOV AH, 0Ah
    MOV DX, offset input_buffer
    MOV byte ptr [input_buffer], 99 ; set maximum input length = 99
    INT 21h
    
    MOV SI, offset input_buffer + 1 ; SI points to length byte  
    MOV CL, [SI]                    ; CL = actual string length  
    MOV CH, 0                       ; clear CH to use CX as counter
    INC SI                          ; SI points to the first symbol of string   
    ADD SI, CX                      ; move to the end of the string  
    MOV byte ptr [SI], '$'          ; add string terminator '$'  
    
    CALL compress_spaces
    

    MOV AH, 09h                     ; display original string message
    MOV DX, offset msg_original
    INT 21h
    
    MOV AH, 09h                     ; display original string
    MOV DX, offset input_buffer + 2 ; skip 2 bytes (max and actual length)  
    INT 21h
    
    
    MOV AH, 09h                     ; display compressed string message
    MOV DX, offset msg_compressed
    INT 21h
                                    
    MOV AH, 09h                     ; display compressed string
    MOV DX, offset compressed_buffer
    INT 21h
    
 
    MOV AH, 4Ch                     ; exit program
    MOV AL, 0
    INT 21h


compress_spaces PROC                ; procedure to compress repeated spaces
    PUSH SI
    PUSH DI
    PUSH AX
    PUSH BX
    PUSH CX
    
    MOV SI, offset input_buffer + 2 ; SI - source pointer to original string 
    MOV DI, offset compressed_buffer; DI - destination pointer for compressed string  
    

    MOV BL, [input_buffer + 1]      ; BL = string length  
    MOV BH, 0                       ; clear BH to use BX as counter
    MOV CX, 0                       ; CX = processed characters counter  
    
compress_loop:
    CMP CX, BX                      ; compare counter with string length  
    JGE compress_done               ; if all characters processed - exit loop
    
    MOV AL, [SI]                    ; AL = current character  
    
    
    CMP AL, ' '
    JNE not_space
    
    
    CMP DI, offset compressed_buffer ; compare pointer with buffer start 
    JE store_space                   ; if 1st char -> store the space
    
    MOV AH, [DI-1]                   ; check if previos char = ' ' 
    CMP AH, ' '                       
    JE skip_space                     
    
store_space:
    MOV [DI], AL                    ; write char to buffer  
    INC DI                          ; move to the next position in buffer
    JMP next_char                  

not_space:
    MOV [DI], AL                      
    INC DI

skip_space:                         ; do nothing
    

next_char:
    INC SI                          ; increment source string pointer  
    INC CX                          ; increment proccesed chars counter 
    JMP compress_loop

compress_done:
    MOV byte ptr [DI], '$'          ; finish processing - add string terminator  
    
    POP CX
    POP BX
    POP AX
    POP DI
    POP SI
    RET
compress_spaces ENDP 

msg_original db 0Dh, 0Ah, 'Original string: $'
msg_compressed db 0Dh, 0Ah, 'Compressed string: $'
msg_input db 'Enter string: $'
    
input_buffer db 100 dup('$')
compressed_buffer db 100 dup('$')

END START
