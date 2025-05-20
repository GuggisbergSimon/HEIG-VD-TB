= Implémentation <implementation>

== Prototype

Des assets provenant du Unity Asset Store et de Fab ont été utilisées pour le prototype.
Ces assets sont listées et leur license est détaillée dans le fichier se `unity/assets/CREDITS.md`

Un premier contrôleur physique pour le joueur, assez sommaire, permet de facilement tester le chargement du monde.
Un second contrôleur, plus abouti, concerne le hovercraft avec une physique plus complexe pour qu'il adhère à la surface du terrain.

Un simple script de génération prend en paramètres plusieurs préfabs et en instancie un certain nombre de manière aléatoire par terrain.
L'angle de ces préfabs sont ensuite ajustés pour correspondre à la pente du terrain.

== Workflow

1. Terrain 8kx8k 
2. split en chunks 500x500
  - sauvegardés dans scènes séparées
    - remplissage de chaque chunk par objets de manière aléatoire
  - création de SO pour chaque chunk

== Chunk Loading

- Charger selong matrice 3x3
- Gérer asynchronicité
- Gérer autres acteurs

Une autre considération à prendre en compte concernant les chunks est la gestion de la concurrence puisque chaque opération de chargement additif est asynchrone.
En effet, garder en mémoire les chunks chargés afin de pouvoir les décharger lorsque ceux-ci ne sont plus requis demande de garder une liste de ceux-ci, et puisque celle-ci peut être altérée de manière concurrente, il faut s'assurer que les accès à cette liste soient faits de manière protégée.

== Recentrer le joueur au centre du monde

Quoi déplacer :
- joueur
- scènes chargées (root)

== LOD

== Imposteurs

== Shader
