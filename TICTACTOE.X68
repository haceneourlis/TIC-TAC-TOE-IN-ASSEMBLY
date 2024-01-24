CHECK_FOR_WINNER:
*dans D5 on aura DAD ou BAD ou DDB ou DAB en fonctions du bloc gagnant ; AAA0BBB si match nul .   
        CLR.L D1
        CLR.L D2
        CLR.L D3
        CLR.L D4
        CLR.L D5
        CLR.L D6
        CLR.L D7	
    * Initaliser le drapeau a 0, si flag = 1 c'est gagné
        MOVE.L #flag, A6
        MOVE.W #$0,(A6)
        * initialiser le compteur des colonnes à ZERO
        MOVE.L #colonne_suivante,A5
        MOVE.W #$0,(A5)

    CHECK_MAIN_DIAGONALS:
        MOVE.L #grille,A0
        JSR VERFIER_DIAGONALES
        CMP.L #$BAD,D4 * si D4 = $BAD  alors diagonales perdantes .
        BEQ CHECK_MAIN_LINE
        BNE DIAGO_GAGNEE * si non ; une des diagonales est gagnante . donc on va sortir du programme directement.
    DIAGO_GAGNEE:
        MOVE.L #$DAD,D5    
        BRA FIN_DU_PROGRAMME
    CHECK_MAIN_LINE:
        MOVE.L #grille,A4
        JSR VERIFIER_LIGNE
        CMP.L #$BAD,D4 * si D4 = $BAD  alors toutes les lignes sont perdantes .
        BEQ CHECK_MAIN_COLUMN
        BNE LIGNE_GAGNEE * si non ; une des diagonales est gagnante . donc on va sortir du programme directemen    
    LIGNE_GAGNEE:
        MOVE.L #$DAB,D5
        BRA FIN_DU_PROGRAMME
    CHECK_MAIN_COLUMN:
        MOVE.W #$0,(A5)
        MOVE.L #grille,A3
        JSR VERIFIER_COLONNE
        CMP.L #$BAD,D4
        BEQ MATCH_NUL
        BNE COLONNE_GAGNEE * si non ; une des diagonales est gagnante.    

    COLONNE_GAGNEE:
        MOVE.L #$DDB,D5   
        BRA FIN_DU_PROGRAMME
    MATCH_NUL:
        MOVE.L #$AAA0BBB,D5       
    FIN_DU_PROGRAMME:        
        
        CMP.L #$AAA0BBB,D5       * Si il n y a pas eu encore de gagnant ou si (le match est nul )
        BNE WE_GOT_A_WINNER
        BEQ STILL_SEARCHING_FOR_ONE
        
    WE_GOT_A_WINNER:
        MOVE.W #$EEEE,BOOL_WINNER
        BRA FIN_DE_LA_RECHERCHE
    STILL_SEARCHING_FOR_ONE:
        MOVE.W #$AAAA,BOOL_WINNER
    FIN_DE_LA_RECHERCHE:    
        RTS



CHECK_FOR_VALID_INPUT:    
    MOVE.L #GRILLE,A3
    ADD.W A6,A3
    CMP.B #$58,(A3)
    BNE KEEP_CHECKING_VALID_INPUT
    MOVE.W #0,VALID_INPUT
    BRA END_OF_CHEKING_VALID_INPUT
KEEP_CHECKING_VALID_INPUT:
    CMP.B #$4F,(A3)
    BNE END_OF_CHEKING_VALID_INPUT
    MOVE.W #0,VALID_INPUT
    BRA END_OF_CHEKING_VALID_INPUT
END_OF_CHEKING_VALID_INPUT:
    MOVE.L #GRILLE,A3
    CMP.W #1,VALID_INPUT
    RTS




VERIFIER_SI_MATCH_NUL:
    CLR.L D2
    CLR.L D4
    BOUCLE_DU_MATCH_NUL: 
        MOVE.L #GRILLE,A3
        ADD.L D2,A3
        CMP.L #9,D2
        BEQ END_OF_BOUCLE_DU_MATCH_NUL
        CMP.B #10,(A3)  ( si D2 < 10 : càd que ce n'est ni $58 ni $4F donc la grille n'est pas encore totalement remplie )
        BLT SUITE
        ADD.L #1,D2
        BRA BOUCLE_DU_MATCH_NUL
    SUITE: 
        MOVE.L #1,D4
    END_OF_BOUCLE_DU_MATCH_NUL:
        CMP.L #1,D4
        RTS



RALENTIR_LA_MACHINE:
    
    CMP.L #$0001FFFF,RALENTIR_VAR
    BEQ FIN_RALENTISSEMENT
    ADD.L #$1,RALENTIR_VAR
    BRA RALENTIR_LA_MACHINE
HERE:
    SUB.L #199,RALENTIR_VAR
    BRA RALENTIR_LA_MACHINE    
FIN_RALENTISSEMENT    
    MOVE.L #0,RALENTIR_VAR
    RTS






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
