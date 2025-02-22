= Introduction <introduction>
Les applications en temps réel sont un sous domaine d’applications présentant bon nombre de défis techniques. L’entreprise du jeu vidéo, une de celles brassant le plus de revenus, est définitivement familière avec ces défis, puisque couplé à ceux-ci s’ajoutent les maints problèmes de rendu graphique, bien souvent 3D. Avec le temps, néanmoins, bon nombre de techniques ont vu le jour afin d’optimiser les performances des programmes. Mais une catégorie de jeu représente encore le summum de la complexité des applications en temps réel, tant en termes de rendu graphique que d’architecture : les jeux dit en monde ouvert.

== Définition et présentation d'un jeu en monde ouvert

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