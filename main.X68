*-----------------------------------------------------------
* Title      :  Jeu du morpion X & O
* Written by :  OURLIS Hacene & TALAB Stephane
* Date       :  30/12/2023
* Description:  Jeu de morpion jouable contre la machine (qui n'est pas trés itelligente d'ailleurs ) ou contre un autre joueur
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    JSR GET_SEED     * SEED : une base pour le jeu aléatoire .
    
    MOVE.L  RESOL, D1                *ajuster la resolution de l'interface du jeu 
    JSR     RESOLUTION 
    
        
    MOVE.L	#$AEDC33, D1           
    MOVE.L  RESOL, D2
    JSR		REMPLIR_BACKGROUND
    
    MOVE.L  #$FFFFFF, D1             ; couleurs ajuster aléatoirement .
    JSR     SET_PEN_COLOR
    MOVE.L  #$CCEE2A, D1            
    JSR     SET_FILL_COLOR
    
    
    MOVE.L  #BUTTON_ONE_PLAYER, A1
    JSR     DRAW_MENU                *Dessine le bouton "ONE_PLAYER"

    MOVE.L  #BUTTON_TWO_PLAYERS, A1
    JSR     DRAW_MENU                *Dessine le bouton "TWO_PLAYERS"
    
    MOVE.L  #BUTTON_RESTART, A1
    JSR     DRAW_MENU                *Dessine le bouton "RESTART"
    
    MOVE.L #BUTTON_QUIT,A1           *Dessine le bouton " QUIT GAME "
    JSR     DRAW_MENU
    
    JSR DRAW_GRILLE       * Dessine la grille du jeu 
    MOVE.L #GRILLE,A3
    
    MOVE.W #0,TEMP * variable qui sert à définir les roles ( qui va jouer ) 
        
    *changer les couleurs d'affichage de X et O
    MOVE.L  #$ABFFC3, D1            
    JSR     SET_PEN_COLOR
    MOVE.L  #$057AFF, D1            
    JSR     SET_FILL_COLOR


LOOP:
    JSR IF_LEFT_CLICK
    BNE LOOP
LOOP2:
    JSR IF_LEFT_CLICK
    BEQ LOOP2                       *D0 doit etre a 0 ( ce qui veut dire que le bouton gauche de la souris est relache ) pour continuer
    JSR WHICH_ONE

    CMP.L #BUTTON_RESTART,A1
    BNE CHECK_FOR_MODE 
    BRA START *refaire tout .
    
CHECK_FOR_MODE:
    CMP.L #BUTTON_ONE_PLAYER,A1     *si le bouton "ONE PLAYER" est clique on fait jouer la machine
    BNE NEW_CHECK_FOR_MODE
    MOVE.W #1,START_THE_GAME
    BRA LOOP
    

NEW_CHECK_FOR_MODE:
    CMP.L #BUTTON_TWO_PLAYERS,A1
    BNE IS_IT_STARTED
    MOVE.W #2,START_THE_GAME
    BRA LOOP
IS_IT_STARTED:
IS_IT_MULTI:
    CMP.W #2,START_THE_GAME
    BNE IS_IT_SOLO
    BRA GO_FOR_MULTIPLAYER
IS_IT_SOLO:
    CMP.W #1,START_THE_GAME
    BNE LOOP                        *mode de jeu par encore choisi
    BRA GO_FOR_SOLO



*------------------------ LE JEU -----------------------*
* ---- MODE SOLO ---- *
    
GO_FOR_SOLO:
    MOVE.W #1,VALID_INPUT
    JSR CHECK_FOR_VALID_INPUT
    BNE LOOP
    CMP.W #0,TEMP    
    BNE MACHINE
    BEQ HUMAN
    
HUMAN:    
    JSR PUTTING_X                   *on affiche X
    ADD.L A6,A3                     *on va mettre X dans la memoire ( la vrai grille du jeu dans la memoire ) 
    MOVE.B #$58,(A3)
    
    MOVE.W #1,TEMP
    BRA FAKE_END_OF_LOOP_SOLO
MACHINE:

    JSR RALENTIR_LA_MACHINE         *on ralenti la vitesse du jeu (de la machine)
    JSR GET_RANDOM_X_POS            *on prend une position X aleatoire
    JSR GET_RANDOM_Y_POS            *on prend une position Y aleatoire
    MOVE.W Y_ALEATOIRE,D1
    ASL.L #8,D1 * le shift c'est pour faire de la place sur ( .W) pour la coordonnée 'X'
    ASL.L #8,D1
    MOVE.W X_ALEATOIRE,D1
    
    JSR WHICH_ONE
    
    MOVE.W #1,VALID_INPUT
    JSR CHECK_FOR_VALID_INPUT
    BNE MACHINE    
    JSR PUTTING_O
    ADD.L A6,A3
    MOVE.B #$4F,(A3) 
    MOVE.W #0,TEMP
FAKE_END_OF_LOOP_SOLO:
    
    JSR CHECK_FOR_WINNER
    CMP.W #$EEEE,BOOL_WINNER
    BEQ THERE_IS_A_WINNER_SOLO
    BNE CONTINUE_PLAYING_SOLO
    
THERE_IS_A_WINNER_SOLO:
    *il faut arreter de jouer et afficher sur l'ecran WINNER 
    
     MOVE.L  #WINNER_BUTTON, A1
     JSR     DRAW_MENU              *Dessine le bouton "WINNER"
     JMP LOOP  
    
CONTINUE_PLAYING_SOLO:
    * on verifie si c'est un match nul ( toutes les cases ont des valeurs : $58 ou $4F )

    JSR VERIFIER_SI_MATCH_NUL
    BEQ KEEP_PLAYING_SOLO
    MOVE.L  #MATCH_NUL_BUTTON, A1
    JSR     DRAW_MENU               *Dessine le bouton "MATCH NUL"
    JMP LOOP
    
KEEP_PLAYING_SOLO: 
    MOVE.L #GRILLE,A3
    CMP.W #1,TEMP
    BEQ MACHINE
    BNE LOOP
    
    
    
*-------------------------------------------------------------------------------------------------------------* 
* ----- MODE 2 JOUEUR ----- *

GO_FOR_MULTIPLAYER:
   
    *on doit pas jouer sur une case deja prise par un autre joueur
    MOVE.W #1,VALID_INPUT
    JSR CHECK_FOR_VALID_INPUT
    BNE LOOP
    CMP.W #0,TEMP    
    BNE PLAYER_2
    BEQ PLAYER_1
    
PLAYER_1:    
    JSR PUTTING_X                  *on affiche X
    ADD.L A6,A3
    MOVE.B #$58,(A3)
    
    MOVE.W #1,TEMP
    BRA FAKE_END_OF_LOOP
PLAYER_2:
    JSR PUTTING_O
    ADD.L A6,A3
    MOVE.B #$4F,(A3)
    
    MOVE.W #0,TEMP
FAKE_END_OF_LOOP:
    
    JSR CHECK_FOR_WINNER
    CMP.W #$EEEE,BOOL_WINNER
    BEQ THERE_IS_A_WINNER
    BNE CONTINUE_PLAYING
    
THERE_IS_A_WINNER:
    *il faut arreter de jouer et afficher sur l'ecran WINNER 
    
     MOVE.L  #WINNER_BUTTON, A1
     JSR     DRAW_MENU              *Dessine le bouton "WINNER"
     
     JMP LOOP  
    
CONTINUE_PLAYING:
    JSR VERIFIER_SI_MATCH_NUL
    BEQ KEEP_PLAYING
    MOVE.L  #MATCH_NUL_BUTTON, A1
    JSR     DRAW_MENU               *Dessine le bouton "MATCH NUL"
    
    JMP LOOP
    
KEEP_PLAYING: 
    MOVE.L #GRILLE,A3
    BRA LOOP



FIN:
    JSR FINPRG
   

* ------- recherche du bouton cliquer --------*
WHICH_ONE:
    MOVE.L  #FIRST_BOUTON, A1
    JSR     BUTTON_HOVER
    BNE NEXT_2
    MOVE.L #0,A6
    JMP END_WHICH_ONE
NEXT_2:
    MOVE.L  #SECOND_BOUTON, A1
    JSR     BUTTON_HOVER
    BNE NEXT_3
    MOVE.L #1,A6
    JMP END_WHICH_ONE
NEXT_3:
    MOVE.L  #THIRD_BOUTON, A1
    JSR     BUTTON_HOVER
    BNE NEXT_4
    MOVE.L #2,A6
    JMP END_WHICH_ONE
NEXT_4:
    MOVE.L  #FOURTH_BOUTON, A1
    JSR     BUTTON_HOVER
    BNE NEXT_5
    MOVE.L #3,A6
    JMP END_WHICH_ONE
NEXT_5:
    MOVE.L  #FIFTH_BOUTON, A1
    JSR     BUTTON_HOVER
    BNE NEXT_6
    MOVE.L #4,A6
    JMP END_WHICH_ONE
NEXT_6:
    MOVE.L  #SIXTH_BOUTON, A1
    JSR     BUTTON_HOVER
    BNE NEXT_7
    MOVE.L #5,A6
    JMP END_WHICH_ONE
NEXT_7:
    MOVE.L  #SEVENTH_BOUTON, A1
    JSR     BUTTON_HOVER
    BNE NEXT_8
    MOVE.L #6,A6
    JMP END_WHICH_ONE
NEXT_8:
    MOVE.L  #EIGHTH_BOUTON, A1
    JSR     BUTTON_HOVER
    BNE NEXT_9
    MOVE.L #7,A6
    JMP END_WHICH_ONE
NEXT_9:
    MOVE.L  #NINTH_BOUTON, A1
    JSR     BUTTON_HOVER
    BNE     BOUTON_SOLO 
    MOVE.L #8,A6
    JMP END_WHICH_ONE

BOUTON_SOLO:
    MOVE.L #BUTTON_ONE_PLAYER,A1
    JSR BUTTON_HOVER
    BNE BOUTON_MULTIPLAYER
    MOVE.L #BUTTON_ONE_PLAYER,A1
    JMP END_WHICH_ONE
BOUTON_MULTIPLAYER:
    MOVE.L #BUTTON_TWO_PLAYERS,A1
    JSR BUTTON_HOVER
    BNE BOUTON_REJOUER
    MOVE.L #BUTTON_TWO_PLAYERS,A1
    JMP END_WHICH_ONE

BOUTON_REJOUER:
    MOVE.L #BUTTON_RESTART,A1
    JSR BUTTON_HOVER
    BNE BOUTON_QUIT
REJOUER_ICI:    
    JSR RESET
    JSR DRAW_GRILLE
    MOVE.L #BUTTON_RESTART,A1
     * on change les couleurs d'affichage de X et O
    MOVE.L  #$ABFFC3, D1            
    JSR     SET_PEN_COLOR
    MOVE.L  #$057AFF, D1            
    JSR     SET_FILL_COLOR
    BRA END_WHICH_ONE    
BOUTON_QUIT:
    MOVE.L #BUTTON_QUIT,A1
    JSR BUTTON_HOVER
    BEQ SORTIR
    * si on n'a clique sur aucun des boutons ci dessus ; on BRANCHE la boucle ' infinie '
    JMP LOOP
SORTIR:
    JMP FIN    
END_WHICH_ONE:    
    RTS



    *---------------------------------------------------------------------------*
    *Bibliotheques
    
    INCLUDE 'BIBDRAW.X68'
    INCLUDE 'BIBPERIPH.X68'
    INCLUDE 'BIBGRAPH.X68'
    INCLUDE 'BIBMOUSE.X68'
    include 'bibliofonctions.X68'
    INCLUDE 'TICTACTOE.X68'
    INCLUDE 'BIBRANDOM.X68'
    INCLUDE 'BIBLIO.X68'
* Put variables and constants here
    ORG $2000
    
    
SEED: DC.L 0


    
main_drapeau:     DC.W 0
flag:             DC.W 0            * Drapeau pour verifier s'il y a un gagnant a la sortie des verfications 'bibliofonctions.X68' 
colonne_suivante: DC.W 0
BOOL_WINNER:      DC.W 0 
TEMP:             DC.W 0
GRILLE:     DC.B 1,2,3              * on cree la grille dans la memoire
            DC.B 4,5,6
            DC.B 7,8,9                      
PLAY_THE_X: DC.W 'X',0
PLAY_THE_O: DC.W 'O',0

START_THE_GAME: DC.W 0
VALID_INPUT: DC.W 0
X_ALEATOIRE: DC.W 0
Y_ALEATOIRE: DC.W 0            
            
RESOL: DC.W 700,500
                                * ce dessous on cree les bouttons dans la memoire
FIRST_BOUTON:       DC.W 100,300,200,400 *Y1, X1, Y2, X2
                    DC.W 40 , 45 
SECOND_BOUTON:      DC.W 100,400,200,500 *Y1, X1, Y2, X2
                    DC.W 40 , 45
THIRD_BOUTON:       DC.W 100,500,200,600 *Y1, X1, Y2, X2
                    DC.W 40 , 45
                    
                    
FOURTH_BOUTON:      DC.W 200,300,300,400 *Y1, X1, Y2, X2
                    DC.W 40 , 45
FIFTH_BOUTON:       DC.W 200,400,300,500 *Y1, X1, Y2, X2
                    DC.W 40 , 45
SIXTH_BOUTON:       DC.W 200,500,300,600 *Y1, X1, Y2, X2
                    DC.W 40 , 45

SEVENTH_BOUTON:     DC.W 300,300,400,400 *Y1, X1, Y2, X2
                    DC.W 40,45
EIGHTH_BOUTON:      DC.W 300,400,400,500 *Y1, X1, Y2, X2
                    DC.W 40 , 45
NINTH_BOUTON:       DC.W 300,500,400,600 *Y1, X1, Y2, X2
                    DC.W 40 , 45          
            
BUTTON_ONE_PLAYER:     DC.W 15, 15, 65, 165	*Y1, X1, Y2, X2
                       DC.W 18,30         	*Y, X
                       DC.B 'ONE PLAYER',0
                
BUTTON_TWO_PLAYERS:    DC.W 85, 15, 135, 165   *Y1, X1, Y2, X2
                       DC.W 18, 30            	*Y, X
			           DC.B 'TWO PLAYERS',0

BUTTON_RESTART:        DC.W 155, 15, 205, 165  *Y1, X1, Y2, X2
                       DC.W 18, 47             *Y, X
			           DC.B 'RESTART',0
			           
BUTTON_QUIT:        DC.W 225, 15, 275, 165  *Y1, X1, Y2, X2
                       DC.W 18, 47             *Y, X
			           DC.B 'QUIT GAME',0			           
			           
			           
WINNER_BUTTON:       DC.W 40,300,95,550
                     DC.W 15,15
                     DC.B '   WE HAVE A WINNER !!!  ',0
	
MATCH_NUL_BUTTON: 	 DC.W 40,300,95,550
                     DC.W 15,15
                     DC.B '   MATCH NUL !   ',0


RALENTIR_VAR: DC.L 0	           
			           
    END    START        ; last line of source









































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
