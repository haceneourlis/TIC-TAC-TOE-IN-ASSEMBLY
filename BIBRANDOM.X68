GET_SEED:
    JSR GET_TIME
    CMP.L #0,D1 * si : D1 == 0 , c'est qu'on lancé le jeu à minuit 
    BNE END_GETTING_SEED
    MOVE.L #$AABBF,D1 * aucune signification  AABBF est choisi aléatoirement mais quand meme il fallais que ce nombre soit plus grand que 301 
END_GETTING_SEED:    
    MOVE.L D1,SEED
    RTS
    
    
    
* GENERATE A NUMBER FROM 300 TO 600 ( X ) SO ( Y - X + 1 = 301 )    
GET_RANDOM_X_POS:   
    CLR.L D3
    MOVE.L SEED,D3
    DIVU #301,D3
    SWAP D3
    AND.L #$0000FFFF,D3
    ADD.W #300,D3
    MOVE.W D3,X_ALEATOIRE	
    SUB.L #500,SEED * pour générer un nombre différent à la suite ...
    MOVE.L SEED,D3
    MULU #$5,D3
    MOVE.L D3,SEED
    RTS
    
* GENERATE A NUMBER FROM 100 TO 400 ( X ) SO ( Y - X + 1 = 301 )   
GET_RANDOM_Y_POS:   
    CLR.L D3
    MOVE.L SEED,D3
    DIVU #301,D3
    SWAP D3
    AND.L #$0000FFFF,D3
    ADD.W #100,D3
    MOVE.W D3,Y_ALEATOIRE
    SUB.L #600,SEED * pour générer un nombre différent à la suite ...
    MOVE.L SEED,D3
    MULU #$5,D3
    MOVE.L D3,SEED
    RTS
    
    
GET_TIME:
    MOVE    #8, D0
    TRAP    #15
    RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
