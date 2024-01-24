*-----------------------------------------------------------------------*
*Change la couleur du crayon
*SET_PEN_COLOR(D1.L(couleur))
*registres utilisées: D0, D1

SET_PEN_COLOR:
    MOVE    #80, D0
    TRAP    #15
    RTS
    
*-----------------------------------------------------------------------*
*Change la couleur de remplissage
*SET_FILL_COLOR(D1.L(couleur))
*registres utilisées: D0, D1
    
SET_FILL_COLOR:
    MOVE    #81, D0
    TRAP    #15
    RTS
    
*-----------------------------------------------------------------------*
*Dessine un rectangle plein
*DRAW_FILL_RECT(D1.W(X1), D2.W(Y1), D3.W(X2), D4.W(Y2))
*registres utilisÃ©es: D0, D1, D2, D3, D4
    
DRAW_FILL_RECT:
    MOVE    #87, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------------------*
*Dessine une chaine de caractÃ¨re
*DRAW_STRING(D1.W(X), D2.W(Y), A1(chaine))
*registres utilisées: D0, D1, D2, A1

DRAW_STRING:
    MOVE    #95, D0
    TRAP    #15
    RTS


WIDTH_PEN:
    MOVE    #93,D0
    TRAP    #15
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
