global sub

section .text
section .data
sub:
        mov eax, [esp+4]
        sub eax, [esp+8]
        sub eax, [esp+12]
        ret

