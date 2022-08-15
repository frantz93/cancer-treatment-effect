# Cancer Treatment Effect #
### Assessing the effacy of a leukemia treatment on the lifespan of patients (survival analysis) / Evaluation de l'efficacité d'un traitement contre la leucémie sur la durée de vie des patients (analyse de survie) <br />
Cette étude illustre les contributions que je suis en mesure d'apporter au sein des entreprises du secteur médical.
- - - -
<br />

__CONTEXTE__ <br />
Les entreprises du secteur médical (pharmacie, hôpitaux,...) sont souvent appelées à réaliser des recherches expérimentales pour vérifier l'efficacité des traitements contre les maladies. En général, les traitements administrés peuvent s'attaquer à la cause de la maladie (traitement de la cause) ou simplement viser à soulager l'individu des effets perturbateurs (traitement symptomatique). Les traitements impliquent, entre autres : _les médicaments, la chirurgie, la radiothérapie, la chimiothérapie, la kinésithérapie etc._ Je traiterai ici de l'expérimentation d'un traitement médicamenteux contre le cancer du sang (leucémie). L'objectif est d'analyser l'efficacité de ce traitement suivant deux caractéristiques individuelles soit le sexe et la quantité de leucocytes sanguins. <br />
<br />
__METHODES__ <br />
L'efficacité du traitement est mesurée ici comme sa capacité à arrêter ou retarder la rechute du malade (réaparition des symptomes). Notre variable d'intérêt est donc la durée de remission du patient à partir de l'administration du traitement et jusqu'à la rechute. Par conséquent, nous allons faire appel aux méthodes statistiques de modélisation du temps pour aboutir à des résultats concluants. Il s'agit des méthodes utilisées en __analyse de survie__ ou __analyse de durée de vie__. Nous utiliserons le modèle de Kaplan Meier et le modèle de Cox pour explorer et modéliser les données. Les commandes seront exécuter sur __SAS__ mais il est également possible de réaliser l'analyse sur d'autres logiciels tels que R, Phyton, Stata ou SPSS. <br />
<br />
__DONNEES__ <br />
Les données sont issues des publications de [Kleinbaum & Klein (2012)](https://link.springer.com/book/10.1007/0-387-29150-4 "Kleinbaum, D.G. and Klein, M. (2012) Survival Analysis - A Self-Learning Text, 3rd ed., Springer") contenues dans le fichier `leukemia.sas7bdat` du répertoire `data`. Les versions `.rda` et `.csv` de la base figurent également dans ledit répertoire pour faciliter l'analyse éventuellement sur d'autre logiciel. Ci-dessous, nous décrivons les différentes variables présentes dans la base.
* ___time___
    Temps de survie (en semaines)
* ___status___
    Statut de la censure : 1=rechute, 0=censure (absence de l'événement)
* ___sex___
    Sexe du patient : 0=Femme 1=Homme
* ___logWBC___
    Logarithme de la quantité de leucocytes (globules blancs) dans le sang
* ___rx___
    Groupe d'appartenance : 1=Contrôle 0 =Traitement <br /> <br />

__RESULTATS__ <br />
Tout d'abord, nous allons visualiser les données de la base. Nous exécutons les commandes ci-dessous. La première commande permet de définir le chemin d'accès du fichier contenant la base de données. Notre fichier est contenu ici dans le répertoire `data` qui est à son tour dans le dossier `cancer-treatment-effect` du répertoire `github` sur le bureau de notre ordinateur. Vous devez donc changer le chemin suivant l'endroit où vous avez enregistré la base de données. Une fois la librairie définie, la deuxième commande permet de charger la base de données sous le nom de `remission`, et les deux dernières commandes affichent les propriétés de la base.
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
Les premiers résultats affichés ci-dessous confirme que

![out1](/ouput/img/out1.jpg)


<br /> <br /> <br />

****** _Rédaction en cours_ ******
