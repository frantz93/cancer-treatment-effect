# Cancer Treatment Effect #
### Assessing the effacy of a leukemia treatment on the lifespan of patients (survival analysis) / Evaluation de l'efficacité d'un traitement contre la leucémie sur la durée de vie des patients (analyse de survie) <br />
Cette étude illustre les contributions que je suis en mesure d'apporter au sein des entreprises du secteur médical.
- - - -
<br />

__CONTEXTE__ <br />
Les entreprises du secteur médical (pharmacie, hôpitaux,...) sont souvent appelées à réaliser des recherches expérimentales pour vérifier l'efficacité des traitements contre les maladies. En général, les traitements administrés peuvent s'attaquer à la cause de la maladie (traitement de la cause) ou simplement viser à soulager l'individu des effets perturbateurs (traitement symptomatique). Les traitements impliquent, entre autres : _les médicaments, la chirurgie, la radiothérapie, la chimiothérapie, la kinésithérapie etc._ Je traiterai ici de l'expérimentation d'un traitement médicamenteux contre le cancer du sang (leucémie). L'objectif est d'analyser l'efficacité de ce traitement suivant deux caractéristiques individuelles soit le sexe et la quantité de leucocytes sanguins. <br />
<br />
__METHODES__ <br />
L'efficacité du traitement est mesurée ici comme sa capacité à arrêter ou retarder la rechute du malade (réaparition des symptomes). Notre variable d'intérêt est donc la durée de remission du patient à partir de l'administration du traitement et jusqu'à la rechute. Par conséquent, nous allons faire appel aux méthodes statistiques de modélisation du temps pour aboutir à des résultats concluants. Il s'agit des méthodes utilisées en __analyse de survie__ ou __analyse de durée de vie__. Nous utiliserons le modèle de Kaplan Meier et le modèle de Cox pour explorer et modéliser les données. <br />
<br />
__DONNEES__ <br />
Les données sont issues des publications de [Kleinbaum & Klein (2012)](https://link.springer.com/book/10.1007/0-387-29150-4 "Kleinbaum, D.G. and Klein, M. (2012) Survival Analysis - A Self-Learning Text, 3rd ed., Springer") contenues dans le fichier `remission.sas7bdat` du répertoire `data`. Ci-dessous, nous décrivons les différentes variables présentes dans la base.
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
...

<br /> <br /> <br />

****** _Rédaction en cours_ ******
