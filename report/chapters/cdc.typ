= Cahier des charges <cahier-des-charges>

== Introduction <introduction>

Les applications en temps réel présentent beaucoup de défis techniques.
L’entreprise du jeu vidéo est familière avec ces défis, puisque couplé à ceux-ci s’ajoutent la complexité du rendu graphique, dont celui en 3D.

Néanmoins, un grand nombre de techniques ont vu le jour afin d’optimiser les performances, et l'expérience utilisateur, de ces programmes.
Cette optimisation, couplée au progrès technologique, a permis l'émergence de systèmes de plus en plus complexes.
Les jeux dits en monde ouvert représentent le summum de cette complexité.

=== Définition d'un jeu en monde ouvert

Un jeu en monde ouvert a comme caractéristique essentielle que le joueur n'est pas contraint dans un environnement clos ou linéaire.
Ceci implique toute une série de caractéristiques et contraintes :
+ Vaste environnement : 
  Dans lequel les joueurs et autres agents peuvent évoluer.
  Puisque la mémoire vive est limitée et que son impact sur la performance pour des expériences complexes est crucial, il faut charger et décharger les ressources requises de manière dynamique.
+ Large quantité d'objets : 
  Que ce soient des objets interactifs, d'autres agents, ou des purement décoratifs, il convient de gérer ceux-ci efficacement.
+ Large distance d'affichage : 
  Les techniques établies telles que l'occlusion culling qui allégeraient les problèmes d'affichage ne peuvent que difficilement être appliquées.

==== Autres traits notables

En plus de laisser une grande liberté de déplacement au joueur, les jeux en monde ouvert vont souvent mettre en place des systèmes offrant une liberté de choix mécanique.

+ Modifications par le joueur : 
  Au travers de l'édition du terrain ou de l'ajout d'objets par le joueur.
  Enregistrer ces informations et refléter ces changements ajoute une couche de complexité.
+ Multijoueur :
  Un environnement en monde ouvert est souvent une excuse pour une expérience multijoueur. 
  Choisir la bonne architecture pour supporter différentes fonctionnalités, interactions physiques, par exemple, est crucial.
+ Génération procédurale : 
  Certains environnements de jeux en monde ouvert sont générés de manière procédurale. 
  Cette génération peut utiliser différents algorithmes afin d'aboutir à une large palette de résultats, tels que Cellular Automata, Perlin Noise, Voronoi Tesselation, Binary Space Partitioning, etc.
+ Adaptabilité aux changements :
  + Cycle jour-nuit : 
    La technique d'une lightmap, permettant un bon compromis performance-rendu graphique, ne peut pas être appliquée en raison de cet aspect dynamique de la lumière.
  + Environnemental : 
    Au travers du changement de météo ou de saison. 
    Avoir une architecture permettant de facilement représenter ceux-ci est souhaitable.

=== Problématique <problématique>

Les jeux vidéo ont toujours eu comme problématique centrale d'atteindre un compromis acceptable entre performances et qualité visuelle.

La problématique de ce travail de bachelor est d'améliorer les performances pour un prototype de jeu en monde ouvert en 3D.
Pour ce faire, il faudra utiliser l'état de l'art des techniques d'optimisation dans un moteur de jeu existant.

== Cahier des charges <cahier-des-charges-1>

Le travail consistera en la réalisation d'un prototype de jeu vidéo en monde ouvert en 3D. 
Ce prototype contiendra une très simple génération procédurale du monde. 
La génération procédurale n'est pas le sujet principal de ce projet, mais est essentielle afin de tester les fonctionnalités principales.

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

-	*Assets et World Loading* : 
  Le fait de charger les ressources locales et les prochaines parties du monde requises par le jeu de manière asynchrone afin d'éviter temps de chargement à la moindre nouvelle ressource ou parcelle du monde rencontrée.
- *Performances acceptables* : 
  Il faudra améliorer les performances d'un prototype dénué de toute optimisation. 
  De plus, un ordre de grandeur sera à respecter, plus de 30 frames par seconde tout en évitant les chutes de framerate hors d'écran de chargement.

==== Essential

-	*Float approximation* : 
  Les moteurs de jeu utilisent des float en lieu de double pour réduire le temps de calcul. 
  Avec de grandes distances, des erreurs d'approximation peuvent se produire. Une solution standard consiste à centrer l'origine du monde sur le joueur en tout temps.
-	*LOD* : 
  Afin d'améliorer performances en substituant des modèles complexes distants de la caméra par des moins détaillés.
-	*Contrôle* de la *caméra* et d'un *avatar* : 
  Afin que le prototype soit jouable et que les fonctionnalités requises soient testées. 
  La vitesse devra être modifiable afin de pouvoir facilement produire une situation de stress test.
- *Génération procédurale* de l'environnement : 
  En raison de la nécessité d'un environnement suffisamment grand pour tester les fonctionnalités requises.

==== Objectifs complémentaires _"nice-to-have"_

- *Optimisation par shader* : 
  Pour des éléments simples, n'ayant qu'un impact visuel, tels que des brins d'herbe. 
  Ce type d'élément peut être calculé au travers d'un shader afin d'améliorer les performances.
  Utiliser la puissance des GPUs en découplant la logique visuelle de celle d'un modèle pour un objet est adapté dans les cas n'affectant que les visuels.
- *Imposteurs* : 
  Afin de supporter des comportements d'objets plus complexes pour des LODs, tels que des modèles animés.

=== Déroulement <déroulement>

Le projet est séparé en plusieurs étapes charnières, des milestones, qui suivent les étapes majeures du calendrier des travaux de bachelor.

Un projet GitHub sera créé afin de suivre l'avancement de l'implémentation technique du projet, une fois la milestone 1 effectuée.
Des issues seront créées afin de représenter les différentes tâches d'implémentations à effectuer.

À noter que la milestone 4 correspond à la partie où je travaillerai à 100% sur le projet.
Pour cette milestone, des sprints de 2 semaines me permettront d'itérer et d'évaluer l'avancement du projet.

==== Milestone 1 : 10.04

- Rédaction du cahier des charges.
- Analyse de la littérature et des technologies existantes.
- Prototypage d'un jeu en monde ouvert 3D.
- Mise en place du projet.

==== Milestone 2 : 23.05

- Rédaction d’un rapport intermédiaire détaillant la conception des systèmes à implémenter.
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
