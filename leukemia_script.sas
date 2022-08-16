/*Designation de la librairie*/
libname tp 'C:\Users\user\Desktop\github\cancer-treatment-effect\data';

/*Chargement de la base de données*/
data remission;
set tp.leukemia;
run;

/*Affichage du contenu de la base de donnees*/
proc contents data = remission;
run;
proc print data = remission (obs=5);
run;


/* Estimation non parametrique : modele de K-M*/
proc lifetest data=remission method=KM conftype=linear plots=(h);
time time*status(0);
run;
/*Remarque : pour avoir la courbe de survie sans les stats, ajouter l'option noprint
/*Remarque : pour avoir les stats sans la courbe de survie, remplacer noprint par notable*/


/*TESTS DE COMPARAISON*/

/*Estimation non parametrique avec le sexe comme variable categorielle*/
proc lifetest data=remission method=KM;
time time*status(0);
strata sex;
run;
*En observant le graphique, on remarque autour de 11 semaine qu'il y a un changement de tendance dans les fonctions de survie des deux groupes (H et F).
le temps de survie des femmes qui etait plus eleve au depart est rendu plus faible par rapport a celui des hommes apres environ 11 semaines;

/*Estimation non parametrique avec RX comme variable categorielle*/
proc lifetest data=remission method=KM;
time time*status(0);
strata rx;
run;

/*Statistiques descriptive sur la quantite de globules blancs*/
proc univariate data=remission;
var logWBC;
run;
*La mediane est 2.8, donc on considerera cette valeur pour distinguer les individus a quantite de globules blancs eleve (LWBC > 2.8) versus ceux avec un faible niveau de globules blancs (LWBC < ou = 2.8);

/*Transformation d'une variable discrete en variable continue*/
data remission;
set remission;
LWBC = .;
if logWBC > 2.8 then LWBC = 1;
else LWBC = 0;
run;

/*Affichage de la nouvelle variable cree*/
proc print data=remission;
var logWBC LWBC;
run;

/*Estimation non parametrique avec le niveau de globules blancs comme variable categorielle*/
proc lifetest data=remission method=KM;
time time*status(0) ;
strata LWBC;
run;


/*ESTIMATION SEMI-PARAMETRIQUE : MODELE DE COX STRATIFIE*/


/*ESTIMATION SEMI-PARAMETRIQUE : MODELE DE COX AVEC VARIABLES D'INTERACTION*/

/*Etape 1 : creation de la variable d'interaction*/

data remission;
set remission;
rx_logwbc = rx * logWBC;
label rx_logwbc = 'interaction variable';
run;

/*Etape 2 : estimation semi-parametrique avec variables d'interaction*/

proc phreg data=remission;
model time*status(0) = rx logWBC rx_logwbc /rl; *rl est l'option qui permet d'ajouter des intervalles de confiance;
run;
*On remarque que la variable d'interaction n'est pas significative. On n'a donc pas interet a construire un tel modele;

/*Etape 3 : estimation semi-parametrique sans variables d'interaction*/

proc phreg data=remission;
model time*status(0) = rx logWBC /rl;
run;


/*POUR ALLER PLUS LOIN*/

/*Verification de l'effet du traitement dans le groupe avec un faible taux de globule blancs*/
proc lifetest data=remission method=KM noprint;
time time*status(0);
strata rx; where LWBC=0;
title 'Effet du traitement chez les patients à faible quantité de globules blancs [<exp(2.8)]';
run;

/*Verification de l'effet du traitement dans le groupe avec un taux élevé de globule blancs*/
proc lifetest data=remission method=KM noprint;
time time*status(0);
strata rx; where LWBC=1;
title 'Effet du traitement chez les patients à quantité élevée de globules blancs [>exp(2.8)]';
run;
