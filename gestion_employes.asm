# Système de Gestion Simplifié d'une Entreprise en MIPS
# Auteur: EL MEHDI NIDKOUCHI
# Description: Gestion des employés avec ID, nom et salaire

.data
    # Messages du menu
    menu_titre:     .asciiz "\n========== SYSTEME DE GESTION DES EMPLOYES ==========\n"
    menu_1:         .asciiz "1. Afficher la liste des employes\n"
    menu_2:         .asciiz "2. Rechercher un employe par identifiant\n"
    menu_3:         .asciiz "3. Calculer et afficher le salaire Min et Max\n"
    menu_4:         .asciiz "4. Calculer et afficher le salaire moyen\n"
    menu_5:         .asciiz "5. Nombre d'employes au-dessus du salaire moyen\n"
    menu_6:         .asciiz "6. Calculer la masse salariale de l'entreprise\n"
    menu_7:         .asciiz "7. Quitter\n"
    menu_choix:     .asciiz "Entrez votre choix (1-7): "
    
    # Messages d'affichage
    msg_id:         .asciiz "ID: "
    msg_nom:        .asciiz ", Nom: "
    msg_salaire:    .asciiz ", Salaire: "
    msg_dh:         .asciiz " DH\n"
    msg_newline:    .asciiz "\n"
    msg_tiret:      .asciiz "-----------------------------------------------------\n"
    
    # Messages pour recherche
    msg_rech_id:    .asciiz "Entrez l'ID de l'employe a rechercher: "
    msg_trouve:     .asciiz "Employe trouve:\n"
    msg_non_trouve: .asciiz "Employe non trouve!\n"
    
    # Messages pour statistiques
    msg_sal_min:    .asciiz "Salaire minimum: "
    msg_sal_max:    .asciiz " DH\nSalaire maximum: "
    msg_sal_moy:    .asciiz "Salaire moyen: "
    msg_nb_sup_moy: .asciiz "Nombre d'employes avec salaire superieur au salaire moyen: "
    msg_masse_sal:  .asciiz "Masse salariale totale: "
    
    msg_aurevoir:   .asciiz "Au revoir! Programme termine.\n"
    msg_invalide:   .asciiz "Choix invalide! Veuillez reessayer.\n"
    
    # Données des employés (ID, Salaire) - Noms séparés
    # Format: nombre d'employés, puis pour chaque employé: ID, salaire
    nb_employes:    .word 5
    
    # Tableau des IDs
    employe_ids:    .word 101, 102, 103, 104, 105
    
    # Tableau des salaires
    employe_salaires: .word 4500, 6000, 3500, 7500, 5000
    
    # Noms des employés (chaînes de 20 caractères max)
    employe_noms:
        .asciiz "Ahmed Alami      "
        .asciiz "Fatima Bennani   "
        .asciiz "Mohamed Tazi     "
        .asciiz "Khadija Fassi    "
        .asciiz "Youssef Idrissi  "
    
    taille_nom:     .word 20  # Taille fixe pour chaque nom

.text
.globl main

main:
    # Boucle principale du programme
menu_principal:
    # Afficher le menu
    li $v0, 4
    la $a0, menu_titre
    syscall
    
    la $a0, menu_1
    syscall
    la $a0, menu_2
    syscall
    la $a0, menu_3
    syscall
    la $a0, menu_4
    syscall
    la $a0, menu_5
    syscall
    la $a0, menu_6
    syscall
    la $a0, menu_7
    syscall
    la $a0, msg_tiret
    syscall
    la $a0, menu_choix
    syscall
    
    # Lire le choix
    li $v0, 5
    syscall
    move $t0, $v0
    
    # Traiter le choix
    beq $t0, 1, afficher_liste
    beq $t0, 2, rechercher_employe
    beq $t0, 3, calculer_min_max
    beq $t0, 4, calculer_moyenne
    beq $t0, 5, compter_sup_moyenne
    beq $t0, 6, masse_salariale
    beq $t0, 7, quitter
    
    # Choix invalide
    li $v0, 4
    la $a0, msg_invalide
    syscall
    j menu_principal

#----------------------------------------------------------
# Fonction 1: Afficher la liste des employés
#----------------------------------------------------------
afficher_liste:
    li $v0, 4
    la $a0, msg_tiret
    syscall
    
    lw $t0, nb_employes      # Nombre d'employés
    li $t1, 0                # Compteur
    la $t2, employe_ids      # Adresse des IDs
    la $t3, employe_salaires # Adresse des salaires
    la $t4, employe_noms     # Adresse des noms
    lw $t5, taille_nom       # Taille d'un nom

afficher_boucle:
    beq $t1, $t0, afficher_fin
    
    # Afficher ID
    li $v0, 4
    la $a0, msg_id
    syscall
    li $v0, 1
    lw $a0, 0($t2)
    syscall
    
    # Afficher nom
    li $v0, 4
    la $a0, msg_nom
    syscall
    move $a0, $t4
    syscall
    
    # Afficher salaire
    la $a0, msg_salaire
    syscall
    li $v0, 1
    lw $a0, 0($t3)
    syscall
    li $v0, 4
    la $a0, msg_dh
    syscall
    
    # Passer à l'employé suivant
    addi $t2, $t2, 4        # ID suivant
    addi $t3, $t3, 4        # Salaire suivant
    add $t4, $t4, $t5       # Nom suivant
    addi $t1, $t1, 1        # Incrémenter compteur
    j afficher_boucle

afficher_fin:
    j menu_principal

#----------------------------------------------------------
# Fonction 2: Rechercher un employé par ID
#----------------------------------------------------------
rechercher_employe:
    # Demander l'ID
    li $v0, 4
    la $a0, msg_rech_id
    syscall
    li $v0, 5
    syscall
    move $t6, $v0           # ID recherché
    
    lw $t0, nb_employes
    li $t1, 0
    la $t2, employe_ids
    la $t3, employe_salaires
    la $t4, employe_noms
    lw $t5, taille_nom

recherche_boucle:
    beq $t1, $t0, recherche_non_trouve
    
    lw $t7, 0($t2)
    beq $t7, $t6, recherche_trouve
    
    addi $t2, $t2, 4
    addi $t3, $t3, 4
    add $t4, $t4, $t5
    addi $t1, $t1, 1
    j recherche_boucle

recherche_trouve:
    li $v0, 4
    la $a0, msg_trouve
    syscall
    la $a0, msg_id
    syscall
    li $v0, 1
    move $a0, $t6
    syscall
    li $v0, 4
    la $a0, msg_nom
    syscall
    move $a0, $t4
    syscall
    la $a0, msg_salaire
    syscall
    li $v0, 1
    lw $a0, 0($t3)
    syscall
    li $v0, 4
    la $a0, msg_dh
    syscall
    j menu_principal

recherche_non_trouve:
    li $v0, 4
    la $a0, msg_non_trouve
    syscall
    j menu_principal

#----------------------------------------------------------
# Fonction 3: Calculer salaire Min et Max
#----------------------------------------------------------
calculer_min_max:
    lw $t0, nb_employes
    la $t1, employe_salaires
    lw $t2, 0($t1)          # Premier salaire = min initial
    move $t3, $t2           # Premier salaire = max initial
    li $t4, 1               # Commencer à partir du 2ème

minmax_boucle:
    beq $t4, $t0, minmax_afficher
    
    addi $t1, $t1, 4
    lw $t5, 0($t1)
    
    # Vérifier min
    blt $t5, $t2, minmax_nouveau_min
    j minmax_check_max
    
minmax_nouveau_min:
    move $t2, $t5

minmax_check_max:
    # Vérifier max
    bgt $t5, $t3, minmax_nouveau_max
    j minmax_continue
    
minmax_nouveau_max:
    move $t3, $t5

minmax_continue:
    addi $t4, $t4, 1
    j minmax_boucle

minmax_afficher:
    li $v0, 4
    la $a0, msg_sal_min
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, msg_sal_max
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, msg_dh
    syscall
    j menu_principal

#----------------------------------------------------------
# Fonction 4: Calculer le salaire moyen
#----------------------------------------------------------
calculer_moyenne:
    lw $t0, nb_employes
    la $t1, employe_salaires
    li $t2, 0               # Somme
    li $t3, 0               # Compteur

moyenne_boucle:
    beq $t3, $t0, moyenne_calculer
    
    lw $t4, 0($t1)
    add $t2, $t2, $t4
    addi $t1, $t1, 4
    addi $t3, $t3, 1
    j moyenne_boucle

moyenne_calculer:
    div $t2, $t0
    mflo $t5               # Moyenne
    
    li $v0, 4
    la $a0, msg_sal_moy
    syscall
    li $v0, 1
    move $a0, $t5
    syscall
    li $v0, 4
    la $a0, msg_dh
    syscall
    j menu_principal

#----------------------------------------------------------
# Fonction 5: Compter employés au-dessus de la moyenne
#----------------------------------------------------------
compter_sup_moyenne:
    # Calculer d'abord la moyenne
    lw $t0, nb_employes
    la $t1, employe_salaires
    li $t2, 0               # Somme
    li $t3, 0               # Compteur

sup_moy_calc_moyenne:
    beq $t3, $t0, sup_moy_compter
    
    lw $t4, 0($t1)
    add $t2, $t2, $t4
    addi $t1, $t1, 4
    addi $t3, $t3, 1
    j sup_moy_calc_moyenne

sup_moy_compter:
    div $t2, $t0
    mflo $t5               # Moyenne
    
    # Compter ceux au-dessus de la moyenne
    la $t1, employe_salaires
    li $t3, 0               # Compteur
    li $t6, 0               # Nombre au-dessus

sup_moy_boucle:
    beq $t3, $t0, sup_moy_afficher
    
    lw $t4, 0($t1)
    bgt $t4, $t5, sup_moy_incrementer
    j sup_moy_continue

sup_moy_incrementer:
    addi $t6, $t6, 1

sup_moy_continue:
    addi $t1, $t1, 4
    addi $t3, $t3, 1
    j sup_moy_boucle

sup_moy_afficher:
    li $v0, 4
    la $a0, msg_nb_sup_moy
    syscall
    li $v0, 1
    move $a0, $t6
    syscall
    li $v0, 4
    la $a0, msg_newline
    syscall
    j menu_principal

#----------------------------------------------------------
# Fonction 6: Calculer la masse salariale
#----------------------------------------------------------
masse_salariale:
    lw $t0, nb_employes
    la $t1, employe_salaires
    li $t2, 0               # Somme totale
    li $t3, 0               # Compteur

masse_boucle:
    beq $t3, $t0, masse_afficher
    
    lw $t4, 0($t1)
    add $t2, $t2, $t4
    addi $t1, $t1, 4
    addi $t3, $t3, 1
    j masse_boucle

masse_afficher:
    li $v0, 4
    la $a0, msg_masse_sal
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, msg_dh
    syscall
    j menu_principal

#----------------------------------------------------------
# Fonction 7: Quitter le programme
#----------------------------------------------------------
quitter:
    li $v0, 4
    la $a0, msg_aurevoir
    syscall
    li $v0, 10
    syscall
