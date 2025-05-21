= Implémentation <implementation>

== Prototype

Des assets provenant du Unity Asset Store et de Fab ont été utilisées pour le prototype.
Ces assets sont listées et leur license est détaillée dans le fichier `unity/assets/CREDITS.md`

Un premier contrôleur physique pour le joueur, assez sommaire, permet de facilement tester le chargement du monde.
Un second contrôleur, plus abouti, concerne le hovercraft avec une physique plus complexe pour qu'il adhère à la surface du terrain.

Un simple script de génération prend en paramètres plusieurs préfabs et en instancie un certain nombre de manière aléatoire par terrain.
L'angle de ces préfabs sont ensuite ajustés pour correspondre à la pente du terrain.

== Workflow

La heightmap est importée dans un Terrain Unity, permettant tout de suite d'avoir une courbure du terrain, pour 8000x8000m.
Les Terrain Tools séparent ensuite cette heightmap en plusieurs morceaux, ici en chunks de 500x500m.

À ce moment là, un script Unity exécutable uniquement dans l'éditeur va copier chaque chunk dans une scène individuelle. 
Ces scènes sont ensuite sauvegardées en tant qu'assets.
Le script créée également des ScriptableObjects correspondant à chaque scène.
Ceux-ci contiennent les coordonnées de chaque chunk, afin de connaître quelle scène correspond à quel chunk.

== Chunk Loading

Une autre considération à prendre en compte concernant les chunks est la gestion de la concurrence puisque chaque opération de chargement additif est asynchrone.
En effet, garder en mémoire les chunks chargés afin de pouvoir les décharger lorsque ceux-ci ne sont plus requis demande de garder une liste de ceux-ci, et puisque celle-ci peut être altérée de manière concurrente, il faut s'assurer que les accès à cette liste soient faits de manière protégée.

== Recentrer le joueur au centre du monde

TODO

== LOD

TODO

== Imposteurs

TODO

== Shader

TODO
