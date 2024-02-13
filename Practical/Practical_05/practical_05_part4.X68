*-----------------------------------------------------------
* Title      :Practical 5 part 4
* Written by :Mateusz Ziobrowski
* Date       :13/02/2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
 ; D0 Used for Trap Codes, An counting enemies
 ; D1 Used for Players Health
 ; D2 Used for Enemy Positions
 ; D4 Used for Enemy count
 ; A0 for counting enemies
 ; A1 for progress messages
 ; A2 used for Player_X
 ; A3 used for Enemy_Positions
 
DAMAGE     EQU 10               ;Damage when Collisions occur
START:                          ;first instruction of program
    LEA     PLAYER_X, A2        ;Player will move along X axis
    LEA     ENEMY_POSITIONS, A3 ;Enemy positions or spawn points
    BRA     GAME_LOOP

GAME_LOOP:
    BSR     COUNT_ENEMIES       ;Size of the Enemy positions or spawn points
    MOVE.B  D0, D4              ;Reset enemy count at beginning of loop
    
    LEA     MSG_GAMELOOP, A1    ;load and draw Gameloop Message
    BSR     DRAW
    
    BSR     UPDATE              ;Call update
    BRA     GAME_LOOP           ;CALL Game_loop
    
UPDATE:

    MOVE.B  PLAYER_HEALTH, D1   ;Move player health into D1
    
    LEA     MSG_HEALTH, A1      ;Load and Draw Health message
    BSR     DRAW
    
    CMP     #0, D1              ;Check if Health is 0
    BLE     GAME_OVER           ;GAME OVER
    ADD.L   #1, (A2)            ;Change X position of player
    BSR     COLLISION           ;Check for Collisions with ENEMIES
    RTS
    
DRAW:
    MOVE.B  #13, D0
    TRAP    #15
    RTS
    
COLLISION:
    MOVE.B  #1, D5              ;Loop through array
    LEA     ENEMY_POSITIONS, A3 ;Load ENEMY_POSITIONS ARRAY
    
ITERATE:
    CMP     D5, D4              ;Counter for Enemy_Position
    ADD.B   #1, D5              ;Subtract one
    BEQ     GAME_LOOP           ;If 0 goto GAME_LOOP
    BNE     CHECK_ENEMIES       ;If not check for enemy collisions
    RTS
 
CHECK_ENEMIES:
    MOVE.L  (A3)+, D2           ;Move enemies position to D2
    MOVE.L  (A2), D3            ;Move player position to D3
    
    CMP.L   D2, D3              ;Compare Player and Enemy position
    BEQ     REDUCE_HEALTH       ;If equal reduce health
    BNE     ITERATE             ;iterate to next enemy
    
REDUCE_HEALTH:
    LEA     MSG_COLLISION, A1   ; Load and Draw Collision Message
    BSR     DRAW

    SUB.B   #DAMAGE, PLAYER_HEALTH

    LEA     MSG_DAMAGE, A1      ; Load and Draw Damage Message
    BSR     DRAW

    BRA     GAME_LOOP

GAME_OVER:
    LEA     MSG_GAMEOVER, A1
    BSR     DRAW
    SIMHALT

COUNT_ENEMIES:
    MOVE.B  #0, D0              ; Initialize counter to 0
    LEA     ENEMY_POSITIONS, A0 ; Load the address of the array into Ae

COUNT_ENEMIES_LOOP:
    TST.L   (A0)+               ;Test the byte at the address in A0 (Check if 0) and increment A0
    BEQ     END_COUNTING        ;If the byte is zero, it's the end of the array

    ADD.B   #1, D0              ;Increment the counter
    BRA     COUNT_ENEMIES_LOOP  ; Repeat the loop

END_COUNTING:
    RTS

PLAYER_X        DC.L        1
PLAYER_HEALTH   DC.B        100
MSG_HEALTH      DC.B        'Health : ', 0
MSG_GAMELOOP    DC.B        'Game Loop', 0
MSG_COLLISION   DC.B        'Collision', 0
MSG_GAMEOVER    DC.B        'Game Over', 0
MSG_DAMAGE      DC.B        'Taking Damage', 0
CRLF            DC.B        $0D,$0A,0
ENEMY_POSITIONS DC.L        20, 30, 40, 58, 68, 70, 80, 98, 200, 300, 500, 0 ; Terminate Array with a 8

    END     START


    
    



* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
