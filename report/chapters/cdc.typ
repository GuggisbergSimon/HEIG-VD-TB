= Cahier des charges <cahier-des-charges>
== Résumé du problème <résumé-du-problème>
#lorem(50)

=== Problématique <problématique>
TODO : Atteindre des performances acceptables pour un jeu en monde ouvert en 3D.

=== Solutions existantes <solutions-existantes>
- Frustum Culling
- Hidden-surface determination (Occlusion culling)
- Lightmap
- Level of detail (LOD)
- Impostor 

=== Solutions possibles <solutions-possibles>
- Frustum Culling
- LOD
- Impostor

== Cahier des charges <cahier-des-charges-1>

Le travail consistera en la réalisation d'un prototype de jeu vidéo en monde ouvert en 3D. Ce prototype contiendra un environnement dans lequel le joueur pourra se déplacer. Ce prototype servira de vertical slice

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
-	Float approximation : Les moteurs de jeu utilisent des float en lieu de double pour accélérer les calculs. Avec de grandes distances, des erreurs d'approximation peuvent se produire. Une solution standard consiste à centrer l'origine du monde sur le joueur en tout temps.
-	Contrôle de la caméra et/ou d'un avatar : Ne serait-ce que pour explorer l'environnement et tester celui-ci, le choix d'implémentation de vue, première ou troisième personne, est possible.
- Performances acceptables : Sujet sensible au vu la diversité des ordinateurs et des architectures/drivers offerts par certains. Un compromis de métrique serait un ordre de grandeur à respecter, plus de 30 frames par seconde tout en évitant les chutes de framerate hors d'écran de chargement.

==== Essential

-	LOD et Imposteurs : Afin d'améliorer la performance en substituant des modèles complexes distants de la caméra par des moins détaillés ou des images. Requière un comportement spécifique pour certains éléments pouvant nécessiter un changement visuel malgré la distance. Un moulin à vent doit continuer de tourner, même s'il s'agit d'un imposteur.

==== Objectifs complémentaires "nice-to-have"

- Optimisation par shader : Pour un élément simple répétable, n'ayant qu'un impact visuel, tel que l'herbe. Cet type d'élément peut aisément être représenté par un shader afin d'améliorer les performances en découplant la logique visuelle de celle de l'objet. Ici, implémenter une interaction avec l'herbe est en dehors du scope de ce projet.

=== Déroulement <déroulement>

Le projet est séparé en plusieurs étapes charnières, milestones, qui suivent les étapes majeures du calendrier des travaux de bachelor.

==== Milestone 1 : 10.04

- Rédaction du cahier des charges.
- Analyse de la littérature et des technologies existantes.
- Prototypage

==== Milestone 2 : 23.05

- Rédaction d’un rapport intermédiaire détaillant la conception du système.

==== Milestone 3 : 13.06



==== Milestone 4 : 10.04

- Finalisation du rapport final.
- Réalisation d'un résumé publiable et d'un poster.

=== Livrables <livrables>
Les délivrables seront les suivants :
- Un *rapport intermédiaire* détaillant la conception du système.
- Un *rapport final* détaillant la conception et l'implémentation du système.
- Un *résumé publiable* et un *poster*
- Un *prototype* de jeu vidéo en monde ouvert en 3D, avec son *code source*.
