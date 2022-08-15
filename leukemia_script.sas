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


/*Changement etiquette des donnees (optionnel)*/
data remission;
set remission;
label logWBC="quantite globules blancs" rx="groupes(controle=1 traitement=0)" sex="sexe(homme=1 femme=0)"
status="statut(rechute=1 censure=0)" time="duree remission avant rechute(semaines)";
run;

proc contents data=remission;	*resultat du changement;
run;


/*Affichage des donnees de survie*/
proc print data=remission (obs=5);
run;


/* Etape 1 : Estimation non parametrique : modele de K-M*/

proc lifetest data=remission method=KM conftype=linear plots=(h);
time time*status(0);
run;

/*Remarque : pour avoir la courbe de survie sans les stats = ajouter l'option noprint*/

proc lifetest noprint data=remission method=KM;
time time*status(0) ;
run;

/*Remarque : avoir les stats sans la courbe de survie = remplacer noprint par notable*/

proc lifetest notable data=remission method=KM;
time time*status(0);
run;

/*Etape 2 : Estimation non parametrique : modele actuariel*/

proc lifetest data=remission method=act;
time time*status(0);
run;


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
time survie*statut(0) ;
strata LWBC2;
run;

/*Estimation non parametrique avec l'appartenance au groupe de controle et du niveau de globules blancs*/

/*Etape 1 : creer un sous-groupe des individus avec un niveau faible de globules blancs*/
data lowbc;
set remission;
where LWBC2 = 0;
run;

proc lifetest data=lowbc method=KM;
time survie*statut(0);
strata RX;
run;

/*Autre maniere de proceder*/
proc lifetest data=remission method=KM;
time survie*statut(0);
strata RX; where LWBC2=0;
run;
*on remarque que parmi les 22 patients ayant un niveau faible de globules blancs, 14 font partie du groupe de traitement et 8 du groupe de controle.
on voit aussi qu'il y a une difference significative entre le GT et le GC;

/*Etape 2 : creer un sous-groupe des individus avec un niveau eleve de globules blancs*/
data highbc;
set remission;
where LWBC2 = 1;
run;

proc lifetest data=highbc method=KM;
time survie*statut(0) ;
strata RX;
run;

/*Autre maniere de proceder*/
proc lifetest data=remission method=KM;
time survie*statut(0);
strata RX; where LWBC2=1;
run;
*on remarque que parmi les 20 patients ayant un niveau faible de globules blancs, 7 font partie du groupe de traitement et 13 du groupe de controle.
6 sur 7 ont echoue dans le GT alors que 13 sur 13 ont echoue dans le GC. L'analyse du graphique et du test de moyenne montre que la difference observe entre GT et GC n'est pas significative;


/*TEST DE VALIDITE DE L'HYPOTHESE DE RISQUES PROPORTIONNELS CONSTANTS : METHODE GRAPHIQUE*/

/*Avec le facteur explicatif : sexe*/

/*Etape 1 : creer un fichier temporaire (testsex) qui contient les variables ID, SURVIE, STATUT et SEXE*/

data testsex;
set remission;
keep id survie statut sexe;
run;

/*Etape 2 : estimation non parametrique avec option de sortie (OUTSURV) d'un fichier avec les probabilites de survie estimes*/

proc lifetest data=testsex outsurv=toto noprint;
time survie*statut(0) ;
strata sexe;
run;

/*Affichage des donnees*/
proc print data=toto;
run;

/*Etape 3 : calcul de la double transformation en log des probabilites de survie estimees*/

data testsex;
set toto;
LLS=LOG(-LOG(SURVIVAL));
run;

proc print data=testsex (obs=10);
run;

/*Etape 4 : representation graphique des courbes de survie estimees apres transformation en 2LOG*/

proc gplot data=testsex;
plot LLS*survie=sexe;
run;

/*Avec le facteur explicatif : rx*/

/*Etape 1 : creer un fichier temporaire (textrx) qui contient les variables ID, SURVIE, STATUS, RX*/
data testrx;
set remission;
keep id survie statut rx;
run;

/*Etape 2 : estimation non parametrique avec option de sortie (OUTSURV) d'un fichier avec les probabilites de survie estimees*/
proc lifetest data=testrx outsurv=toto noprint;
time survie*statut(0) ;
strata rx;
run;

/*Etape 3 : calcul de la double transformation en log des probabilites de survie estimees*/
data testrx;
set toto;
LLS=LOG(-LOG(SURVIVAL));
run;

/*Etape 4 : representation graphique des courbes de survie estimees apres transformation en 2LOG*/
proc gplot data=testrx;
plot LLS*survie=rx;
run;

/*Avec le facteur explicatif : LWBC2*/

/*Etape 1 : creer un fichier temporaire (text_lwbc2) qui contient les variables ID, SURVIE, STATUS, LWBC2*/
data test_lwbc2;
set remission;
keep id survie statut lwbc2;
run;

/*Etape 2 : estimation non parametrique avec option de sortie (OUTSURV) d'un fichier avec les probabilites de survie estimees*/
proc lifetest data=test_lwbc2 outsurv=toto noprint;
time survie*statut(0) ;
strata lwbc2;
run;

/*Etape 3 : calcul de la double transformation en log des probabilit?s de survie estim?es*/
data test_lwbc2;
set toto;
LLS=LOG(-LOG(SURVIVAL));
run;

/*Etape 4 : repr?sentation graphique des courbes de survie estim?es apr?s transformation en 2LOG*/
proc gplot data=test_lwbc2;
plot LLS*survie=lwbc2;
run;



/*TEST DE VALIDITE DE L'HYPOTHESE DE RISQUES PROPORTIONNELS CONSTANTS : METHODE ANALYTIQUE*/

/*Avec le facteur explicatif : rx*/

/*Etape 1 : estimation semi-parametrique et sauvegarde des residus*/

proc phreg data=remission noprint;
model survie*statut(0)=rx;
output out=resid ressch=Rrx; *ressch permet d'avoir les r�sidus Schoenfeld;
run;

proc print data=resid;
run;


/*Etape 2 : creer un sous-echantillon sans donnees censurees*/

data test_resid;
set resid;
if statut=1;
run;

proc print data=test_resid;
run;


/*Etape 3 : creer un sous-echantillon avec une variable qui classe les temps de realisation decrits par la variable var(duree)*/
proc rank data=test_resid out=resid_rank ties=mean;
var survie;
ranks ordre;
run;

proc print data=resid_rank;
run;


/*Etape 4 : tester de la correlation entre les residus et le classement des temps de realisation (timerank)*/
proc corr data=resid_rank nosimple;
var Rrx;
with ordre;
run;



/*Avec le facteur explicatif : sexe*/

/*Etape 1 : estimation semi-parametrique et sauvegarde des residus*/

proc phreg data=remission noprint;
model survie*statut(0)=sexe;
output out=resid ressch=Rsexe;
run;

proc print data=resid;
run;


/*Etape 2 : creer un sous-echantillon sans donnees censurees*/

data test_resid;
set resid;
if statut=1;
run;

proc print data=test_resid;
run;


/*Etape 3 : creer un sous-echantillon avec une variable qui classe les temps de realisation decrits par la variable var(duree)*/
proc rank data=test_resid out=resid_rank ties=mean;
var survie;
ranks ordre;
run;

proc print data=resid_rank;
run;


/*Etape 4 : tester de la correlation entre les residus et le classement des temps de realisation (timerank)*/
proc corr data=resid_rank nosimple;
var Rsexe;
with ordre;
run;



/*ESTIMATION SEMI-PARAMETRIQUE : MODELE DE COX AVEC FICHIER REMISSION*/ *Ce programme permet de lancer l'estimation semi-parametrique;
proc phreg data=remission;
model survie*statut(0) = rx /rl; *rl est l'option qui permet d'ajouter des intervalles de confiance;
run;							 *rx mesure l'effet d'appartenir au groupe de traitement, quel effet ca a sur le risque de survie (ratio de risque);
*les resultats montrent que lorsqu'un individu passe du groupe de traitement (rx=0) au groupe de controle (rx=1), il a 4.523 plus de chance (ratio de risque) de connaitre la rechute (l'evenement);


proc phreg data=remission;
model survie*statut(0) = rx lwbc /rl; *rl est l'option qui permet d'ajouter des intervalles de confiance;
run;
*suivant ce 2e modele, lorsqu'un individu passe du groupe de traitement (rx=0) au groupe de controle (rx=1), il a 3.648 fois plus de chance de connaitre la rechute (l'evenement),
et lorsque le niveau de globules blancs augmente de 1 unite, l'individu a 4.974 fois plus de chance de connaitre la rechute;

proc means data=remission;
var lwbc;
run;

/*ESTIMATION SEMI-PARAMETRIQUE : MODELE DE COX STRATIFIE*/


/*ESTIMATION SEMI-PARAMETRIQUE : MODELE DE COX AVEC VARIABLES D'INTERACTION*/

/*Etape 1 : creation des variables d'interaction*/

data remission;
set remission;
rx_lwbc = rx * lwbc;
run;

/*Etape 2 : estimation semi-parametrique avec variables d'interaction*/

proc phreg data=remission;
model survie*statut(0) = rx lwbc rx_lwbc /rl; *rl est l'option qui permet d'ajouter des intervalles de confiance;
run;
*On remarque ici que la performance du modele diminue lorsqu'on ajoute la 3e variable rx_lwbc (AIC et SBC augmentent). De plus, la nouvelle variable introduite n'est pas significative.
On n'a donc pas interet a construire un tel modele. Le meilleur modele a retenir est le precedent;
