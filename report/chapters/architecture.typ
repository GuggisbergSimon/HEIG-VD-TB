= Architecture <architecture>

== Terrain monde

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

== Chunks

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

Malheureusement, la gestion des agents et une implémentation pareille sort du cadre de ce travail de bachelor et ne sera donc pas abordé plus en détail.

@unity-doc-scenemanager
@rain-world-gdc

== Structure de scène

Un modèle de programmation typiquement utilisé dans le milieu du jeu vidéo est celui du Singleton, ici sous la forme d'un GameManager, qui va pouvoir être accédé par tout objet présent dans la scène.

Ce GameManager possédera différents types de managers, éventuellement accessibles au travers d'une propriété, pour gérer différents aspects du jeu.
Ainsi, un SceneManager gérera le chargement et déchargement des scènes, tandis qu'un SoundManager gérera les différents effets sonores, etc.

Pour s'assurer qu'un GameManager soit présent dans une scène, une structure simple est celle du boot, où tous les éléments initiaux requis sont chargés avant de passer au comportement attendu, qu'il s'agisse d'un menu principal, ou droit au jeu.

#figure(
  image("images/boot_loading.png", width: 60%),
  caption: [
    Exemple de structure d'initialisation de scène.
  ],
)
