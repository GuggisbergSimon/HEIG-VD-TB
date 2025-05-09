= Architecture <architecture>

== Monde

Parmi les solutions de représentations possibles, la solution Cesium propose de nombreux outils et fonctionnalités très complets et puissants pour le rendu géospatial de planètes.
Malheureusement elle n'est que rarement adapté dans le développement d'un jeu vidéo, sans compter que la fidélité graphique proposée ne correspond qu'à une faible portion d'expériences de jeu tels que les simulateurs de vol.

La plupart des jeux vidéo préfèrent se tourner vers des solutions plus adaptées à leurs besoins, afin de créer des mondes virtuels, au travers de la génération procédurale.
Ce travail fera de même, d'autant plus que la complexité des outils de Cesium ne permettrait pas d'implémenter les techniques d'optimisation mentionnées dans le cahier des charges.
En effet, Cesium for Unity implémente déjà le streaming de données du terrain et le recentrage du joueur en tout temps au centre du monde.

En raison de ces contraintes d'outils et de la décision de la taille du prototype, il a été décidé de se limiter à un terrain de taille minimal de 64km².
Celui-ci sera représenté par une heightmap de 8192x8192 pixels.

== Chunks

Chaque chunk se trouve dans un fichier scène séparé afin de pouvoir être chargé de manière additive, et asynchrone.
De plus, chaque chunk doit connaître ses coordonnées mondes afin de pouvoir être chargé au bon endroit.
Un terrain de 8000x8000 et donc divisé en une sous grille de 16x16, chaque chunk ayant 500x500 comme dimension.

Il convient donc de disposer d'un objet Chunk qui contient ces informations.
Unity propose des ScriptableObjets qui permettent de stocker des données sans être des GameObjects.

TODO diagramme loading

== Structure de scène

Scène vide -> GameManager -> LoadingManager -> MainMenu -> Game
