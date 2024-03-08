*-----------------------------------------------------------
* Title      :PAWN SHOP SIMULATOR
* Written by :MATEUSZ ZIOBROWSKI
* Date       :STARTED 26/02/2024 ENDED 08/03/2024
* Description:SET UP SHOP IN LOCATION AND CUSTOMERS COME IN WITH ITEMS AND THE PLAYER GETS TO CHOOSE IF HE WANTS TO BUY IT OR NOT.
* FROM A COUPLE OF PLAY TESTS NO BUGS HAVE BEEN DETECTED AND I REMOVED SOME OF THE USELESS CODE FOR EASE OF READING
*-----------------------------------------------------------
*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    
    ORG $1000

*-------------------------------------------------------
* CHOOSE TO BUILD A SHOP IN THE CITY OR A VILLAGE
*-------------------------------------------------------

*-------------------------------------------------------
* VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
* ADD ADDITIONAL VALIDATION VALUES AS REQUIRED
*-------------------------------------------------------
EXIT            EQU     0      ; USED TO EXIT ASSEMBLY PROGRAM
TOTAL_GOLD_FUND EQU     200
MIN_GOLD        EQU     0           ; MIN NUMBER OF GOLD
MAX_GOLD        EQU     200         ; MAX NUMBER OF GOLD
VILLAGE_COST    EQU     50          ; COST TO SET UP IN A VILLAGE
CITY_COST       EQU     100         ; COST TO SET UP IN A CITY
MINE_LOC        EQU     100         ; USED BELOW FOR SOME SIMPLE COLLISION DETECTION USING CMP
MINE_LOC        EQU     100         ; USED BELOW FOR SOME SIMPLE COLLISION DETECTION USING CMP
                                    ; EXAMPLE FOR A HIT


*-------------------------------------------------------
* START OF GAME
*-------------------------------------------------------
START:
    
    MOVE.L  #200, D5


    BSR     WELCOME    ; BRANCH TO THE WELCOME SUBROUTINE
    BSR     INPUT      ; BRANCH TO THE INPUT SUBROUTINE
    BSR     CUSTOMER_1
    BSR     CUSTOMER_2
    BSR     CUSTOMER_3
    BSR     CUSTOMER_4
    BSR     GAME       ; BRANCH TO THE GAME SUBROUTINE
    RTS
*-------------------------------------------------------
* GAME LOOP
*-------------------------------------------------------
    ORG     $3000      ; THE REST OF THE PROGRAM IS TO BE LOCATED FROM 3000 ONWARDS

*-------------------------------------------------------
*-------------------GAME SUBROUTINE---------------------
*-------------------------------------------------------
GAME:

    BSR     GAMELOOP   ; BRANCH TO GAMELOOP SUBROUTINE

    RTS                ; RETURN FROM GAME: SUBROUTINE
          
END:
    SIMHALT
    
*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
*-------------------------------------------------------
WELCOME:

    LEA     WELCOME_MSG,A1      ; Load address of welcome message
    MOVE.B  #14,D0              ; Function code to display string
    TRAP    #15                 ; Call operating system to display message

    ; Display welcome choice message
    LEA     WELCOME_CHOICE,A1   ; Load address of welcome choice message
    MOVE.B  #14,D0              ; Function code to display string
    TRAP    #15                 ; Call operating system to display message

    RTS                         ; Return from subroutine
    
    
    ; Implementing the game logic
    MOVE.B  #4,D0               ; Display message for player to choose
    TRAP    #15
    MOVE.B  #1,D0               ; Wait for player input
    CMP.B   #1,D1               ; Check player input




*-------------------------------------------------------
*---------GAMEPLAY INPUT VALUES SUBROUTINE--------------
*-------------------------------------------------------    
INPUT:
 ; Get user input
    MOVE.B  #4,D0               ; Function code to display prompt
    LEA     INPUT_PROMPT,A1     ; Load address of input prompt
    TRAP    #15                 ; Call operating system to display prompt
    
    MOVE.B  #3,D0               ; Function code to read integer
    TRAP    #15                 ; Call operating system to read integer
    
    CMP.B   #1,D1               ; Check user input
    BEQ     VILLAGE             ; If user chose 1, go to village
    CMP.B   #2,D1               ; Check user input
    BEQ     CITY                ; If user chose 2, go to city
    BRA     INPUT               ; If invalid input, repeat input process
    
    
; Get user input
    MOVE.B  #4,D0               ; Function code to display prompt
    LEA     INPUT_PROMPT,A1     ; Load address of input prompt
    TRAP    #15                 ; Call operating system to display prompt
    
    MOVE.B  #3,D0               ; Function code to read integer
    TRAP    #15                 ; Call operating system to read integer
    
    CMP.B   #1,D1               ; Check user input
    BEQ     BUY_ITEM            ; If user chose 1, buy item
    CMP.B   #2,D1               ; Check user input
    BEQ     NO_BUY              ; If user chose 2, don't buy item
    BRA     INPUT               ; If invalid input, repeat input process

BUY_ITEM:
    MOVE.B  #1,D1               ; Set register D1 to 1 to indicate buying
    RTS                         ; Return from subroutine

NO_BUY:
    MOVE.B  #2,D1               ; Set register D1 to 2 to indicate not buying
    RTS                         ; Return from subroutine


*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:

    BSR     CLEAR_SCREEN    ; CLEARS THE SCREEN
    BSR     REPLAY          ; BRANCH TO REPLAY GAME SUBROUTINE
    BSR     CLEAR_SCREEN    ; CLEARS THE SCREEN
    RTS                     ; RETURN FROM GAMELOOP: SUBROUTINE
    

*---------------------------------------------------------------
*-------------------------Village or City-----------------------
* Picking a village or a city to settle in
*---------------------------------------------------------------   
VILLAGEORCITY:
    LEA     VILLAGEORCITY_MSG,A1    ; ASSIGN MESSAGE TO ADDRESS REGISTER A1
    CMP.B   #49,D2                  ; CHECK IF PLAYER CHOSE '1'
    BEQ     VILLAGE                 ; IF YES, GO TO VILLAGE
    CMP.B   #50,D2                  ; CHECK IF PLAYER CHOSE '2'
    BEQ     CITY                    ; IF YES, GO TO CITY
    BRA     VILLAGEORCITY           ; OTHERWISE, REPEAT

VILLAGE:
    BSR     DISPLAY_VILLAGE_MSG     ; Display village message
    SUB.L   #50, D5
    BSR     DISPLAY_GOLD_FUND
    RTS

CITY:
    BSR     DISPLAY_CITY_MSG        ; Display city message
    SUB.L   #100, D5
    BSR     DISPLAY_GOLD_FUND
    RTS


DISPLAY_VILLAGE_MSG:
    LEA     VILLAGE_LEFT_MSG,A1     ; Load address of village message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message
    RTS                             ; Return from subroutine

DISPLAY_CITY_MSG:
    LEA     CITY_LEFT_MSG,A1        ; Load address of city message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message
    RTS                             ; Return from subroutine
    

*-------------------------------------------------------------------------
*-------------------------ALL THE CUSTOMERS-------------------------------
* MAIN PART OF THE GAME WHERE IT ADDS DEDUCTS AND UPDATES THE GOLD COINS 
*-------------------------------------------------------------------------
   
CUSTOMER_1:
    ; Customer 1 approaches the player with an item for sale
    BSR     CLEAR_SCREEN
    LEA     CUSTOMER_1_MSG,A1       ; Load address of customer message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message

    MOVE.B  #4,D0                   ; Display message for player to choose
    LEA     BUY_ITEM_PROMPT,A1      ; Load address of buy item prompt message
    TRAP    #15                     ; Trap to display the message

    MOVE.B  #3,D0                   ; Function code to read integer
    TRAP    #15                     ; Call operating system to read integer

    CMP.B   #1,D1                   ; Check if player wants to buy
    BEQ     .purchase_item          ; If yes, proceed to purchase item
    BRA     .tax_player             ; If no, proceed to tax the player

.purchase_item:
                                    ; Adjust the total gold funding
    ADD.L   #55, D5                 ; Adjust the total gold funding
                                    ; Display earned coins message
    LEA     YES_COIN_AMOUNT,A1      ; Load address of remaining gold message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message
    BRA     .end_customer           ; End the customer interaction


.tax_player:
    ; Display tax paid message
    ; Update total gold funding
    SUB.L   #25, D5                 ; Adjust the total gold funding
    LEA     TAX_MSG,A1              ; Load address of tax message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message


.end_customer:
    ; Display total gold funding
    MOVE.L  D5, D2                  ; Move total gold funding to display register
    BSR     DISPLAY_GOLD_FUND
    RTS                             ; Return from subroutine

CUSTOMER_2:
   ; Customer 1 approaches the player with an item for sale
    BSR     CLEAR_SCREEN
    LEA     CUSTOMER_2_MSG,A1       ; Load address of customer message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message

    MOVE.B  #4,D0                   ; Display message for player to choose
    LEA     BUY_ITEM_PROMPT,A1      ; Load address of buy item prompt message
    TRAP    #15                     ; Trap to display the message

    MOVE.B  #3,D0                   ; Function code to read integer
    TRAP    #15                     ; Call operating system to read integer

    CMP.B   #1,D1                   ; Check if player wants to buy
    BEQ     .purchase_item          ; If yes, proceed to purchase item
    BRA     .tax_player             ; If no, proceed to tax the player

.purchase_item:
    ; Adjust the total gold funding
    ADD.L   #60, D5  

    ; Display earned coins message
    LEA     YES_COIN_AMOUNT2,A1     ; Load address of remaining gold message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message

    BRA     .end_customer           ; End the customer interaction


.tax_player:
    ; Display tax paid message
    ; Update total gold funding
    SUB.L   #25, D5                 ; Adjust the total gold funding
    LEA     TAX_MSG,A1              ; Load address of tax message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message


.end_customer:
    ; Display total gold funding
    MOVE.L  D5, D2                  ; Move total gold funding to display register
    BSR     DISPLAY_GOLD_FUND
    RTS                             ; Return from subroutine

CUSTOMER_3:
; Customer 1 approaches the player with an item for sale
    BSR     CLEAR_SCREEN
    LEA     CUSTOMER_3_MSG,A1       ; Load address of customer message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message

    MOVE.B  #4,D0                   ; Display message for player to choose
    LEA     BUY_ITEM_PROMPT,A1      ; Load address of buy item prompt message
    TRAP    #15                     ; Trap to display the message

    MOVE.B  #3,D0                   ; Function code to read integer
    TRAP    #15                     ; Call operating system to read integer

    CMP.B   #1,D1                   ; Check if player wants to buy
    BEQ     .purchase_item          ; If yes, proceed to purchase item
    BRA     .tax_player             ; If no, proceed to tax the player

.purchase_item:
    ; Display earned coins message
    SUB.L   #100, D5                ; Adjust the total gold funding
    ; Display earned coins message
    LEA     YES_COIN_AMOUNT3,A1     ; Load address of remaining gold message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message

    BRA     .end_customer           ; End the customer interaction


.tax_player:
    ; Display tax paid message
    ; Update total gold funding
    SUB.L   #25, D5                 ; Adjust the total gold funding
    LEA     TAX_MSG,A1              ; Load address of tax message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message


.end_customer:
    ; Display total gold funding
    MOVE.L  D5, D2                  ; Move total gold funding to display register
    BSR     DISPLAY_GOLD_FUND
    RTS                             ; Return from subroutine

CUSTOMER_4:
; Customer 1 approaches the player with an item for sale
    BSR     CLEAR_SCREEN
    LEA     CUSTOMER_4_MSG,A1       ; Load address of customer message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message

    MOVE.B  #4,D0                   ; Display message for player to choose
    LEA     BUY_ITEM_PROMPT,A1      ; Load address of buy item prompt message
    TRAP    #15                     ; Trap to display the message

    MOVE.B  #3,D0                   ; Function code to read integer
    TRAP    #15                     ; Call operating system to read integer

    CMP.B   #1,D1                   ; Check if player wants to buy
    BEQ     .purchase_item          ; If yes, proceed to purchase item
    BRA     .tax_player             ; If no, proceed to tax the player

.purchase_item:
    ; Display earned coins message
    SUB.L   #80, D5                 ; Adjust the total gold funding
                                    ; Display earned coins message
    LEA     YES_COIN_AMOUNT4,A1     ; Load address of remaining gold message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message

    BRA     .end_customer           ; End the customer interaction


.tax_player:
    ; Display tax paid message
    ; Update total gold funding
    SUB.L   #25, D5                 ; Adjust the total gold funding
    LEA     TAX_MSG,A1              ; Load address of tax message into A1
    MOVE.B  #14,D0                  ; Move literal 14 to D0 (TRAP operation for displaying)
    TRAP    #15                     ; Trap to display the message


.end_customer:
    ; Display total gold funding
    MOVE.L  D5, D2                  ; Move total gold funding to display register
    BSR     DISPLAY_GOLD_FUND
    RTS                             ; Return from subroutine

GAMEPLAY:
    BSR     CUSTOMER_1              ; Branch to customer 1 interaction subroutine
    BSR     CUSTOMER_2              ; Branch to customer 2 interaction subroutine
    BSR     CUSTOMER_3              ; Branch to customer 3 interaction subroutine
    BSR     CUSTOMER_4              ; Branch to customer 4 interaction subroutine
    RTS

DISPLAY_GOLD_FUND:

    ; Display total gold funding message
    LEA     GOLD_FUND_MSG, A1       ; Load the address of the message
    MOVE.L  D5, -(A7)               ; Push the total gold fund value onto the stack
    MOVE.L  #14, D0                 ; Function code to display a message
    TRAP    #15                     ; Call operating system to display the message
    MOVE.L  (A7)+, D5               ; Pop the total gold fund value from the stack
    MOVE.L  D5, D1                  ; Move the total gold fund value to D1 for display
    MOVE.L  #3, D0                  ; Function code for displaying an integer
    TRAP    #15                     ; Display the total gold fund value
    RTS                             ; Return from subroutine

GOLD_FUND_MSG: DC.B    'Total Gold Fund: ', 0

CLEAR_SCREEN: 
    MOVE.B  #11,D0      ; CLEAR SCREEN
    MOVE.W  #$FF00,D1
    TRAP    #15
    RTS

*-------------------------------------------------------
*------------------------REPLAY-------------------------
*-------------------------------------------------------
REPLAY:
    BSR     ENDL
    LEA     REPLAY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  #4,D0
    TRAP    #15

    CMP     #EXIT,D1
    BEQ     END         ; IF SR Z REGISTER CONTAINS 1 BEQ => BRANCH EQUALS
    BSR     GAMELOOP

ENDL:
    MOVEM.L D0/A1,-(A7)
    MOVE    #14,D0
    LEA     CRLF,A1
    TRAP    #15
    MOVEM.L (A7)+,D0/A1
    RTS





*-------------------------------------------------------
*-------------------DATA DELARATIONS--------------------
*-------------------------------------------------------

CRLF:                   DC.B    $0D,$0A,0
WELCOME_MSG:            DC.B    '**********************************************************************'
                        DC.B    $0D,$0A
                        DC.B    'Welcome to the business game, You get to buy and sell items,'
                        DC.B    $0D,$0A
                        DC.B    'For either a profit or loss,'
                        DC.B    $0D,$0A   
                        DC.B    'You start with 200 gold coins or GC.'  
                        DC.B    $0D,$0A
                        DC.B    '**********************************************************************'
                        DC.B    $0D,$0A,0

                        
WELCOME_CHOICE          DC.B    'Please choose (1) Village 50GC or (2) City 100GC: ',0
                       

     



VILLAGEORCITY_MSG:      DC.B    'PLEASE CHOOSE WHERE YOU WANT TO SET UP.'
                        DC.B    $0D,$0A
                        DC.B    'IN (1) VILLAGE OR IN (2) CITY : ',0




VILLAGE_LEFT_MSG:       DC.B    'YOU HAVE CHOSEN THE VILLAGE.'
                        DC.B    $0D,$0A
                        DC.B    'YOU NOW HAVE 150 GOLD COINS LEFT ! ',0


CITY_LEFT_MSG:          DC.B    'YOU HAVE CHOSEN THE CITY.'
                        DC.B    $0D,$0A
                        DC.B    'YOU NOW HAVE 100 GOLD COINS LEFT ! ',0

INPUT_PROMPT            DC.B    'CHOOSE A 1 VILLAGE OR 2 CITY',0

CUSTOMER_1_MSG          DC.B    'A CUSTOMER CAME IN AND OFFERED THIS NOKIA CELLPHONE TO YOU.'
                        DC.B    $0D,$0A
                        DC.B    'DO YOU WANT TO BUY IT FOR 45 GOLDCOINS (1) YES OR (2) NO ? ! ',0
                      
CUSTOMER_2_MSG          DC.B    'A CUSTOMER CAME IN AND OFFERED THIS MP3 PLAYER TO YOU.'
                        DC.B    $0D,$0A
                        DC.B    'DO YOU WANT TO BUY IT FOR 50 GOLDCOINS (1) YES OR (2) NO ? ! ',0
                      
CUSTOMER_3_MSG          DC.B    'A CUSTOMER CAME IN AND OFFERED THIS DART-BOARD TO YOU.'
                        DC.B    $0D,$0A
                        DC.B    'DO YOU WANT TO BUY IT FOR 70 GOLDCOINS (1) YES OR (2) NO ? ! ',0
                      
CUSTOMER_4_MSG          DC.B    'A CUSTOMER CAME IN AND OFFERED THIS ENGINE TO YOU.'
                        DC.B    $0D,$0A
                        DC.B    'DO YOU WANT TO BUY IT FOR 80 GOLDCOINS (1) YES OR (2) NO ? ! ',0

BUY_ITEM_PROMPT         DC.B    'DO YOU WANT TO BUY THIS ITEM?',0
YES_COIN_AMOUNT         DC.B    ' YOU GAINED 55 GOLD COINS. ',0

TAX_MSG                 DC.B    ' YOU PAID 25 IN TAX !',0

YES_COIN_AMOUNT2        DC.B    ' YOU GAINED 60 GOLD COINS. ',0

YES_COIN_AMOUNT3        DC.B    ' YOU LOST 100 GOLD COINS. ',0

YES_COIN_AMOUNT4        DC.B    ' YOU LOST 80 GOLD COINS. ',0

REPLAY_MSG:             DC.B    'YOU FINISHED THE GAME GOOD JOB :).'
                        DC.B    $0D,$0A
                        DC.B    'PLEASE CHOOSE 0 TO END THE GAME. ! ',0








    END    START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
