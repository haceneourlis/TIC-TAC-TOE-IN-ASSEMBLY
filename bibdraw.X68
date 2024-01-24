*Remplit le fond d'une couleur contenu dans D1.L
*registres utilisés: D0, D1, D2, D3, D4

REMPLIR_BACKGROUND: 
    JSR SET_PEN_COLOR
    JSR SET_FILL_COLOR
    
    MOVE.W D2,D4   * D4 = D2.W
    SWAP D2        * swap 16bits for 16bits 
    MOVE.W D2,D3   * D3 = D2.W 
    CLR.L D1       * D1 = 0 
    CLR.L D2       * D2 = 0 
    
    JSR DRAW_FILL_RECT 
    RTS
    
*-----------------------------------------------------------------------*
*Dessine un bouton du menu
*registres utilisés: D1, D2, D3, D4 
DRAW_MENU:                            *       DEBUT DRAW_MENU      *
    MOVE.L  A1, D7             * s'en souvenir de la valeur initiale
    MOVE.W  (A1)+, D2                   *D2 = *(A1++)                   *
    MOVE.W  (A1)+, D1                   *D1 = *(A1++)                   *
    MOVE.W  (A1)+, D4                   *D4 = *(A1++)                   *
    MOVE.W  (A1)+, D3                   *D3 = *(A1++)                   *
    JSR     DRAW_FILL_RECT              *DRAW_FILL_RECT(D1, D2, D3, D4) *
    ADD.W  (A1)+, D2                    *D2 = *(A1++)                   *
    ADD.W  (A1)+, D1                    *D1 = *(A1++)                   *
    JSR     DRAW_STRING                 *DRAW_STRING(D1, D2, A1)        *

    MOVE.L  D7, A1  *on récupere la valeur originale de A1
    RTS                                 *        FIN DRAW_MENU        *


*-----------------------------------------------------------------------*
*Dessine un bouton
*registres utilisés: D1, D2, D3, D4 
DRAW_BUTTON:                            *       DEBUT DRAW_BUTTON       *
    MOVE.L  A1, D7            
    MOVE.W  (A1)+, D2                   *D2 = *(A1++)                   *
    MOVE.W  (A1)+, D1                   *D1 = *(A1++)                   *
    MOVE.W  (A1)+, D4                   *D4 = *(A1++)                   *
    MOVE.W  (A1)+, D3                   *D3 = *(A1++)                   *
    JSR     DRAW_FILL_RECT              *DRAW_FILL_RECT(D1, D2, D3, D4) *
    ADD.W  (A1)+, D2                    *D2 = *(A1++)                   *
    ADD.W  (A1)+, D1                    *D1 = *(A1++)                   *
    MOVE.L  D7, A1            
    RTS                                 *        FIN DRAW_BUTTON        *



*-----------------------------------------------------------------------*
* DANS CES DEUX FONCTIONS , ON UTILISE LE REGISTRE A1 , qui a des information sur l'adresse du bouton cliqué .
*Dessine un X
PUTTING_X:
    MOVE.W  (A1)+, D2                   *D2 = *(A1 {+2} )                   *
    MOVE.W  (A1)+, D1                   *D1 = *(A1 {+2} )                   *
    ADD.W   #2,A1
    ADD.W   #2,A1
    
    ADD.W  (A1)+, D2                    *D2 = *(A1++)             *
    ADD.W  (A1)+, D1                    *D1 = *(A1++)             *
    
    MOVE.L #PLAY_THE_X,A1
    JSR DRAW_STRING
    RTS
*Dessine un O
PUTTING_O:
    MOVE.W  (A1)+, D2                   *D2 = *(A1++)                   *
    MOVE.W  (A1)+, D1                   *D1 = *(A1++)                   *
    ADD.W   #2,A1
    ADD.W   #2,A1
    
    ADD.W  (A1)+, D2                    *D2 = *(A1++)             *
    ADD.W  (A1)+, D1                    *D1 = *(A1++)             *
    
    MOVE.L #PLAY_THE_O,A1
    JSR DRAW_STRING
    RTS


*-----------------------------------------------------------------------*
* dessine la grille du jeu 
DRAW_GRILLE:
    MOVE.L  #$FFFFFF, D1            
    JSR     SET_PEN_COLOR
    MOVE.L  #$8F9D2A, D1           
    JSR     SET_FILL_COLOR

    MOVE.L #FIRST_BOUTON, A1
    JSR    DRAW_BUTTON
    MOVE.L #SECOND_BOUTON, A1
    JSR    DRAW_BUTTON
    MOVE.L #THIRD_BOUTON, A1
    JSR    DRAW_BUTTON
    
    MOVE.L #FOURTH_BOUTON, A1
    JSR    DRAW_BUTTON
    MOVE.L #FIFTH_BOUTON, A1
    JSR    DRAW_BUTTON
    MOVE.L #SIXTH_BOUTON, A1
    JSR    DRAW_BUTTON
    
    MOVE.L #SEVENTH_BOUTON, A1
    JSR    DRAW_BUTTON
    MOVE.L #EIGHTH_BOUTON, A1
    JSR    DRAW_BUTTON
    MOVE.L #NINTH_BOUTON, A1
    JSR    DRAW_BUTTON
    RTS












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
