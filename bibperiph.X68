*-----------------------------------------------------------------------*
*Change la résolution de la fenêtre
*RESOLUTION >> (D1.L(largeur/hauteur)) <<
*registres utilisés: D0, D1

RESOLUTION:
    MOVE    #33, D0
    TRAP    #15
    RTS

*-----------------------------------------------------------------------*
*Stocke les informations des boutons de la souris dans D0.B
*et sa position dans D1.L
*registres utilisés: D0, D1

GET_MOUSE:
    MOVE    #61, D0
    TRAP    #15
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
