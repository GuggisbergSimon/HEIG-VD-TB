= Cahier des charges <cahier-des-charges>

== Introduction <introduction>

Les applications en temps réel sont un sous domaine d’applications présentant bon nombre de défis techniques. L’entreprise du jeu vidéo, une de celles brassant le plus de revenus, est définitivement familière avec ces défis, puisque couplé à ceux-ci s’ajoutent les maints problèmes de rendu graphique, bien souvent 3D.

Avec le temps, néanmoins, bon nombre de techniques ont vu le jour afin d’optimiser les performances des programmes. Mais une catégorie de jeu représente encore le summum de la complexité des applications en temps réel, tant en termes de rendu graphique que d’architecture : les jeux dit en monde ouvert.

=== Définition et présentation d'un jeu en monde ouvert

Un jeu monde ouvert a souvent comme caractéristique :
+ Vaste environnement dans lequel les joueurs et autres agents peuvent évoluer : Cela implique une complexité quant à charger différents éléments et garder en mémoire uniquement ceux faisant sens.
+ Environnement qui laisse percevoir jusqu'à une longue distance : Les techniques telle que l'occlusion culling qui allégeraient les problèmes d'affichage ne peuvent que difficilement être appliquées.
+ Gérer une large quantité d'objets : Que ce soit des objets interactibles, d'autres agents, ou des purements décoratifs, il convient de gérer ceux-ci efficacement.
+ Cycle jour-nuit : La technique pour alléger le calcul graphique de la lumière via le lightmap baking ne peut pas être appliquée. De plus toute source de lumière dynamique complexifie le rendu.
+ Progression non linéaire : Cela implique une communication entre les éléments pour régler les différentes situations plutôt que de passer par un manager en charge de l'exécution d'un niveau.
+ Adaptabilité aux changements : que ce soient un changement de météos, ou même de saisons. Avoir une architecture permettant de facilement représenter ceux-ci est souhaitable.
+ Modifications du monde : Au travers de l'édition du terrain, de la construction d'éléments. Ceci ajoute une complexité supplémentaire tant au niveau de la gestion des ressources des éléments ajoutés que via l'édition du terrain en soit, par la création de faces supplémentaires de manière dynamique.
+ Multijoueur : Un environnement en monde ouvert est souvent une excuse pour que plusieurs joueurs interagissent ensemble. L'architecture à choisir pour supporter des interactions physiques ou une dirigée par un serveur demande une réflexion particulière.
+ Génération procédurale : certains jeux en monde ouvert sont générés de manière procédurale. Cette génération peut utiliser différents algorithmes afin d'aboutir au résultat souhaité, tels que Cellular Automata, Perlin Noise, Voronoi Tesselation, Binary Space Partitioning, etc.

=== Problématique <problématique>

TODO : Atteindre des performances acceptables pour un jeu en monde ouvert en 3D.

=== Solutions existantes <solutions-existantes>

- Viewing-frustum Culling
- Hidden-surface determination (Occlusion culling)
- Lightmap
- Level of detail (LOD)
- Impostor

=== Solutions possibles <solutions-possibles>

- Viewing-frustum Culling
- LOD
- Impostor

== Cahier des charges <cahier-des-charges-1>

Le travail consistera en la réalisation d'un prototype de jeu vidéo en monde ouvert en 3D. Ce prototype contiendra une très simple génération procédurale du monde, ceci n'étant pas le sujet principal de ce projet, mais nécessaire afin de tester les fonctionnalités principales de celui-ci.

En outre, les points suivants définis en tant que composante d'un jeu en monde ouvert seront abordés dans les fonctionnalités :
- Vaste environnement : 
  - Assets Loading
  - World Loading
  - Float Approximation
- Longue distance d'affichage :
  - LOD
- Gestion d'une large quantité d'objets :
  - Optimisation par shader

=== Objectifs <objectifs>

==== Required

-	Assets et World Loading : Le fait de charger les ressources locales et les prochaines parties du monde requises par le jeu de manière asynchrone afin d'éviter temps de chargement à la moindre nouvelle ressource ou parcelle du monde rencontrée.
-	Float approximation : Les moteurs de jeu utilisent des float en lieu de double pour réduire le temps de calcul. Avec de grandes distances, des erreurs d'approximation peuvent se produire. Une solution standard consiste à centrer l'origine du monde sur le joueur en tout temps.
- Performances acceptables : Sujet sensible au vu la diversité des ordinateurs et des architectures/drivers offerts par certains. Un compromis de métrique serait un ordre de grandeur à respecter, plus de 30 frames par seconde tout en évitant les chutes de framerate hors d'écran de chargement.

==== Essential

-	LOD : Afin d'améliorer la performance en substituant des modèles complexes distants de la caméra par des moins détaillés.
-	Contrôle de la caméra et d'un avatar : Afin que le prototype soit jouable et que les fonctionnalités requises soient testées. La vitesse devra être modifiable afin de pouvoir facilement produire une situation de stress test.
- Génération procédurale de l'environnement : En raison d'un environnement sufissament grand afin que les fonctionnalités requises soient testées.

==== Objectifs complémentaires "nice-to-have"

- Optimisation par shader : Pour un élément simple répétable, n'ayant qu'un impact visuel, tel que l'herbe. Cet type d'élément peut aisément être représenté par un shader afin d'améliorer les performances en découplant la logique visuelle de celle de l'objet.

=== Déroulement <déroulement>

Le projet est séparé en plusieurs étapes charnières, milestones, qui suivent les étapes majeures du calendrier des travaux de bachelor.

==== Milestone 1 : 10.04

- Rédaction du cahier des charges.
- Analyse de la littérature et des technologies existantes.
- Prototypage

==== Milestone 2 : 23.05

- Rédaction d’un rapport intermédiaire détaillant la conception du système.

==== Milestone 3 : 13.06



==== Milestone 4 : 24.07

- Finalisation du rapport final.
- Réalisation d'un résumé publiable et d'un poster.

==== Milestone 5 : 25.08

- Préparation de la défense

=== Livrables <livrables>

Les délivrables seront les suivants :
- Un *rapport intermédiaire* détaillant la conception du système.
- Un *rapport final* détaillant la conception et l'implémentation du système.
- Un *résumé publiable* et un *poster*
- Un *prototype* de jeu vidéo en monde ouvert en 3D, avec son *code source*.
