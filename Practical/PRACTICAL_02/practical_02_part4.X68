*-----------------------------------------------------------
* Title      :Practical 2 part 4 
* Written by :Mateusz Ziobrowski
* Date       :23/01/2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.L  #%200,  D0
    MOVE.L  #$200,  D1
    MOVE.L  #200,   D1
    
    MOVE.L  D0,     $2000
    MOVE.L  D1,     $2010
    MOVE.L  D2,     $2020

    MOVE.W  #200,   $2020
    MOVE.W  #$200,  $2010
    MOVE.W  #%200,  $2000
    
    MOVE.B  #200,   $2020
    MOVE.B  #$32,   $2010
    MOVE.B  #%10001011,   $2000
    

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
