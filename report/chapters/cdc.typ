= Cahier des charges <cahier-des-charges>

== Introduction <introduction>

Les applications en temps réel présentent beaucoup de défis techniques.
En plus de ceux-ci, la question du rendu graphique, en particulier celui 3D, est un enjeu de taille.
Le milieu du jeu vidéo se situe au coeurs de ces défis.

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
  Que ce soient des objets interactifs, décoratifs, ou d'autres agents, il convient de gérer ceux-ci efficacement.
+ Large distance d'affichage :
  Les techniques établies telles que l'occlusion culling qui allégeraient les problèmes d'affichage ne peuvent que difficilement être appliquées.

En plus de laisser une grande liberté de déplacement au joueur, les jeux en monde ouvert vont souvent mettre en place des systèmes offrant une liberté de choix mécanique.
+ Modifications par le joueur :
  Un joueur peut modifier le terrain, ou instantier des objets.
  Enregistrer ces informations et refléter ces changements ajoute une couche de complexité.
+ Multijoueur :
  Un environnement en monde ouvert est souvent une excuse pour une expérience multijoueur. 
  Choisir la bonne architecture pour supporter différentes fonctionnalités, comme les interactions physiques, est crucial.
+ Génération procédurale :
  Certains environnements de jeux en monde ouvert sont générés de manière procédurale. 
  Cette génération peut utiliser différents algorithmes afin d'aboutir à une large palette de résultats, tels que Cellular Automata, Perlin Noise, Voronoi Tesselation, Binary Space Partitioning, etc.
+ Adaptabilité aux changements :
  + Cycle jour-nuit :
    Certaines techniques d'optimisation, telles que les lightmaps, ne peuvent pas être utilisées dans des conditions de lumière dynamique.
  + Environnemental :
    Certains changements peuvent se produire au travers de la météo ou de saison.
    Il est souhaitable de disposer d'une architecture qui permet de facilement représenter cette catégorie de changements.

== Problématique <problématique>

Les jeux vidéo ont toujours eu comme problématique centrale d'atteindre un compromis acceptable entre performances et fidélité visuelle.

La problématique de ce travail de bachelor est d'améliorer les performances pour un prototype de jeu en monde ouvert en 3D.
Pour ce faire, il faudra utiliser l'état de l'art des techniques d'optimisation dans un moteur de jeu existant.

== Objectifs <objectifs>

Le travail consistera en la réalisation d'un prototype de jeu vidéo en monde ouvert en 3D dans un premier temps.
Par la suite, il faudra améliorer ses performances en utilisant plusieurs techniques.
Les performances seront mesurées à plusieurs moments distincts.

En outre, les points suivants définis en tant que composante d'un jeu en monde ouvert seront abordés dans les fonctionnalités

=== Requis

-	Vaste environnement - *Assets et World Loading* :
  Il s'agit du fait de charger les ressources locales et les prochaines parties du monde requises par le jeu de manière asynchrone.
  Ceci dans le but d'éviter des temps de chargement à la moindre nouvelle ressource ou parcelle du monde rencontrée.
- *Création d'un prototype de jeu vidéo en monde ouvert* :
  Ce prototype contiendra un large environnement en 3D à taille finie, ou infinie.
  Il devra contenir différents modèles 3D et composants afin de simuler le comportement attendu pour un jeu en monde ouvert.
- *Performances acceptables* :
  Il faudra améliorer les performances du prototype de jeu vidéo dénué de toute optimisation. 
  De plus, un ordre de grandeur sera à respecter, plus de 30 frames par seconde tout en évitant les chutes de framerate hors d'écran de chargement.

=== Essentiels

-	Vaste environnement - *Float approximation* :
  Les moteurs de jeu utilisent des float en lieu de double pour réduire le temps de calcul. 
  Avec de grandes distances, des erreurs d'approximation peuvent se produire. Une solution standard consiste à centrer l'origine du monde sur le joueur en tout temps.
-	Longue distance d'affichage - *LOD* :
  Les LODs servent à améliorer les performances en substituant des modèles complexes distants de la caméra par des moins détaillés.
-	*Contrôle* de la *caméra* et d'un *avatar* :
  Afin que le prototype soit jouable et que les fonctionnalités requises soient testées. 
  La vitesse de l'avatar devra être modifiable afin de pouvoir facilement produire une situation de stress test.
- *Génération procédurale* de l'environnement :
  En raison de la nécessité d'un environnement suffisamment grand pour tester les fonctionnalités requises.
  La génération procédurale n'est pas le sujet principal de ce projet.
  Elle ne devra donc, par conséquent, que bénéficier que d'une implémentation et documentation simple.

=== Complémentaires _"nice-to-have"_

- Longue distance d'affichage - *Imposteurs* :
  Il s'agit d'une technique qui améliore significativement les LODs.
  Ils permettent également de supporter des comportements d'objets plus complexes pour des LODs, tels que des modèles animés.
- Gestion d'une large quantité d'objets - *Optimisation par shader* :
  Un shader peut grandement améliorer les performances dans le cas de nombreux objets n'ayant qu'un impact visuel, tels que des brins d'herbe.
  Cela permet d'utiliser la puissance des GPUs en découplant la logique visuelle de celle d'un modèle 3D.

=== Déroulement <déroulement>

Le projet est séparé en plusieurs étapes charnières, des milestones, qui suivent les étapes majeures du calendrier des travaux de bachelor.

Un projet GitHub sera créé afin de suivre l'avancement de l'implémentation technique du projet, une fois la milestone 1 effectuée.
Des issues seront créées afin de représenter les différentes tâches d'implémentations à effectuer.

À noter que la milestone 4 correspond à la partie dédiée au travail à 100% sur le projet.
Pour cette milestone, des sprints de 2 semaines permettront d'itérer et d'évaluer l'avancement.

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
