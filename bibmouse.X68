*Teste si le click gauche est enfoncé ou non 
*registres utilisés: D0, D1

IF_LEFT_CLICK:                          *        DEBUT IF_LCLICK        *
    CLR.L   D1                          *D1 = 0                         *
    JSR     GET_MOUSE                   *D0 = GET_MOUSE()               *
    AND.B   #1, D0                      *D0 &= 1                 *
    
    CMP.B   #1, D0                      *(D0 == 1)                      *
    RTS                                 *         FIN IF_LCLICK         *

*---------------------------------------------------------------------*
*Teste si le curseur de la souris est sur le bouton
*registres utilisés: D0, D1, D2, D3, A1

BUTTON_HOVER:                           *      DEBUT BUTTON_HOVER       *
    MOVE.L  (A1)+, D2                   *D2 = (A1 {+4} )                *
    MOVE.L  (A1), D3                    *D3 = *A1                       *
    SUB.L   #4, A1                      *A1 -= 4                        *
    CLR.L   D0                          *D0 = 0                         *
    CMP.W   D1, D2                      *si (D1 < D2)                   *
    BGT     END_BUTTON_HOVER            *aller à  END                   *
    CMP.W   D1, D3                      *si (D1 > D3)                   *
    BLT     END_BUTTON_HOVER            *aller Ã  END                   *
    SWAP    D1                          
    SWAP    D2                          
    SWAP    D3                          
    CMP.W   D1, D2                      *si (D1 < D2)                   *
    BGT     SWAP_BUTTON_HOVER           *aller à  SWAP                  *
    CMP.W   D1, D3                      *si (D1 > D3)                   *
    BLT     SWAP_BUTTON_HOVER           *aller à  SWAP                  *
    MOVE.L  #1, D0                      *D0 = 1                         *

SWAP_BUTTON_HOVER:                      *             re-SWAP           *
    SWAP    D1                          
    SWAP    D2                          
    SWAP    D3                          

END_BUTTON_HOVER:                       *              END              *
    CMP.B  #1, D0                       *(D0 == 1)                      *
    RTS                                 *       FIN BUTTON_HOVER        *





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
