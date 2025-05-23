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

Garder le joueur au centre du monde demande, à un intervalle donné, de déplacer le monde entier et les acteurs, joueur compris, dans la direction opposée à son déplacement.
Un intervalle approprié, au vu de l'utilisation de chunks pour ce projet, est à chaque passage d'un chunk à un autre.
Ainsi, pour un déplacement du joueur d'un chunk A à B, nous avons un déplacement vectoriel de celui-ci sous la forme $delta d = arrow("AB")$.
Le déplacement de chaque acteurs et du monde est donc $-delta d = arrow("BA")$.

Cela pose néanmoins problème avec l'implémentation initiale du loading des chunks, qui prend en compte la position du joueur.
En effet, le déplacement du joueur, avec le recentrage du monde sur celui-ci, est de la forme : $(0, 0) arrow arrow("AB") arrow (0, 0)$.
Il faut donc garder en mémoire la position relative du joueur, et la mettre à jour pour charger les chunks correspondants.

== LOD

TODO

== Imposteurs

TODO

== Shader

TODO
