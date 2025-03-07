= Cahier des charges <cahier-des-charges>

== Introduction <introduction>

Les applications en temps réel sont un sous domaine d’applications présentant bon nombre de défis techniques.
L’entreprise du jeu vidéo est définitivement familière avec ces défis, puisque couplé à ceux-ci s’ajoutent la complexité du rendu graphique, dont celui en 3D.

Néanmoins, un grand nombre de techniques ont vu le jour afin d’optimiser les performances des programmes.
Mais une catégorie de jeu représente encore le summum de la complexité des applications en temps réel, tant en termes de rendu graphique que d’architecture : les jeux dit en monde ouvert.

=== Définition et présentation d'un jeu en monde ouvert

Un jeu monde ouvert a souvent comme caractéristique :
+ Vaste environnement dans lequel les joueurs et autres agents peuvent évoluer : Cela implique une complexité quant à charger différents éléments et à garder en mémoire uniquement ceux requis par le jeu, que ce soit pour le rendu visuel, ou simulation en arrière plan.
+ Environnement qui laisse percevoir jusqu'à une longue distance : Les techniques telle que l'occlusion culling qui allégeraient les problèmes d'affichage ne peuvent que difficilement être appliquées.
+ Gérer une large quantité d'objets : Que ce soit des objets interactibles, d'autres agents, ou des purements décoratifs, il convient de gérer ceux-ci efficacement.
+ Cycle jour-nuit : La technique d'une lightmap, permettant un bon compromis performance-rendu graphique, ne peut pas être appliquée en raison de cet aspect dynamique de la lumière.
+ Adaptabilité aux changements : que ce soient un changement de météos, ou même de saisons. Avoir une architecture permettant de facilement représenter ceux-ci est souhaitable.
+ Modifications du monde : Au travers de l'édition du terrain ou de l'ajout d'objets par le joueur. Enregistrer ces informations et refléter ces changements ajoute une couche d'imprédictabilité. 
+ Multijoueur : Un environnement en monde ouvert est souvent une excuse pour une expérience multijoueur. Choisir la bonne architecture pour supporter différentes fonctionnalités, interactions physiques, par exemple, est crucial.
+ Génération procédurale : certains jeux en monde ouvert sont générés de manière procédurale. Cette génération peut utiliser différents algorithmes afin d'aboutir à une large palette de résultats, tels que Cellular Automata, Perlin Noise, Voronoi Tesselation, Binary Space Partitioning, etc.

=== Problématique <problématique>

Les jeux vidéo ont toujours eu comme problématique centrale d'atteindre un compromis acceptable entre performances et qualité visuelle.

La problématique de ce travail de bachelor est d'améliorer les performances pour un prototype de jeu en monde ouvert en 3D.
Pour ce faire, il faudra utiliser l'état de l'art des techniques d'optimisation dans un moteur de jeu existant.

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

Le travail consistera en la réalisation d'un prototype de jeu vidéo en monde ouvert en 3D. 
Ce prototype contiendra une très simple génération procédurale du monde, ceci n'étant pas le sujet principal de ce projet, mais nécessaire afin de tester les fonctionnalités principales de celui-ci.

En outre, les points suivants définis en tant que composante d'un jeu en monde ouvert seront abordés dans les fonctionnalités :
- Vaste environnement : 
  - Assets Loading
  - World Loading
  - Float Approximation
- Longue distance d'affichage :
  - LOD
  - _Imposteurs_
- Gestion d'une large quantité d'objets :
  - _Optimisation par shader_

=== Objectifs <objectifs>

==== Required

-	Assets et World Loading : Le fait de charger les ressources locales et les prochaines parties du monde requises par le jeu de manière asynchrone afin d'éviter temps de chargement à la moindre nouvelle ressource ou parcelle du monde rencontrée.
- Performances acceptables : Il faudra améliorer les performances d'un prototype dénué de toute optimisation. De plus, un ordre de grandeur sera à respecter, plus de 30 frames par seconde tout en évitant les chutes de framerate hors d'écran de chargement.

==== Essential

-	Float approximation : Les moteurs de jeu utilisent des float en lieu de double pour réduire le temps de calcul. Avec de grandes distances, des erreurs d'approximation peuvent se produire. Une solution standard consiste à centrer l'origine du monde sur le joueur en tout temps.
-	LOD : Afin d'améliorer performances en substituant des modèles complexes distants de la caméra par des moins détaillés.
-	Contrôle de la caméra et d'un avatar : Afin que le prototype soit jouable et que les fonctionnalités requises soient testées. La vitesse devra être modifiable afin de pouvoir facilement produire une situation de stress test.
- Génération procédurale de l'environnement : En raison de la nécessité d'un environnement sufisamment grand pour tester les fonctionnalités requises.

==== Objectifs complémentaires _"nice-to-have"_

- Optimisation par shader : Pour des éléments simples, n'ayant qu'un impact visuel, tels que des brins d'herbe. Ce type d'élément peut aisément être calculé au travers d'un shader afin d'améliorer les performances en utilisant la puissance des GPUs en découplant la logique visuelle de celle d'un modèle pour un objet.
- Imposteurs : Afin de supporter des comportements d'objets plus complexes pour des LODs, tels que des animations distantes.

=== Déroulement <déroulement>

Le projet est séparé en plusieurs étapes charnières, milestones, qui suivent les étapes majeures du calendrier des travaux de bachelor.

Un projet GitHub sera créé afin de suivre l'avancement du projet, une fois la milestone 1 effectuée.
Des issues seront créées afin de représenter les différentes tâches d'implémentations à effectuer.

À noter que la milestone 4 correspond à la partie où je travaillerai à 100% sur le projet.
Pour cette milestone, des sprints de 2 semaines me permettront d'itérer et d'évaluer l'avancement du projet.

==== Milestone 1 : 10.04

- Rédaction du cahier des charges.
- Analyse de la littérature et des technologies existantes.
- Prototypage d'un jeu en monde ouvert 3D.
- Mise en place du projet.

==== Milestone 2 : 23.05

- Rédaction d’un rapport intermédiaire détaillant la conception des système à implémenter.
- Rédaction des techniques offertes par l'état de l'art.
- Prototypage des fonctionnalités d'optimisation.
- Évaluation des performances initiales.

==== Milestone 3 : 13.06

- Rédaction du rapport final.
- Implémentation des fonctionnalités requises.
- Évaluation des performances intermédiaires.

==== Milestone 4 : 24.07

- Finalisation du rapport final.
- Réalisation d'un résumé publiable et d'un poster.
- Implémentation des fonctionnalités essentielles et _nice-to-have_.
- Évaluation des performances finales.
- Corrections des bugs.

==== Milestone 5 : 25.08

- Préparation de la défense.

=== Livrables <livrables>

Les délivrables seront les suivants :
- Un *rapport intermédiaire* détaillant la conception du système.
- Un *rapport final* détaillant la conception et l'implémentation du système.
- Un *résumé publiable* et un *poster*
- Un *prototype* de jeu vidéo en monde ouvert en 3D, avec son *code source*.
