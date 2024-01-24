
* LE SIGNE DU GAGNANT ON LE MET DANS D4/ LE BLOC GAGNANT DANS D5
VERFIER_DIAGONALES:
    PREMIERE_DIAGONALE:
        ADD.L #$4,A0
        MOVE.L A0,A1
        SUB.L #$4,A0
        
        MOVE.B (A0),D0
        MOVE.B (A1),D1
        
        CMP.B D0,D1
        BNE SORTIE_PREMIERE_DIAGONALE
        ADD.L #$4,A1
        MOVE.L A1,A2
        SUB.L #$4,A1
        
        MOVE.B (A2),D2
        CMP.B D1,D2
        BNE SORTIE_PREMIERE_DIAGONALE
        
        MOVE.W #$1,(A6)
    SORTIE_PREMIERE_DIAGONALE:
        CMP.W #$1,(A6)
        BNE SECOND_DIAGONALE
        *si on est là ; ça veut dire que il y a un gagnant ( premiere diagonale ) ; il reste à savoir c'est qui ?
        CMP.B #$58,D2
        BNE player_2_won_diag_1
        BEQ player_1_won_diag_1
    player_1_won_diag_1:
        MOVE.L #$58,D4
        BRA FIN_DIAGONALE 
    player_2_won_diag_1:    
        MOVE.L #$4F,D4
        BRA FIN_DIAGONALE
        
    * ************************************************************************************************************************************************************************************ *    

    SECOND_DIAGONALE:
        MOVE.W #$0,(A6)
        
        *registre de données qui vont nous servir à faire des comparaisons CMP...
        MOVE.L #$0,D0
        MOVE.L #$0,D1
        MOVE.L #$0,D2 
        
        MOVE.L #grille,A0
        ADD.L #$2,A0
        
        ADD.L #$2,A0
        MOVE.L A0,A1
        SUB.L #$2,A0
        
        MOVE.B (A0),D0
        MOVE.B (A1),D1
        
        CMP.B D0,D1
        BNE SORTIE_SECOND_DIAGONALE
        ADD.L #$2,A1
        MOVE.L A1,A2
        SUB.L #$2,A1
        
        MOVE.B (A2),D2
        CMP.B D1,D2
        BNE SORTIE_SECOND_DIAGONALE
        
        MOVE.W #$1,(A6)
    SORTIE_SECOND_DIAGONALE:
        CMP.W #$1,(A6)
        BNE DIAGONALES_PERDANTES * si on branche ça ; ça veut dire que les deux diagonale sont perdantes !!
        *si on est là ; ça veut dire que il y a un gagnant ( deuxiéme diagonale ) ; il reste à savoir c'est qui ?
        CMP.B #$58,D2
        BNE player_2_won_diag_2
        BEQ player_1_won_diag_2
    player_1_won_diag_2:
        MOVE.L #$58,D4
        BRA FIN_DIAGONALE 
    player_2_won_diag_2:    
        MOVE.L #$4F,D4
        BRA FIN_DIAGONALE    
    DIAGONALES_PERDANTES:
        MOVE.L #$BAD,D4    
    FIN_DIAGONALE:
    RTS    

* ************************************************************************************************************************************************************************************ *   
VERIFIER_LIGNE:
    WHILE_EXTERIEUR_LIGNE:
        *registre de données qui vont nous servir à faire des comparaisons CMP...
        MOVE.L #$0,D0
        MOVE.L #$0,D1
        MOVE.L #$0,D2 
    
        * toujours initialisé le pointeur A0 au début .
        MOVE.L A4,A0
        * la ligne en dessous sert juste à déplacer mon pointeur A0 vers la ligne i + 1 .(si la ligne précedente était non gagnate)
        ADD.W (A5),A0
   
        *on compare le compteur " ligne_suivant " avec 9 ; ça si ce dernier est égale à neuf ça veut dire que toutes les lignes sont perdantes .
        CMP.W #$9,(A5)
        BEQ FIN_WHILE_EXTERIEUR_LIGNE
    
    WHILE_INTERIEUR_LIGNE:
        *les 3 lignes qui suivent cette ligne servent à pointer la valeur de la case [X][1] { X : un indice de ligne }. .
        ADD.L #$1, A0
        MOVE.L A0, A1
        SUB.L #$1, A0
    
        MOVE.B (A0),D0
        MOVE.B (A1),D1
        CMP.B D1,D0
        BNE FIN_WHILE_INTERIEUR_LIGNE
    
        *les 3 lignes qui suivent cette ligne servent à pointer la valeur de la case [X][2] .
        ADD.L #$1, A1
        MOVE.L A1,A2
        SUB.L #$1,A1
    
    
        MOVE.B (A2),D2
        CMP.B D1,D2
        BNE FIN_WHILE_INTERIEUR_LIGNE 
        * si on est la c'est que c'est gagné;
        *donc on va mettre 'UN{1}' dans notre drapeau (flag).
        MOVE.W #$1,(A6)
    
    FIN_WHILE_INTERIEUR_LIGNE: 
        CMP.W #$1,(A6)
        BEQ PLAYER_VICTORY_LIGNE
        * si on est là ; ça veut dire que la ligne n'est pas gagnante ; donc on passe à la ligner suivante !
        ADD.W #$3,(A5)
        BRA WHILE_EXTERIEUR_LIGNE
    PLAYER_VICTORY_LIGNE:
        * si on est là ; ça veut dire que : (A6) = 1 ; une colonne est gagnante ; il reste à savoir qui à gagner ...
        * supposons que aprés dans le code on implémente cette logique :
        * player_1 : représenté par des $58 et player_2 : représenté par $4F
        CMP.B #$58,D2
        BNE player_2_won_ligne
        BEQ player_1_won_ligne
    *just for the sake of clarification .    
    player_1_won_ligne:
        MOVE.L #$58,D4
        BRA FIN_LIGNES
    player_2_won_ligne:
        MOVE.L #$4F,D4
        BRA FIN_LIGNES
    FIN_WHILE_EXTERIEUR_LIGNE:
        MOVE.L #$BAD,D4
    FIN_LIGNES:
    RTS    
    
* ************************************************************************************************************************************************************************************ *       
VERIFIER_COLONNE:
    WHILE_EXTERIEUR_COLONNE:
        *registre de données qui vont nous servir à faire des comparaisons CMP...
        MOVE.L #$0,D0
        MOVE.L #$0,D1
        MOVE.L #$0,D2  
    
        MOVE.L #grille, A0
        * la ligne en dessous sert juste à déplacer mon pointeur A0 vers la colonne j + 1 .(si la colonne précedente était non gagnate)
        ADD.W (A5),A0

        *on compare le compteur "colonne_suivante" avec 3; ça si ce dernier est égale à neuf ça veut dire que toutes les colonnes sont perdantes .
        CMP.W #$3,(A5)
        BEQ FIN_WHILE_EXTERIEUR_COLONNE
        
    WHILE_INTERIEUR_COLONNE:
        *les 3 lignes qui suivent cette ligne servent à pointer la valeur de la case [1][X] { X : n'importe quelle colonne }.
        ADD.L #$3, A0
        MOVE.L A0, A1
        SUB.L #$3, A0
    
        MOVE.B (A0),D0
        MOVE.B (A1),D1
        CMP.B D1,D0
    
        BNE FIN_WHILE_INTERIEUR_COLONNE
        *les 3 lignes qui suivent cette ligne servent à pointer la valeur de la case [2][X]  { X : n'importe quelle colonne }.
        ADD.L #$3, A1
        MOVE.L A1,A2
        SUB.L #$3,A1
    
        MOVE.B (A2),D2
    
        CMP.B D1,D2
        BNE FIN_WHILE_INTERIEUR_COLONNE 
        * si on est la c'est que c'est gagné;
        *donc on va mettre UN dans notre drapeau (flag).
        MOVE.W #1,(A6)
    
    FIN_WHILE_INTERIEUR_COLONNE:
        CMP.W #$1,(A6)
        BEQ PLAYER_VICTORY_COLONNE
        * si on est là ; ça veut dire que la ligne n'est pas gagnante ; donc on passe à la ligner suivante !
        ADD.W #$1,(A5)
        BRA WHILE_EXTERIEUR_COLONNE
    PLAYER_VICTORY_COLONNE:
        * si on est là ; ça veut dire que : (A6) = 1 ; une colonne est gagnante ; il reste à savoir qui à gagner ...
        * supposons que aprés dans le code on impémente cette logique :
        * player_1 : représenté par des $58 et player_2 : représenté par $4F
        CMP.B #$58,D2
        BNE player_2_won_colonne
        BEQ player_1_won_colonne
    *just for the sake of clarification .    
    player_1_won_colonne:
        MOVE.L #$58,D4
        BRA FIN_COLONNES
    player_2_won_colonne:
        MOVE.L #$4F,D4
        BRA FIN_COLONNES
    FIN_WHILE_EXTERIEUR_COLONNE:
        MOVE.L #$BAD,D4
    FIN_COLONNES:
    RTS

********************************************************************************************************************************************************************************************

RESET: 
    MOVE.L #GRILLE,A3
    MOVE.W #1,TEMP
    BOUCLE_RESET:
            CMP.W #10,TEMP
            BEQ FIN_BOUCLE_RESET
            MOVE.W TEMP,D7 
            MOVE.B D7,(A3)
            ADD.W #1,A3
            ADD.W #1,TEMP
            BRA BOUCLE_RESET
    FIN_BOUCLE_RESET:
    RTS















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
