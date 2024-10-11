segment .data
    prompt_msg: db "Enter a signed integer number (up to 4 digits): ", 0
    prompt_len: equ $ - prompt_msg
    value_msg: db "The entered number is ", 0
    value_len: equ $ - value_msg
    half_msg: db "Half of the number entered is ", 0
    half_len: equ $ - half_msg
    ; double_msg: db "Double of the entered number is ", 0
    ; double_len: equ $ - double_msg

segment .bss
    input_val: resb 6
    half_val: resb 6
    ; double_val: resb 7

section .text
    global _start

_start:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, prompt_msg
    mov     edx, prompt_len
    int     0x80

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, input_val
    mov     edx, 6
    int     0x80

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, value_msg
    mov     edx, value_len
    int     0x80

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, input_val
    mov     edx, 6
    int     0x80

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, half_msg
    mov     edx, half_len
    int     0x80

    lea     esi, [input_val]    ; load effective address of stored value

    mov     cl, [input_val]     ; move first character into lower byte of ecx
    cmp     cl, 45              ; compare with '-'
    jne     sign_end            ; if not '-', jump
    inc     esi                 ; else, increment address to next character
sign_end:

    mov     al, byte [esi]      ; load character at current address in lower byte of eax
    sub     eax, 48             ; convert it to integer

    inc     esi                 ; increment address

convert_loop:
    mov     bl, byte [esi]      ; load character at current address in lower byte of ebx
    cmp     ebx, 0xA            ; if we reached the line feed
    je      convert_loop_end    ; exit

    imul    eax, 10             ; multiply sum by 10

    sub     ebx, 48             ; convert loaded character to integer

    add     eax, ebx            ; add integer value of loaded character to sum

    inc     esi                 ; increment memory address
    jmp     convert_loop        ; iterate

convert_loop_end:

    ; mov     ecx, eax

    sar     eax, 1              ; divide sum by 2
    ; sal     ecx, 1

    lea     esi, [half_val]
    ; lea     edi, [double_val]
    add     esi, 5
    ; add     edi, 6
    mov     byte [esi], 0xA
    ; mov     byte [edi], 0xA
    dec     esi
    ; dec     edi
    mov     byte [esi], 48
    ; mov     byte [edi], 48

    mov     ebx, 10
    
half_loop:
    cmp     eax, 0
    ; je      transition
    je      half_loop_end
    
    mov     edx, 0
    idiv    ebx

    add     edx, 48
    mov     byte [esi], dl

    dec     esi

    jmp half_loop

; transition:
;     mov     eax, ecx

; double_loop:
;     cmp     eax, 0
;     je      half_loop_end

;     mov     edx, 0
;     idiv    ebx

;     add     edx, 48
;     mov     byte [edi], dl

;     dec     edi

;     jmp     double_loop

half_loop_end:

    mov     eax, [input_val]
    cmp     byte [input_val], 45
    jne     sign_1
    mov     byte [esi], 45
    ; mov     byte [edi], 45

sign_1:

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, half_val
    mov     edx, 6
    int     0x80

    ; mov     eax, 4
    ; mov     ebx, 1
    ; mov     ecx, double_msg
    ; mov     edx, double_len
    ; int     0x80

    ; mov     eax, 4
    ; mov     ebx, 1
    ; mov     ecx, double_val
    ; mov     edx, 7
    ; int     0x80

exit:
    mov     eax, 1
    int     0x80  