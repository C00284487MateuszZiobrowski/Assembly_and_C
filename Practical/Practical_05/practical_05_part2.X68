*-----------------------------------------------------------
* Title      :Practical 05 practical 2 
* Written by :Mateusz Ziobrowski
* Date       :13/02/2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
       LEA PLAYER_POSITION, A1
       LEA ENEMY_POSITION, A2
    
       MOVE.B #50, D1
       MOVE.B #0, D2

    COLLISION_CHECK:
        CMP D2, D1
        BLT NEXT_MOVE
        BEQ COLLISION
        
    NEXT_MOVE:
        ADD.B #1, D2
        BRA COLLISION_CHECK
        
    COLLISION:
        BRA GAME_OVER
        
    GAME_OVER:
        SIMHALT
        
        
    PLAYER_POSITION: DC.B 10, 15
    ENEMY_POSITION: DC.B 50, 55
    
    END     START
    
        

    


* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
