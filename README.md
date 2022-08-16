# Cancer Treatment Effect #
### Assessing the efficacy of a leukemia treatment for expanding the remission time of patients (survival analysis) / Evaluation de l'efficacité d'un traitement contre la leucémie pour prolonger le temps de rémission des patients (analyse de survie) <br />
Cette étude illustre les contributions que je suis en mesure d'apporter au sein des entreprises du secteur médical. :hospital: :pill:
- - - -
<br />

### CONTEXTE <br/>
Les entreprises du secteur médical (pharmacies, hôpitaux,...) sont souvent appelées à réaliser des recherches expérimentales pour vérifier l'efficacité des traitements contre les maladies. En général, les traitements administrés peuvent s'attaquer à la cause de la maladie (traitement curatif) ou simplement viser à soulager l'individu des effets perturbateurs (traitement symptomatique). Les traitements impliquent, entre autres : _les médicaments, la chirurgie, la radiothérapie, la chimiothérapie, la kinésithérapie etc._ Je traiterai ici de l'expérimentation d'un traitement médicamenteux contre le cancer du sang (leucémie). L'objectif est d'analyser l'efficacité de ce traitement en tenant compte des caractéristiques individuelles telles que le sexe et la quantité de leucocytes du plasma sanguin. <br/>
<br/>

### METHODES <br/>
L'efficacité du traitement est mesurée ici comme sa capacité à prolonger la rémission du malade, autrement dit, à arrêter ou retarder la rechute (réaparition des symptômes). Notre variable d'intérêt est donc la durée de rémission du patient à compter du début d'administration du traitement jusqu'à la rechute. Etant donné que la variable d'intérêt est le temps, nous ne pouvons pas utilisé les méthodes statistiques classiques basées sur la loi normale pour étudier ce phénomène. Nous allons faire appel aux méthodes de modélisation du temps pour aboutir à des résultats concluants. Il s'agit des méthodes utilisées en __analyse de survie__ ou __analyse de durée de vie__. Nous utiliserons le modèle de Kaplan Meier (KM) et le modèle de Cox pour explorer et modéliser les données. Les commandes seront exécuter sur __SAS__ mais il est également possible de réaliser l'analyse sur d'autres logiciels tels que R, Phyton, Stata ou SPSS. <br/>
<br/>

### DONNEES <br/>
Les données sont issues des publications de [Kleinbaum & Klein (2012)](https://link.springer.com/book/10.1007/0-387-29150-4 "Kleinbaum, D.G. and Klein, M. (2012) Survival Analysis - A Self-Learning Text, 3rd ed., Springer") et contenues dans le fichier `leukemia.sas7bdat` du répertoire `data`. Les versions `.rda` et `.csv` de la base figurent également dans ledit répertoire pour faciliter l'analyse éventuellement sur d'autres logiciels. Ci-dessous, nous décrivons les différentes variables présentes dans la base.
* ___time___
    Temps de survie (en semaines)
* ___status___
    Statut de la censure : 1=rechute, 0=censure (absence de l'événement)
* ___sex___
    Sexe du patient : 0=Femme 1=Homme
* ___logWBC___
    Logarithme de la quantité de leucocytes (globules blancs) dans le sang
* ___rx___
    Groupe d'appartenance : 1=Contrôle 0 =Traitement <br/> <br/>

### RESULTATS <br/>

__1. Vérification des données__ <br/>
Tout d'abord, nous allons visualiser les données de la base. Nous exécutons les commandes ci-dessous. La première commande permet de définir le chemin d'accès du fichier contenant la base de données. Notre fichier est contenu ici dans le répertoire `data` qui est à son tour dans le dossier `cancer-treatment-effect` du répertoire `github` sur le bureau de notre ordinateur. Vous devez donc changer le chemin suivant l'endroit où vous avez enregistré la base de données. Une fois la librairie définie, la deuxième commande permet de charger la base de données sous le nom de `remission`, et les deux dernières commandes affichent les propriétés de la base. Les premiers résultats sont affichés ci-dessous. Le premier tableau (à gauche) confirme qu'il y a 42 observations et 5 variables dans la base. Le deuxième (à droite) présente le nom et une courte description des variables. Et au dernier tableau, nous avons un aperçu des cinq premières observations. Nous voyons que les premiers patients de la liste sont de sexe masculin et ont des taux variables de globules blancs, ils font partie du groupe de traitement et n'ont pas connu la rechute pendant l'expérience.

`````
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
`````
<p align="center">
<img src="https://user-images.githubusercontent.com/105858731/184566849-952f1283-5211-4650-ad8c-c66e5c4239d4.png" width="400" height="220">
<img src="https://user-images.githubusercontent.com/105858731/184567492-bb5624ab-9a04-44af-898c-88b73737ba17.png" width="400" height="220"> <br/>
<img src="https://user-images.githubusercontent.com/105858731/184568209-556d5c20-6fcf-4932-967c-d2dc6be8cb66.png" width="300" height="150">
</p>

__1. Analyse non paramétrique__ <br/>
Le modèle Kaplan Meier peut être utilisé pour réaliser les estimations sur notre échantillon puisqu'il est petit. Nous estimons ainsi une première courbe de survie dite globale de l'échantillon. Cette courbe nous renseigne sur l'évolution de la probabilité de survie de tous les patients répartis en un seul groupe. La courbe est classique (décroissante dans le temps). Au début de l'expérience, la proportion d'individus qui n'ont pas connu la rechute est de 100% alors qu'elle est réduite à moins de 20% au delà de 23 semaines. Sur les 42 patients, 30 (71.4%) ont connu la rechute pendant l'expérience et les 12 autres ont été censurés. Ce dernier groupe regroupe les patients qui ont terminé l'expérience en état de rémission ou bien ont laissé l'expérience avant la fin. Le temps moyen de survie des patients est de 13 semaines, mais la majorité ont une survie inférieure à la moyenne (mediane < moyenne). Les estimations aux quartiles montrent que 75% des patients sont restés en rémission jusqu'à 23 semaines, 50% jusqu'à 12 semaines et 25% jusqu'à 6 semaines.

`````
/*Estimation non parametrique : modele de K-M*/
proc lifetest data=remission method=KM conftype=linear plots=(h);
time time*status(0);
run;
`````
<p align="center">
<img src="https://user-images.githubusercontent.com/105858731/184570791-c3030ac8-9594-4509-8a1f-a1adaa08f007.png" width="500"> <br/>
<img src="https://user-images.githubusercontent.com/105858731/184573767-a5f541ec-c04a-476b-8ad1-6bb74071536b.png" width="300"> <br/>
<img src="https://user-images.githubusercontent.com/105858731/184572891-311d8dad-b493-4c0b-9c70-0609c9030451.png" width="400">
</p>
<br/>

Décomposons maintenant la courbe de survie suivant les caractéristiques distinctives des patients (sexe, groupe d'appartenance). Les commandes exécutées sur SAS suivies des résultats sont donnés ci-dessous. Le croisement des courbes indique un absence de différence significative entre les groupes. C'est le cas entre les femmes et les hommes qui se comportent de la même manière quant à la durée de survie. Cependant, nous voyons une différence entre les individus appartenant au groupe de traitement et ceux du groupe de contrôle. Les premiers ont un temps de survie plus long comparativement aux seconds.

`````
/*Estimation non parametrique avec le sexe comme variable categorielle*/
proc lifetest data=remission method=KM;
time time*status(0);
strata sex;
run;

proc lifetest data=remission method=KM;
time time*status(0);
strata rx;
run;
`````
<p align="center">
<img src="https://user-images.githubusercontent.com/105858731/184578554-8ac7678c-ca91-4f1e-af70-6167bc646a56.png" width="440">
<img src="https://user-images.githubusercontent.com/105858731/184578692-9ad77eae-1214-4fcf-8205-78eaf5fc2375.png" width="440">
</p>
<br/>

Nous analysons maintenant par rapport à la quantité de globules blancs dans le sang. En examinant la distribution de la variable `logWBC`, nous notons que les patients sont équitablement répartis autour d'un niveau médian de 2.8. Nous pouvons donc décomposer notre échantillon en deux groupes : les patients ayant un niveau élevé de leucocytes (1) et ceux ayant un niveau faible de leucocytes (0). La deuxième commande ci-dessous conduit à créer cette nouvelle variable de calcul dans la base de données. La dernière commande permet ensuite de lancer la procédure d'estimation par le modèle KM et produit la sortie graphique plus bas. Outre l'appartenance aux groupes (traitement vs contrôle), nous remarquons aussi que le taux de globules blancs du sang a un impact sur le temps de survie des individus. En effet, les patients qui ont un taux faibles de globules blancs mettent plus de temps avant la rechute comparé à ceux ayant un taux élevé de globules blancs. 

`````
/*Statistiques descriptive sur la quantite de globules blancs*/
proc univariate data=remission;
var logWBC;
run;

/*Transformation d'une variable discrete en variable continue*/
data remission;
set remission;
logWBC = .;
if logWBC > 2.8 then LWBC = 1;
else LWBC = 0;
run;

/*Estimation non parametrique avec le niveau de globules blancs comme variable categorielle*/
proc lifetest data=remission method=KM;
time time*status(0) ;
strata LWBC;
run;
`````
<p align="center">
<img src="https://user-images.githubusercontent.com/105858731/184580795-75d18fbd-0926-47f0-9cfa-711face52ab4.png" width="500">
</p>
<br/>


__2. Analyse paramétrique__ <br/>
Dans la précédente analyse, nous avons vu que le temps de rémission des patients atteints du cancer est impacté positivement par le traitement médicamenteux proposé. Mais un temps de rémission plus long peut être lié également au fait que le patient a un faible niveau de leucocytes dans le sang. Nous ne pouvons donc être certain de l'impact du traitement qu'en intégrant, dans un modèle, différentes variables explicatives dont le niveau de leucocytes. Cela permettra de vérifier si le traitement améliore effectivement la santé des patients et à quel niveau. Nous utilisons le modèle de Cox de risque proportionnel pour estimer l'équation de la fonction de risque de rechute des patients. L'équation est la suivante : <img src="https://latex.codecogs.com/svg.image?h(t)&space;=&space;h_{0}(t)e^{\beta_{1}*RX&plus;\beta_{2}*logWBC&plus;\beta_{3}*[RX*logWBC]" title="Equation de la fonction de risque" />; avec <img src="https://latex.codecogs.com/svg.image?h_{0}" /> le risque de base commun à tous les patients, <img src="https://latex.codecogs.com/svg.image?\beta_{i}" /> le coefficient de régression de la variable i, et <img src="https://latex.codecogs.com/svg.image?[RX*logWBC]" /> la variable d'intéraction entre le traitement et le niveau de globule blancs dans le sang. L'estimation est réalisée par maximum de vraissemblance en exécutant les commandes ci-dessous. La première commande crée la variable d'interaction dans la base et la seconde estime l'équation de la fonction de risque.

`````
/*Creation de la variable d'interaction*/
data remission;
set remission;
rx_logwbc = rx * logWBC;
label rx_logwbc = 'interaction variable';
run;

/*Estimation semi-parametrique avec variables d'interaction*/
proc phreg data=remission;
model time*status(0) = rx logWBC rx_logwbc /rl; *rl est l'option qui permet d'ajouter des intervalles de confiance;
run;
`````
Le résultat final peut être interprété à partir du tableau ci-dessous. Les noms des variables sont affichés dans la colonne `Paramètre` et les coefficients <img src="https://latex.codecogs.com/svg.image?\beta_{i}" /> dans la colonne `Valeur estimée des paramètres`. La colonne `Pr > Khi-2` donne les p-values du test de significativité sur chaque coefficient du modèle. On constate que seul le coefficient de la variable ___logWBC___ est significatif (α<0.5). Par conséquent, il n'y a que le taux de leucocytes sanguins qui explique véritablement le temps de rémission d'un patient. L'impact de cette variable en termes de ratio de risque figure dans la colonne "Rapport de risque". Lorsque le logarithme de la quantité de leucocytes augmente d'1 unité, l'individu a 6 fois plus de risque de connaitre la rechute. Considérant que le coefficient de la variable ___rx___ n'est pas significatif (α=0.16), l'effet du traitement médicamenteux proposé ne s'avère pas concluant à la lumière du modèle. Donc malheureusement, ce traitement anticancéreux ne peut pas être recommandé aux malades pour lutter contre la rechute.
<p align="center"> <img src='https://user-images.githubusercontent.com/105858731/184936992-0d6ff1a9-996e-4461-b690-24f9a0c1effe.png' width='1000'/> </p> </br>

<br /> <br /> <br />

<p align='center'> ********************************************** ©FRPDJ - 16/08/2022 ************************************************* </p>
