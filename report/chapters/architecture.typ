= Architecture <architecture>

== Prototype

Comme cela a été discuté lors de l'état de l'art, l'échelle des mondes virtuels varie grandement.

En raison des contraintes de ce projet, il a été décidé d'adopter une échelle de type véhicule avec un monde de taille réduite, servant de démonstration technique.

Cette échelle laisse la plus grande liberté d'implémentation, tout en facilitant la création de contenu.
En effet, le joueur ne sera représenté que par un véhicule, sans animation, et au vu de la taille des objets les joueurs seront plus à même de tolérer des défauts de comportement physique.

Par souci de simplification, l'idée d'un hovercraft explorant des dunes d'un paysage post-apocalyptique a été retenue.
Cette idée permet l'utilisation d'une grande variété d'assets existantes, sous prétexte que le monde soit désertique et que des ruines de tout genre parsèment le paysage.
Le désert, de plus, simplifiera considérablement le rendu graphique en excluant des arbres. Ceux-ci pourront être ajoutés, dans un second temps, si les imposteurs sont implémentés.
La caméra sera positionné à distance du véhicule et suivra celui-ci à la troisième personne.

Une inspiration notable est le jeu vidéo Sable, qui, comme son nom l'indique, se déroule dans un monde désert que le joueur parcourt à bord d'un véhicule mais peut à tout moment débarquer à pied et explorer villages, ruines, et autres lieux d'intérêt.

#figure(
  image("images/maquette.jpg", width: 52%),
  caption: [
    Maquette du prototype.
  ],
)

#figure(
  table(
    columns: (auto, auto, auto),
    [*Contrôle*],[*Interaction Jeu*],[*Interaction menu*],
    [`A`],[Tourner à gauche],[Naviguer vers la gauche],
    [`D`],[Tourner à droite],[Naviguer vers la droite],
    [`W`],[Accélérer],[Naviguer vers le haut],
    [`S`],[Ralentir],[Naviguer vers le bas],
    [`Space`],[Freiner],[Sélectionner],
    [`Esc`],[Ouvrir le menu],[Revenir en arrière],
    [`Mouse`],[Contrôle de la caméra],[Navigation libre],
    [`Left Click`],[/],[Sélectionner],    
  ),
  caption: "Contrôle du prototype dans différents contextes."
)

== Représentation du monde

Parmi les solutions de représentations possibles, la solution Cesium propose de nombreux outils et fonctionnalités très complets et puissants pour le rendu géospatial de planètes.
Malheureusement elle n'est que rarement adapté dans le développement d'un jeu vidéo, sans compter que la fidélité graphique proposée ne correspond qu'à une faible portion d'expériences de jeu tels que les simulateurs de vol.

La plupart des jeux vidéo préfèrent se tourner vers des solutions plus adaptées à leurs besoins, afin de créer des mondes virtuels, au travers de la génération procédurale.
Ce travail fera de même, d'autant plus que la complexité des outils de Cesium ne permettrait pas d'implémenter les techniques d'optimisation mentionnées dans le cahier des charges.
En effet, Cesium for Unity implémente déjà le streaming de données du terrain et le recentrage du joueur en tout temps au centre du monde.

En raison de ces contraintes d'outils et de la décision de la taille du prototype, il a été décidé de se limiter à un terrain de taille minimal de 64km².
En effet, Unity ne supporte que l'import d'une heightmap de taille maximale de 8192x8192 pixels.
L'élevation pour un mètre est donc donnée par un pixel de la heightmap, ce qui correspond à un compromis acceptable entre taille et précision du terrain.

La disposition d'éléments dans le monde est réalisé en fonction de l'inclinaison de la pente de ce terrain.
En raison de la complexité de la génération procédurale et des enjeux de ce travail de bachelor, il n'a pas été donné un soin plus particulier à la disposition procédurale des éléments du décor sur le terrain.

@unity-doc-terrain

== Structure

=== Fichiers

Les Assets seront stockées dans des dossiers correspondants à leur type.
Le dossier Scripts contiendra des scripts C\#, dans celui Prefabs, des préfabs, etc.

La seule exception à cela concerne les différentes assets provenant du Unity Asset Store ou de Fab.
Leur propre structure sera conservée, afin de faciliter le réimport de celles-ci, au besoin.

=== Scène

Un modèle de programmation typiquement utilisé dans le milieu du jeu vidéo est celui du Singleton, ici sous la forme d'un GameManager, qui va pouvoir être accédé par tout objet présent dans la scène.

Ce GameManager possédera différents types de managers, éventuellement accessibles au travers d'une propriété, pour gérer différents aspects du jeu.
Ainsi, un SceneManager gérera le chargement et déchargement des scènes, tandis qu'un SoundManager gérera les différents effets sonores, etc.

Pour s'assurer qu'un GameManager soit présent dans une scène, une structure simple est celle du boot, où tous les éléments initiaux requis sont chargés avant de passer au comportement attendu, qu'il s'agisse d'un menu principal, ou droit au jeu.

#figure(
  image("images/boot_loading.png", width: 70%),
  caption: [
    Exemple de structure d'initialisation de scène.
  ],
)

=== Monde

Une solution très populaire pour charger en mémoire un monde virtuel par parties, plutôt que dans son ensemble, est de le diviser en chunks.

Chaque chunk se trouve dans un fichier scène séparé afin de pouvoir être chargé de manière additive, et asynchrone.
De plus, chaque chunk doit connaître ses coordonnées mondes afin de pouvoir être chargé au bon endroit.
Un terrain de 8000x8000 et donc divisé en chunks de 500x500 formant une sous grille de 16x16.

Pour enregistrer les coordonnées de chaque chunk et les charger au bon endroit, il faut créer un objet Chunk contenant ces informations.
Unity propose des ScriptableObjects qui permettent de stocker des données sans être des GameObjects.

Les ScriptableObjects ont comme avantage principal de pouvoir stocker des larges quantités de données et de les partager entre objets à faible coût.
Leur utilisation, ici, profite du fait les données modifiées en tant que ScriptableObject dans l'éditeur Unity sont conservées en tant qu'asset.
À noter néanmoins que ces ScriptableObjects ne conservent les changements que dans l'éditeur, et non pas lors d'un build.

Maintenir une liste des chunks chargés permet de minimiser le nombre de chunks à charger.
Pour déterminer quel chunk à charger, il est possible de procéder en fonction de la distance au joueur, ou, si l'on simplifie, de la distance à un chunk, celui-ci occupé par le joueur.
Pour simplifier les calculs de distances, il est possible d'enregistrer sous forme de matrice-filtre NxN, où N est impair, les chunks à charger.
Cette matrice contiendra une valeur positive si il faut charger le chunk.
Les positions dans le monde des chunks sont déterminées en fonction de celle du joueur, qui se trouve au centre de cette matrice-filtre.

#figure(
  grid(
    columns: 2,
    image("images/chunk_shape.png", width: 70%),
    image("images/chunk_loading.png", width: 70%),
  ),

  caption: [
    À gauche, exemple d'un filtre 7x7 de chargement de chunks appliqué sur le monde. À droite, chargement et déchargement de chunks selone une matrice 3x3, lors d'un changement de chunk par le joueur.
  ],
)

Une autre complication concernant les chunks et l'ajout d'agents en dehors du joueur.
Ceux-ci sont usuellement chargés avec une scène, ici un chunk.
Mais ceci ne peut s'appliquer ici puisque les agents peuvent, au même titre que le joueur, se déplacer d'un chunk à l'autre.
Une manière de résoudre ce problème est de créer un AgentManager qui tiendra à jour la liste des agents présents dans le monde et les chargera/déchargera en fonction des chunks chargés.
Cette approche permet une permanence des agents ainsi qu'une consistence accrue mais ne permet pas de simuler des comportements en background, hors de vision du joueur.

Pour arriver à un résultat pareil, il faudrait que l'AgentManager mette à jour les agents et le monde non chargés, de manière moins soutenue que ceux visibles.
Ce processus serait similaire aux frames physiques qui ne se produisent qu'à un intervalle donné, indépendant des frames d'affichage.

Malheureusement, la gestion des agents et une implémentation pareille sort du cadre de ce travail de bachelor et ne sera donc pas abordée plus en détail.

@unity-doc-scenemanager
@rain-world-gdc

== Test

=== Unitaire

TODO

=== Performance

Pour s'assurer de la reproductibilité du test de performance, il faudrait privilégier une situation de stress test sans que le joueur n'ait aucun contrôle.
C'est ce qu'un benchmark permet de faire, par exemple sous la forme d'un parcours dirigé de la caméra, avec plusieurs actions se déroulant lors de la durée de celui-ci pour mettre le système à l'épreuve.

Unity propose différents utilitaires de suivis de performances.
Ceux-ci vont du plus simple comme les statistiques visibles dans l'éditeur ou le profiler, aux plus complexes comme le Frame Debugger.

Le profiler, et en particulier le Deep profiling, a comme désavantage d'ajouter de l'overhead aux mesures de performances.
C'est pour cette raison que le Deep profiling ne sera utilisé que pour investiguer les problèmes de performance.

Pour un jeu vidéo, la mesure la plus importante n'est pas la moyenne du framerate mais le 95ème, ou 99ème percentile afin de pouvoir isoler les outliers.
Mettre en évidence ceci permet de suivre les chutes de performances.
Une chute brutale du framerate, en dehors des temps de chargement, est particulièrement désagréable comme expérience.
