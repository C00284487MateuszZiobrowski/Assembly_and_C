*-----------------------------------------------------------
* Title      :Practical 4 part 4
* Written by :Mateusz Ziobrowski
* Date       :06/02/2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    ;Move health to memory location $3000
    MOVE.B  #100, $3000
    
    ;Move Boss health to memory location 3010
    MOVE.B #100, $3010
    
    ;Load Memory Address $3000 into Address Register A1 and $3010 to register A2
    LEA     $3000, A1
    LEA     $3010, A2
    
    ;Move location of Player into Data Register
    MOVE.B  #$11, D2
    
    ;Move location of Boss into Data Register
    Move.B  #$21, D3
    
    ;Bitwise AND D2 AND D3
    AND.B D2, D3
    
    ;Branch to taking damage
    BSR TAKING_DAMAGE
    
BACK_IN_THE_GAME:
    BSR HEALTH_PICKUP
    BRA END_GAME
    
TAKING_DAMAGE:
    ;Hit by boss
    ;Boss
    SUB.B   #100, (A2)
    SUB.B   #20, (A1)
    BRA     BACK_IN_THE_GAME
    
HEALTH_PICKUP:
    ADD.B   #10, (A1)
    
END_GAME:
    ;Game over
    MOVE.B  #100, (A1)
    
    

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
