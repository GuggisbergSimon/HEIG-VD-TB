= Architecture <architecture>

== Prototype

Comme cela a été discuté lors de l'état de l'art, l'échelle des mondes virtuels varie grandement.

En raison des contraintes de ce projet, il a été décidé d'adopter une échelle de type véhicule avec un monde de taille réduite, servant de démonstration technique.

Cette échelle laisse la plus grande liberté d'implémentation, tout en facilitant la création de contenu.
En effet, le joueur ne sera représenté que par un véhicule, sans animation, et au vu de la taille des objets les joueurs seront plus à même de tolérer des défauts de comportement physique.

Par souci de simplification, l'idée d'un _hovercraft_ explorant des dunes d'un paysage post-apocalyptique a été retenue.
Cette idée permet l'utilisation d'une grande variété d'assets existants, sous prétexte que le monde soit désertique et que des ruines de tout genre parsèment le paysage.
Le désert, de plus, simplifiera considérablement le rendu graphique en excluant des arbres. Ceux-ci pourront être ajoutés, dans un second temps, si les imposteurs sont implémentés.
La caméra sera positionnée à distance du véhicule et suivra celui-ci à la troisième personne.

Une inspiration notable est le jeu vidéo _Sable_, qui, comme son nom l'indique, se déroule dans un monde désert que le joueur parcourt à bord d'un véhicule mais peut à tout moment débarquer à pied et explorer villages, ruines, et autres lieux d'intérêt.

#figure(
  image("images/maquette.jpg", width: 70%),
  caption: [
    Maquette du prototype.
  ],
)

#figure(
  table(
    columns: (auto, auto, auto),
    table.header[Contrôle][Interaction Jeu][Interaction menu],
    [`A`],[Tourner à gauche],[Naviguer vers la gauche],
    [`D`],[Tourner à droite],[Naviguer vers la droite],
    [`W`],[Accélérer],[Naviguer vers le haut],
    [`S`],[Ralentir],[Naviguer vers le bas],
    [`R`],[Reset le vaisseau],[/],
    [`Esc`],[Ouvrir le menu],[Revenir en arrière],
    [`Mouse`],[Contrôle de la caméra],[Navigation libre],
    [`Left Click`],[/],[Sélectionner],
  ),
  caption: "Contrôle du prototype dans différents contextes."
)

== Représentation du monde

Parmi les solutions de représentations possibles, la solution _Cesium_ propose de nombreux outils et fonctionnalités très complets et puissants pour le rendu géospatial de planètes.
Malheureusement elle n'est que rarement adapté dans le développement d'un jeu vidéo, sans compter que la fidélité graphique proposée ne correspond qu'à une faible portion d'expériences de jeu tels que les simulateurs de vol.

La plupart des jeux vidéo préfèrent se tourner vers des solutions plus adaptées à leurs besoins, afin de créer des mondes virtuels, au travers de la génération procédurale.
Ce travail fera de même, d'autant plus que la complexité des outils de _Cesium_ ne permettrait pas d'implémenter les techniques d'optimisation mentionnées dans le cahier des charges.
En effet, _Cesium for Unity_ implémente déjà le streaming de données du terrain et le recentrage du joueur en tout temps au centre du monde.

En raison de ces contraintes d'outils et de la décision de la taille du prototype, ce projet se limitera à un terrain de taille minimale de 64km².
_Unity_ ne supporte malheureusement que l'import d'une _heightmap_ de taille maximale de 8192x8192 pixels.
L'élevation pour un mètre est donc donnée par un pixel de la _heightmap_, ce qui correspond à un compromis acceptable entre taille et précision du terrain.
La résolution de la _heightmap_ est donc environ de 1 pixel par mètre.

La disposition d'éléments dans le monde est réalisé en fonction de l'inclinaison de la pente de ce terrain.
De plus des _clusters_ d'objets seront placés dans certains endroits, afin de simuler des conditions de stress test.
En raison de la complexité de la génération procédurale et des enjeux de ce travail de Bachelor, il n'a pas été donné un soin plus particulier à la réflexion de la disposition procédurale des éléments du décor sur le terrain.

@unity-doc-terrain

== Structure

_Unity_ possède de nombreuses structures permettant le développement de jeux vidéo.
Maintenir une bonne structure dès le début est essentiel.

=== Fichiers

Tout fichier de ressource, qu'il s'agisse d'un script C\#, d'une `Mesh` pour un modèle 3D ou d'une texture, est appelé un `Asset`.

Les `Assets` seront stockés dans le dossier `Assets` et plus spécifiquement dans les sous-dossiers correspondants à leur type.
Ainsi, le dossier `Scripts` contiendra des scripts C\#, dans celui `Prefabs`, des `Prefabs`, etc.

La seule exception à cela concernera les différentes assets provenant du _Unity Asset Store_ ou de _Fab_, deux grandes ressources d'assets pour _Unity_.
Leur propre structure sera conservée, afin de faciliter le réimport de celles-ci, au besoin.

=== Scènes

_Unity_ charge différents environnements, appelés `Scenes`.
Cela peut être réalisé de manière additive, ou en remplaçant complètement l'environnement précédent.

Ces `Scenes` contiennent toutes sortes d'instances d'objets, appelés `GameObjects`.
Ces `GameObjects` peuvent représenter des éléments visuels 3D, de la lumière, une caméra, contenir des scripts, etc.
Ceci est déterminé par les composants attachés à chacun de ces `GameObjects`.
Le composant par défaut, pour les objets 3D, est le `Transform`, qui détermine position, rotation et échelle d'un objet.
Chaque `GameObject` peut posséder plusieurs composants, dont certains qui peuvent être attachés au runtime à un objet.
De plus, chaque `GameObject` peut contenir plusieurs enfants `GameObjects` afin d'aider à structurer une `Scene`.
Garder une hiérarchie de `Scene` claire et logique est essentiel pour un projet, mais varie de projet en projet.
On dénote néanmoins souvent un `GameObject` racine pour tous les éléments visuels de la `Scene`, par exemple appelé "Monde".

Il est possible de sauvegarder un `GameObject` et ses enfants en tant qu'`Asset`, afin de facilement pouvoir le réutiliser dans d'autres scènes et synchroniser certains changements dans l'éditeur Unity.
Ce type d'`Asset` est appelé `Prefab`, la forme raccourcie de préfabriqué.
Les `Prefabs` ont le rôle d'un _template_ puisque deux instances d'un même `Prefab` auront des comportements indépendants.

==== GameManager

Un modèle de programmation typiquement utilisé dans le milieu du jeu vidéo est celui du _Singleton_, ici sous la forme d'un `GameManager`, qui va pouvoir être accédé par tout objet présent dans la scène.
Ce _Singleton_ aura le rôle de chef d'orchestre, s'assurant des bonnes communications entre les différents composants.

Ce `GameManager` possédera différents types de _managers_, éventuellement accessibles au travers d'une propriété, pour gérer différents aspects du jeu.
Ainsi, un `SceneManager` gérera le chargement et déchargement des scènes, tandis qu'un `SoundManager` gérera les différents effets sonores, etc.

Pour s'assurer qu'un `GameManager` soit présent dans une scène, une structure simple est celle du _boot_, où tous les éléments initiaux requis sont chargés dans une scène dédiée avant de passer au comportement attendu, qu'il s'agisse d'un menu principal, ou droit au jeu.

Le chargement de scènes plus complexes, telles qu'un menu ou le jeu, peut être fait de manière additive lors d'un écran de chargement, afin d'éviter que l'application ne soit immobilisée lors du chargement initial.

#figure(
  image("images/boot_loading.png", width: 73%),
  caption: [
    Exemple de structure d'initialisation de scène.
  ],
)

=== Monde

==== Chunks

Une solution très populaire pour charger en mémoire un monde virtuel par élément, plutôt que dans son ensemble, est de le diviser en parties, appelées _chunks_.

Chaque _chunk_ correspond à un fichier `Scene` séparé de _Unity_ afin de pouvoir être chargé de manière additive et asynchrone.
Ceci permet aux _chunks_ de posséder moults `GameObjects` qui peuvent représenter toutes sortes d'éléments du décor.
Un terrain de 8000x8000 peut être divisé en _chunks_ de 500x500 formant ainsi une sous-grille de 16x16.

Pour enregistrer les coordonnées de chaque _chunk_ et les charger au bon endroit dans l'espace 3D monde, il faut ajouter des méta informations aux _chunks_.
En raison de limitations de Unity, les `Scenes`, et par extension les _chunks_, ne peuvent pas offrir ces informations en lecture sans être chargées.
Heureusement, _Unity_ propose la structure de fichier `ScriptableObjects` qui permettent de stocker toutes sortes de données.
Il suffit alors de créer un `ScriptableObject` pour chaque _chunk_, contenant toutes les méta informations nécessaires pour ceux-ci.

Les `ScriptableObjects` ont comme avantage principal de pouvoir stocker des larges quantités de données et de les partager entre objets à faible coût.
Leur utilisation, ici, profite du fait que les données modifiées en tant que `ScriptableObject` dans l'éditeur Unity sont conservées en tant qu'`Asset`.
À noter néanmoins que ces `ScriptableObjects` ne conservent les changements que dans l'éditeur, et non pas lors d'un _build_.

Maintenir une liste des _chunks_ chargés permet de minimiser le nombre de _chunks_ à charger.
Pour déterminer quel _chunk_ à charger, il est possible de procéder en fonction de la distance au joueur, ou, si l'on simplifie, de la distance à un _chunk_, celui-ci occupé par le joueur.

Pour simplifier les calculs de distances, il est possible d'enregistrer sous forme de matrice-filtre NxN, où N est impair, les _chunks_ à charger.
Cette matrice contiendra une valeur positive s'il faut charger le _chunk_.
Les positions dans le monde des _chunks_ seront déterminées en fonction de celle du joueur, qui se trouve au centre de cette matrice-filtre.

#figure(
  grid(
    columns: 2,
    image("images/chunk_shape.png", width: 70%),
    image("images/chunk_loading.png", width: 70%),
  ),

  caption: [
    À gauche, exemple d'un filtre 7x7 de chargement de _chunks_ appliqué sur le monde.
    
    À droite, chargement et déchargement de _chunks_ selone une matrice 3x3, lors d'un changement de _chunk_ par le joueur.
  ],
)

Une autre complication concernant les _chunks_ est l'ajout d'agents en dehors du joueur
Les agents incluent toutes formes d'objets capables de mouvement.
Ceux-ci sont usuellement chargés avec une scène, ici un _chunk_.
Mais ceci ne peut s'appliquer ici puisque les agents peuvent, au même titre que le joueur, se déplacer d'un _chunk_ à l'autre.

Une manière de résoudre ce problème serait de créer un `AgentManager` qui tiendrait à jour la liste des agents présents dans le monde et les chargerait ou déchargerait en fonction des _chunks_ chargés.
Cette approche permettrait une permanence des agents ainsi qu'une consistence accrue mais ne permettrait pas de simuler des comportements en background, hors de portée du joueur.
Pour arriver à un résultat pareil, il faudrait que l'`AgentManager` mette à jour les agents non chargés, de manière moins soutenue que ceux visibles.
Ce processus serait similaire aux frames physiques qui ne se produisent qu'à un intervalle donné, indépendant des frames d'affichage.

Malheureusement, la gestion des agents et une implémentation pareille sort du cadre de ce travail de Bachelor et ne sera donc pas abordée plus en détail.

@unity-doc-scenemanager
@rain-world-gdc

==== Grandes coordonnées

Lorsque des coordonnées distantes de l'origine du monde sont utilisées, toutes sortes d'aberrations visuelles et logiques peuvent se produire.
Ceci n'est pas le cas pour ce projet borné à un monde de 64km².
Mais, à titre d'exploration de cette technique, cette problématique sera traitée.

Une solution typique pour éviter les valeurs flottantes d'atteindre de trop grandes valeurs est de recentrer le monde autour de l'observateur, ici le joueur.
Ainsi, le joueur et les chunks chargés seront toujours proches de l'origine du monde, bien avant que les effets de perte de précision de _float_ ne se fassent sentir.

Effectuer cette opération, à un intervalle donné, demande de déplacer le monde entier et les agents, joueur compris, dans la direction opposée au déplacement du joueur.
Un intervalle approprié, au vu de l'utilisation de _chunks_ pour ce projet, est à chaque passage d'un _chunk_ à un autre.
Ainsi, pour un déplacement du joueur d'un _chunk_ A à B, le déplacement vectoriel de celui-ci sous la forme $delta d = arrow("AB")$.
La modification de position de chaque agent et du monde est donc $-delta d = arrow("BA")$.

À noter néanmoins que recentrer le monde n'améliore pas les performances dans le cadre de ce prototype, mais représente une base essentielle pour les vastes mondes virtuels.

== Mesures de performance

Pour s'assurer de la reproductibilité du test de performance, il faudrait privilégier une situation de stress test sans que le joueur n'ait aucun contrôle.
C'est ce qu'un _benchmark_ permet de faire, par exemple sous la forme d'un parcours dirigé de la caméra, avec plusieurs actions se déroulant lors de la durée de celui-ci pour mettre le système à l'épreuve.

_Unity_ propose différents utilitaires de suivis de performances.
Ceux-ci vont du plus simple comme les statistiques visibles dans l'éditeur aux plus complexes comme le _Profiler_ ou le _Frame Debugger_.

Le _Profiler_, et en particulier le _Deep profiling_, a comme désavantage d'ajouter de l'_overhead_ aux mesures de performances.
C'est pour cette raison que le _Deep profiling_ ne sera utilisé que pour investiguer les problèmes de performance.
Si des problèmes plus complexes venaient à survenir, par exemple dans le rendu d'une frame spécifique, alors le _Frame Debugger_ sera utilisé.

Pour un jeu vidéo, la mesure la plus importante n'est pas la moyenne du _framerate_ mais le 95ème, ou 99ème percentile afin de pouvoir isoler les outliers.
Mettre en évidence ceci permet de suivre les chutes de performances.
Une chute brutale du _framerate_ en dehors des temps de chargement est particulièrement désagréable comme expérience et nuit à l'immersion du joueur.

En raison de la nature du projet, il est difficile d'implémenter des outils tels que _Cinemachine_ et _Timeline_ pour tester le chargement des chunks, en particulier à cause du recentrage automatique du joueur, ce qui est contraire à l'idée d'un parcours dirigé.
Mais puisque ce prototype ne contient aucunes fonctionnalités avancées, il est possible de rationaliser les différents types de tests à effectuer.
Ainsi on distingue deux types d'interactions principales, se déplacer et contrôler la caméra.

De plus, plusieurs profils de tests reproductibles seront exécutés :
- un profil sans aucune optimisation, pour servir de référence.
- un profil avec les optimisations considérées essentielles, à savoir : chargement des _chunks_, recentrage du monde, et LODs.
- un profil avec toutes les optimisations implémentées, à savoir : imposteurs et techniques de _batching_ ou _gpu instancing_.

Les outils de Unity permettant de réaliser ces tests sont :
- _Unity Test Framework_ pour effectuer des tests unitaires en Edit ou Play Mode.
- _Performance Testing Extension_, qui, comme son nom l'indique, est une extension de UTF pour ajouter tests de performance au projet sur plusieurs frames.
- _Input System_ met à disposition des manières pour simuler des entrées utilisateur.

#figure(
  table(
    columns: (auto, auto, auto),
    table.header[Type][Situation][Fréquence attendue lors d'une séance habituelle de gameplay],
    "Mouvement", "", "",
    "", "Lent", "fréquent",
    "", "Rapide", "inattendu",
    "", "Téléportation", "ponctuel",
    "", "Aller-retour d'un chunk à un autre", "ponctuel",
    "Caméra", "", "",
    "", "Vue fixe", "fréquent",
    "", "Rotation lente", "fréquent",
    "", "Rotation rapide", "fréquent",
  ),
  caption: "Liste des types d'interactions à tester."
)
