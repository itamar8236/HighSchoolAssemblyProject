; multi-segment executable file template.

data segment
    ; add your data here!
    guessnum db ? 
    guess db ?
    welcome db 9,9,"Welcome to Itamar's guessing game!!$"  
    gmode db 10,10,13,9,"One or two players? : $"
    numofges db 10,13,10,"How many guesses do you want? <between 1 to 9>: $"  
    inp db 13,10,10,"Player 2, input the number that player 1 need to guess between 1 to 100: $"  
    gesinv db ". Input your guess:      $" 
    small db 13,10,9,9,9,"Your number is too small!!$"
    big db 13,10,9,9,9,"Your number is too big!!   $"  
    win db 10,9,9,9,9,"Y O W  W I N  !!!       $"
    lose db 10,9,9,9,9,"Y O U  L O S E  !!!        $"
    player1win db 10,9,9,9,9,"PLAYER 1 WIN !!!              $"
    player1lose db 10,9,9,9,"YOU LOSE, PLAYER 2 WIN!        $"
    space db "   |$"
    
    tavla db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10|" 
          db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 11| 12| 13| 14| 15| 16| 17| 18| 19| 20|"
          db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 21| 22| 23| 24| 25| 26| 27| 28| 29| 30|"
          db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 31| 32| 33| 34| 35| 36| 37| 38| 39| 40|"
          db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 41| 42| 43| 44| 45| 46| 47| 48| 49| 50|"
          db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 51| 52| 53| 54| 55| 56| 57| 58| 59| 60|"
          db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 61| 62| 63| 64| 65| 66| 67| 68| 69| 70|"
          db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 71| 72| 73| 74| 75| 76| 77| 78| 79| 80|"
          db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 81| 82| 83| 84| 85| 86| 87| 88| 89| 90|"
          db 13,10,9,9, "-----------------------------------------"
          db 13,10,9,9, "| 91| 92| 93| 94| 95| 96| 97| 98| 99|100|"
          db 13,10,9,9, "-----------------------------------------$" 
    
    pkey db 13,10,"Do you wand to continue (y/any key): $"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here 
    sta: 
    call clear
    mov ah, 9                 ;\
    lea dx, welcome           ; |typing welcome...
    int 21h                   ;/
    
    lea dx, gmode             ;location of gmode -->dx as parameter
    push 1                    ;\1 & 2 are parameters for range that
    push 2                    ;/save in the stack
    call raedAndCheckDigit    ;call the proc pf gmode
    
    xor dh, dh                ;\save the game mode
    push dx                   ;/in the stack
          
    lea dx, numofges        ;location of numofges-->dx as parameter
    push 1                  ;\
    push 9                  ; |1 & 9 are parameters for range that
                            ;/save in the stack
    call raedAndCheckDigit
      
                         
    mov guessnum, dl      ;saving the n guessing in "Atar"-guessnum  
     
    pop dx                ;checking the game mode
    cmp dl, 2
    push dx               ;saving the game mode
    je mod2 
                      ;      =============
    call randomNum    ;      ;One Player!;
                      ;      =============
    mov guess, dl     ;-saving the random number in "Atar"-guess
    jmp continue1
    
    mod2:
    lea dx, inp            ;\
    mov ah, 9              ; |typing invite for player 2
    int 21h                ;/
    
    push 1                 ;parameter - hide
                          
    call ReadAndCheckNum   ;!!player2 can put '0' on start so its
                           ;3 digits
    
    mov guess, bl         ;-saving the input number in "Atar"-guess
   
    continue1: 
    mov cl, guessnum      ; num of guesses-->cx, "Mone" 
    xor ch, ch
     
    call clear
    
    lea dx, tavla
    push dx
    call typetavla
    
gesAgain:
    
    mov dl, guessnum            ;\move into dx num of guesses 
    xor dh, dh                  ;/
    sub dx, cx                  ;sub from dx the current gess left
    inc dx                      ;inc dx by 1 for start in - 1 not 0
    add dl, '0'                 ;\
    push dx                     ; |input parameters in stack,
    lea dx, gesinv              ; |1-num guess 2-loc of inv
    push dx                     ;/
    call inviteGuess
    
    push 0                      ;parameter - show
    call ReadAndCheckNum
    
    push bx
    mov dl, guess
    xor dh, dh 
    push dx
    lea dx, space
    push dx
    
    call upgradeTavla
    
    cmp bl, guess
    je win1
    jg bigger
    
    lea dx, small 
    mov ah, 9
    int 21h
    jmp continue5
    bigger:
    lea dx, big 
    mov ah, 9
    int 21h
    
    continue5: 
              
loop gesAgain 
    
    call clear
    
    pop bx
    cmp bl, 1
    je one1
    lea dx, player1lose
    jmp done2
    one1:
    lea dx, lose
    done2:
    mov ah, 9
    int 21h
    
    jmp d
    
    win1:
    call clear
    pop bx
    cmp bl, 1
    je one2
    lea dx, player1win
    jmp done3
    one2:
    lea dx, win
    done3:
    mov ah, 9
    int 21h
    d:
    lea dx, tavla
    push dx
    call typetavla
    
    mov al, guess
    xor ah, ah
    mov bx, ax
    dec ax
    push ax
    push bx
    lea dx, space
    push dx
    call upgradetavla 
    add ax, 2
    push ax
    push bx
    push dx
    call upgradetavla 
    
    xor bx, bx
    mov ah, 2
    xor dl, dl
    mov dh, 1
    int 10h
    
    
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h 
    cmp al, 79h
    je sta
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

    ;======================================;
    ;                                      ;
    ; The procedure gets three parameters. ;
    ; one by dx that save the location of  ;    Works!!
    ; invite for input.                    ;
    ; And 2 in stack that say the range of ;
    ; the input digit                      ;
    ; the procedure read & check the digit ;
    ; and returns the input in dl          ;
    ;                                      ;
    ;======================================; 
    
    raedAndCheckDigit proc near 
        mov bp, sp       ;saving sp, the loc of return into main
        
        push ax          ;\
        push bx          ; |saving the "ogrim"
        push cx          ;/
        
        mov bh, [bp+2]   ;max range
        add bh, '0'
        mov bl, [bp+4]   ;min range
        add bl, '0'
        
        mov ah, 9        ;\typing invite for input
        int 21h          ;/
        
        again1:
        mov ah, 7        ;\read digit
        int 21h          ;/
        cmp al, bh       ;\check wether he greater then range
        jg again1        ;/
        cmp al, bl       ;\check wether he below then range
        jb again1        ;/
                        
        xor ah, ah       ;\saving for typing and ret in dx
        mov dx, ax       ;/
                        
        mov ah, 2        ;\typing the input digit(i used 7-->ah>
        int 21h          ;/
                        
        sub dx, '0'      ;for return the game mode in number
        
        pop cx           ;\  
        pop bx           ; |return to the "ogrim" their values
        pop ax           ;/
    
      ret 4     ;4-->two parameters in stack
    raedAndCheckDigit endp  
    
    ;======================================; 
    ;                                      ;
    ; The procedure gets 1 parameter by    ;
    ; stack.                               ;
    ; that save wether to write the input  ;    Works!!!
    ; number or hide him with '*':         ;
    ; 0-show(write)                        ;
    ; 1-hide ('*')                         ;
    ; The procedue read the number and     ;
    ; check wether he in between 1 to      ;
    ; 100 and return the number in bx      ;
    ;                                      ;
    ;======================================;
                                       
    ReadAndCheckNum proc near 
        mov bp, sp
        
        push ax
        push cx
        push dx 
        
        xor bx, bx           ;0-->bx for saving input number
        
        xor di, di        ;-->digcount
        
        readAgain:
        mov ah, 7         ;\read digit
        int 21h           ;/
        cmp al, 13d       ;check if its 'Enter'
        jne continue3
        cmp bx, 0         ;\check if the user press 'Enter' before
        je readAgain      ;/input any number
        jne done
        continue3:
        inc di        
        cmp bx, 0Ah       ;\
        jne continue2     ; |check if the user enter "10" and he 
        cmp al, '0'       ; |can only input "enter" or "0" now.
        jne readAgain     ;/
        
        continue2:         ;\
        cmp al, '0'       ; |\
        jb readAgain      ; | |check the digit
        cmp al, '9'       ; |/
        jg readAgain      ;/      
        
        
        sub al, '0'       ;make the input digit to dec digit
        xor ah, ah        ;\
        push ax           ;/save digit for 'mul'
        mov ax, 10d       ;\
        mul bx            ; |mul bx by 10d every digit for saving
        mov bx, ax        ;/ in hexadecimaly form
        pop ax            ;\
        add bx, ax        ;/add the digit to bx 
        
        cmp di, 3
        jb c5
        cmp bx, 0
        je readAgain 
        
        c5:
        mov cx, [bp+2]    ;check whether need to hide the 
        cmp cx, 1         ;input number
        je hide
        mov dl, al        ;\
        add dl, '0'       ; |\
        xor dh, dh        ; | |typing digit(0 mode)
        mov ah, 2         ; |/
        int 21h           ;/
        jmp continue4
        hide:
        xor ah, ah        ;\save the input digit
        push ax           ;/            
        mov ah, 2         ;\
        mov dx, '*'       ; |typing '*'(1mode)
        int 21h           ;/
        pop ax            ;return to al the input digit  
        
        continue4: 
        
        cmp bx, 0Ah       ;\Ah = 10, the num cant be 3 digit exept
        jg done           ;/100.
        
        jmp readAgain
       
        done:
        
        pop dx
        pop cx
        pop ax
        
        ret 2             ;2-->1 parameter in stack
    ReadAndCheckNum endp
    
    ;======================================;
    ;                                      ; 
    ; The procedure gets none parameters.  ;
    ; The procedur calculate random number ;     Works!
    ; between 1-100 and return hum in dl.  ;
    ;                                      ;
    ;======================================;
    
    randomNum proc near 
        
        push ax         ;\
        push bx         ; |save the "Ogrim"
        push cx         ;/
        
        again2:                                       
        mov ah, 2Ch     ;\gets time.                  
        int 21h         ;/1/1000 second in dl                
        cmp dl,0        ;\                               
        je again2       ;/can't be 0 (for later check) 
        
        pop cx          ;\
        pop bx          ; |return the value to the "Ogrim"
        pop ax          ;/
        
        ret
    randomNum endp 
    
    ;===========================================;
    ;                                           ;
    ; The procedure gets 2 parameters by stack. ;
    ; 1 - the guess number.                     ;
    ; 2 - the location of invite for guess.     ;
    ; The procedure type the invite on the last ;
    ; one (clear the last invite)               ;
    ;                                           ;
    ;===========================================;
    
    inviteGuess proc near
        mov bp, sp
        
        push ax
        push bx
        push cx
        push dx 
        
        mov dh, 0
        mov dl, 25
        mov ah, 2
        int 10h
        
        mov dx, [bp+4]
        mov ah, 2
        int 21h
        
        mov dx, [bp+2]
        mov ah, 9
        int 21h 
        
        xor bx, bx
        mov dh, 0
        mov dl, 46
        mov ah, 2
        int 10h
        
        pop dx
        pop cx
        pop bx
        pop ax  
        
        ret 4
    inviteGuess endp
    
    ;==========================================;
    ;                                          ;
    ; The procedure gets 1 parameter by stack. ;
    ; the parameter save the location of the   ;
    ; tavla.                                   ;
    ; the procedure typing the tavla in the    ;
    ; right location on the scren.             ;
    ;                                          ;
    ;==========================================; 
    
    typetavla proc near 
        mov bp, sp
        
        push ax
        push bx
        push cx
        push dx
        
        mov dh, 2
        xor dl, dl
        xor bx, bx
        mov ah, 2
        int 10h
        
        mov dx, [bp+2]
        mov ah, 9
        int 21h
        
        pop dx
        pop cx
        pop bx
        pop ax
        
        ret 2
    typetavla endp
    
    ;===========================================;
    ;                                           ;
    ; The procedure gets 3 parameters by stack. ;
    ; 1. the new input number.                  ;
    ; 2. the 'guess' number.                    ;
    ; 3. the location of 3 space codes.         ;
    ; The procedur clean the tavla accord the   ;
    ; parameters.                               ;
    ;                                           ;
    ;===========================================;
    
    upgradeTavla proc near 
        
        mov bp, sp
        
        push ax                  ;1.(+6) --> the input guess
        push bx                  ;2.(+4) --> the guess number
        push cx                  ;3.(+2) --> space
        push dx
        push si
        push di
        
        mov si, [bp+6]
        cmp si, [bp+4]
        jg greater
        je con  
        
        xor si, si
        xor di, di
        mov cx, 10
spaceAgain:
 
        push cx
        mov ax, di
        mov dh, al
        add dh, 4
        mov dl, 17
        mov ah, 2
        xor bx, bx
        int 10h
        
        mov cx, 10
     z:
        cmp si, [bp+6]
        je endd
        mov dx, [bp+2]
        mov ah, 9
        int 21h
        inc si
     loop z
        
        inc di
        inc di
        pop cx
loop spaceAgain

        endd:
        pop cx
        jmp con  
        
        
        
        greater:
        mov ax, [bp+6]
        xor dx, dx
        mov di, 10
        div di
        mov dh, al
        add dh, dh
        add dh, 4                ;ax-->"menat"
        cmp dl, 0                ;dx-->"shearit"
        je divbyten 
        add dl, dl
        add dl, dl
        add dl, 13
        jmp movesighn
   divbyten:
        sub dh, 2
        mov dl, 53
        
movesighn:
        xor bx, bx
        mov ah, 2
        int 10h
        
        push dx    ; save the x,y locion of first ckean
        
        mov si, [bp+6]
        
    clearagain2:
        cmp si, 101
        jge con2 
        
        mov di, 10
        mov ax, si 
        cmp si, [bp+6]
        je printspace
        xor dx, dx 
        div di
        cmp dx, 1
        jne printspace
        
                          ;here its the end of a line
        pop dx
        mov dl, 17
        inc dh
        inc dh
        push dx
        xor bx, bx
        mov ah, 2
        int 10h
        
    printspace:
        mov dx, [bp+2]
        mov ah, 9
        int 21h
        
        inc si
    jmp clearagain2
        
con2:
        pop dx        
        
con:
        xor dx, dx
        xor bx, bx
        mov ah, 2
        int 10h                         
        
        pop di
        pop si                         
        pop dx
        pop cx                    ;  ===================
        pop bx                    ;|16 chats till tavla|
        pop ax                    ;  ===================
        
        ret 6
    upgradeTavla endp
    
    ;=====================================;              
    ;                                     ;          
    ; The pricedure gets none parameters. ;           Works!
    ; The procedure clear the screan.     ;         
    ;                                     ;
    ;=====================================;                                     
    clear proc near                       
        
        push ax
        
        mov ax, 3
        int 10h
        
        pop ax
        ret
    clear endp
    
end start ; set entry point and stop the assembler.
