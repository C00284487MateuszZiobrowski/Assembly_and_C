*-----------------------------------------------------------
* Title      :practical_06_part3
* Written by :Mateusz Ziobrowski
* Date       :27/02/2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
        LEA $4000, A7
        
        MOVE.B #1,-(A7)
        MOVE.B #2,-(A7)
        MOVE.B #3,-(A7)
        MOVE.B #4,-(A7)
        
        MOVE.B (A7)+, D1
        MOVE.B (A7)+, D1
        MOVE.B (A7)+, D1
        MOVE.B (A7)+, D1


* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
