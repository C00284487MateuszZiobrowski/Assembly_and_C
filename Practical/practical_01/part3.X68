*-----------------------------------------------------------
* Title      :Part 3
* Written by :Mateusz Ziobrowski
* Date       :18/01/2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    MOVE.B  #$64,D1
    LEA text, A1
    MOVE    #14,D0
    TRAP    #15

    MOVE    #3,D0
    TRAP    #15

    SIMHALT             ; halt simulator
text dc.b 'Data Register: ',0

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
