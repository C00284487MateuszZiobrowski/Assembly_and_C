*-----------------------------------------------------------
* Title      :PRACTICAL 05 PART 3
* Written by :Mateusz Ziobrowski
* Date       :13/02/2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
DAMAGE EQU 100
START:                  ; first instruction of program
    GAME_LOOP:
        LEA     MSG_GAME_LOOP, A1
        MOVE.B  #13, D0
        TRAP    #15
        CMP.B #0, PLAYER_HEALTH
        BEQ GAME_OVER
        BSR UPDATE
        BSR COLLISION_CHECK
        BRA GAME_LOOP
  
    UPDATE:
        ADD.B   #1, PLAYER_POSITION
        RTS

    COLLISION_CHECK:
        MOVE.B  PLAYER_POSITION, D1
        CMP.B   D2,D1
        BEQ     COLLISION
        RTS

    COLLISION:
        SUB.B #DAMAGE, PLAYER_HEALTH
        BRA GAME_LOOP
    GAME_OVER:
        LEA     MSG_GAME_OVER, A1
        MOVE.B  #13, D0
        TRAP    #15
        SIMHALT
        
PLAYER_POSITION:    DC.B 10
ENEMY_POSITION:     DC.B 50
PLAYER_HEALTH:      DC.B 100

MSG_GAME_LOOP       DC.B    'Game Loop........',0
MSG_GAME_OVER       DC.B    'Game Over!',0

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
