= Implémentation <implementation>

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

== Prototype

Des assets provenant du Unity Asset Store et de Fab ont été utilisées pour le prototype.
Ces assets sont listées et leur license est détaillée dans le fichier `unity/assets/CREDITS.md`

Un premier contrôleur physique pour le joueur, assez sommaire, permet de facilement tester le chargement du monde.
Celui-ci a été complètement remplacé par un second contrôleur, plus abouti, simulant la physique d'un hovercraft afin qu'il adhère au terrain.

En raison de la contrainte de GitHub pour la taille de fichier maximum de 100Mo pour les assets, il a été requis de séparer la scène principale en plusieurs scènes, ou chunks, dès le début.
En effet, peupler un terrain de 8000x8000m avec toutes sortes de `Prefabs` atteint cette limite de taille de fichier.
Réaliser le prototype final a donc requis d'implémenter la partie du chargement de chunks.
Ainsi, la réalisation ne s'est pas produite de la manière prévue initialement, mais d'avantage sous la forme d'un aller et retour constant entre le prototype et optimisation de performance.
Par là même, les tests de performance ont effectués à la fin du projet, plutôt qu'après chaque étape du projet.

=== Séparation du monde en chunks

La heightmap est importée dans un Terrain Unity, permettant tout de suite d'avoir une courbure du terrain, pour 8000x8000m.
Les Terrain Tools séparent ensuite cette heightmap en plusieurs morceaux, ici en chunks de 500x500m, formant ainsi une grille de 16x16 chunks.

À ce moment là, un script Unity exécutable uniquement dans l'éditeur va copier chaque chunk dans une scène individuelle. 
Ces scènes sont ensuite sauvegardées en tant qu'assets.
Le script créée également des ScriptableObjects correspondant à chaque scène.
Ceux-ci contiennent les coordonnées de chaque chunk, afin de connaître quelle scène correspond à quel chunk.

=== Population du terrain

Un simple script de population de terrain prend en paramètres plusieurs catégories de `Prefabs` et en instancie un certain nombre de manière aléatoire par terrain.
L'angle de ces `Prefabs` sont ensuite ajustés pour correspondre à la pente du terrain, avec une rotation aléatoire selon l'axe de la normale du terrain.

Les deux catégories de `Prefabs` permettent des ajustements indépendants de densité et de hauteur.
En effet, parmi les différents `Prefabs`, certains sont considérablement plus grands que les autres, considérés, à juste titre, comme des bâtiments, tandis que la second catégorie concerne toute sorte d'éléments plus petits

De plus, afin de simuler des situations de stress test, certaines coordonnées de chunks sont catégorisées comme cluster, ou ici, de ville et voient la densité de la population de `Prefab` multipliée par un facteur, ici dix.
La taille des éléments de ces clusters sont égalements ajustés aléatoirement afin de simuler des bâtiments de tailles variées, avec les plus haut au centre du chunk.
Finalement, pour un aspect visuel plus soigné, l'orientation de ces éléments dans les villes n'est pas dépendante de la pente du terrain, mais pointe toujours vers le haut.

== Chargement de chunks

Charger les chunks est une opération qui s'effectue de manière asynchrone pour éviter de bloquer la thread principale de Unity.
Ceci implique la gestion de la concurrence en cas de modification d'une ressource partagée.
Ici celle-ci concerne la listes des chunks chargés, `chunksLoaded`.
Cette liste est utilisée afin de garder en mémoire les chunks chargés, et de pouvoir les décharger par la suite.

Une première modification consiste à n'ajouter et à supprimer dans la liste des chunks chargés que lorsque ceux-ci sont effectivement chargés ou déchargés, soit après réussite de l'opération asynchrone.
Ceci est fait via une écoute de l'événement confirmant la fin de l'opération de chargement ou déchargement du chunk.

De plus, pour accéder aux scènes plus rapidement, un double tableau `sortedScenes` contenant le nom des scènes correspondant aux chunks est utilisé.
Les indices x et y de celui-ci représentent les coordonnées du chunk, pour un accès plus rapide.
Ce tableau est créé une seule fois lors de l'initialisation de la scène composant le monde.
Cette solution a été envisagée en raison de la taille limitée du monde.

Avec cette structure, il est facile d'itérer sur les chunks chargés et de décharger ceux qui ne sont plus nécessaire.

```cs
// Déchargement des chunks
string[,] sortedScenes;
List<Vector2Int> chunksLoaded = new List<Vector2Int>();
List<Vector2Int> chunksToUnload = FindChunksToUnload();
foreach (var coords in chunksToUnload) {
    AsyncOperation unloadOperation = SceneManager.UnloadSceneAsync(sortedScenes[coords.x][coords.y]);
    unloadOperation.completed += _ => { chunksLoaded.Remove(coords); };
}
```

Pour régler d'autres problèmes de concurrence lors du chargement des chunks, le calcul du positionnement des chunks en fonction de la position du joueur n'est effectué qu'une fois l'opération de chargement terminée.
Ce problème est survenu après l'implémentation du recentrage du monde, dont le code n'est pas détaillé ici.

```cs
// Chargement des chunks
List<Vector2Int> chunksToLoad = FindChunksToLoad();
foreach (var coords in chunksToLoad) {
    AsyncOperation loadOperation = SceneManager.LoadSceneAsync(sortedScenes[coords.x][coords.y], LoadSceneMode.Additive);
    loadOperation.completed += _ => {
        Scene loadedScene = SceneManager.GetSceneByName(_sortedScenes[coords.x][coords.y]);
        Vector3 chunkPosition = new Vector3(
            (coords.x - (recenterChunks ? playerGridPos.x : gridOffset.x)) * gridSize.x,
            yOffset,
            (coords.y - (recenterChunks ? playerGridPos.y : gridOffset.y)) * gridSize.y
        );
        foreach (var terrainObj in loadedScene.GetRootGameObjects()) {
            terrainObj.transform.position = chunkPosition;
        }

        _chunksLoaded.Add(coords);
    }
}
```

== Distance d'affichage

Les terrains dans Unity représentent des plans 3D.
Représenter une vraie planète, sous forme de sphère, est donc impossible.
Cette contrainte implique une perspective s'étirant vers l'infini, ce qui n'est pas réalisable.
Il faut donc uniquement afficher une partie du monde, et dissimuler ce qui dépasse une certaine distance.
Ceci va entraîner une coupure entre l'espace modélisé et l'espace vide, tenter de cacher cette coupure au mieux est préférable.

Une approche est de disposer d'un relief montagneux distant permettant de camoufler cette coupure.
Couplé à cela une seconde technique consiste à ajouter du brouillard distant, qui permet une transition douce entre ces deux.
Unity propose une telle option pour la pipeline HDRP au travers d'un `Volume`, qui offre toutes sortes d'options graphiques, dont le brouillard.

@unity-doc-hdrp-volume
@unity-doc-hdrp-fog

Quant à la matrice filtre de chunks à charger, elle est représentée par un tableau à double dimension de booléens.
Une manière simple de la remplir est de définir une distance de vue qui détermine le rayon du cercle de chunks à charger autour du joueur.

```cs
// Création de la matrice filtre
int viewDistance = 3;
bool[,] viewGrid;
viewGrid = new bool[viewDistance * 2 + 1, viewDistance * 2 + 1];
for (int x = -viewDistance; x <= viewDistance; x++) {
    for (int y = -viewDistance; y <= viewDistance; y++) {
        if (x * x + y * y <= viewDistance * viewDistance) {
            viewGrid[x + viewDistance, y + viewDistance] = true;
        }
    }
}
```

Une autre considération à prendre en compte est la distance d'affichage de la caméra, ou far clipping plane.
Afin de disposer d'une mesure homogène entre la situation de test et celle du prototype, cette distance doit être la même.
Elle est ajustée de concert avec la distance de vue des chunks à charger et la distance du brouillard, pour un rendu cohérent entre les trois paramètres.
Seule la distance maximale du brouillard est multipliée par un facteur $4/3$ pour éviter des problèmes visuels lorsque cette distance est trop proche de la distance d'affichage de la caméra.

== Recentrer le monde

Garder le joueur au centre du monde, à un intervalle donné, demande de déplacer le monde entier et les acteurs, joueur compris, dans la direction opposée à son déplacement.
Un intervalle approprié, au vu de l'utilisation de chunks pour ce projet, est à chaque passage d'un chunk à un autre.
Ainsi, pour un déplacement du joueur d'un chunk A à B, nous avons un déplacement vectoriel de celui-ci sous la forme $delta d = arrow("AB")$.
Le déplacement de chaque acteurs et du monde est donc $-delta d = arrow("BA")$.

Cette implémentation pose néanmoins problème avec celle du chargement des chunks, qui prend en compte la position du joueur.
En effet, le déplacement du joueur, avec le recentrage du monde sur celui-ci, ne conserve pas en mémoire le déplacement effectué $arrow("AB")$ puisque sa position est réinitialisée au centre du monde.
Il faut donc garder en mémoire la position relative du joueur, et la mettre à jour pour charger les chunks correspondants.

Un autre problème avec le recentrage du joueur a été le comportement des corps physiques lors de la frame de recentrage.
Dans Unity, les calculs physiques se produisent lors de l'étape `FixedUpdate`, qui n'est exécutée qu'à des intervalles réguliers, en opposition à l'étape `Update`, qui est exécutée autant que possible, jusqu'à atteindre le framerate requis.
Pour éviter des comportements physiques aberrants il faut s'assurer de ne modifier les propriété physiques que lors des frames `FixedUpdate`.
Puisque le passage d'un chunk à un autre ne se produit que de manière ponctuelle, toute la logique de vérification de chunk se trouve dans l'étape `FixedUpdate`.
Une seconde correction a été d'attendre la prochaine frame physique `FixedUpdate` lors d'un recentrage avant de résumer celles-ci, comme d'habitude.

Quant à l'impact sur la performance qu'a cette modification, il n'est pas notable puisque seuls les objets à la racine sont modifiés.
Dans le cadre de ce projet, il n'existe qu'un seul objet à la racine de chaque `Chunk`, le `Terrain`.
Une autre limitation est que, pour pouvoir déplacer des objets, ceux-ci ne peuvent être statiques.
Un `GameObject` étant taggé comme statique, dans Unity, permet d'accélérer certaines étapes de calculs pour améliorer les performances.
Les étapes concernées ont trait au pathfinding, à la lumière précalculée, et à l'utilisation d'occlusion culling.
Pour ce projet, aucun de ces trois éléments n'ont été implémentés, mais dans le cas d'un jeu en monde ouvert certaines de ces techniques pourraient être utiles.

@unity-doc-script-execution-order

== LOD

Unity dispose d'un composant appelé `LOD Group` qui permet d'automatiser le changement de niveau de détail d'un modèle 3D en fonction de la distance à la caméra.
Ceux-ci prennent plusieurs GameObjects en argument, un par niveau de détail.
De plus, pour chaque niveau de détail une distance maximale doit être définie indiquant quand la caméra devra changer le niveau de détail.
Si plus aucun niveau de détail n'est défini et que la distance maximale n'est pas infinie, alors le modèle 3D sera complètement désactivé via culling.

À noter que les éléments logiques sont totalement indépendants des éléments graphiques puisque le maillage de collision physique est un modèle 3D encore plus simplifié que ceux basses résolutions utilisé pour les LODs.
Finalement, il est possible de disposer d'un Cross Fade entre deux niveaux de détails en spécifiant les distances de transitions, via dithering ou transparence.

Quant à la génération de LODs, puisque ceux-ci possèdent une topologie différente des modèles 3D originaux, il n'est pas possible de conserver les textures existantes pour ceux-ci, puisque le mappage UV ne correspondra plus.
Pour des modèles non texturés, un simple modificateur decimate sous Blender pourrait suffire, mais une extension telle que `Level Of Detail Generator | Lods Maker` permet de simplifier et automatiser la tâche.
C'est pour cette raison d'incompatibilité des textures entre les LODs, que des assets existantes ont été utilisées pour ce projet.
Ces assets contiennent 2 ou 3 niveau de détails.

En raison de l'architecture du projet, bien qu'il serait possible de disposer d'une série de chunks peuplés de modèles 3D avec et sans LOD, ceci requière néanmoins un duplicata des ressources `Scenes`, `ScriptableObjects`, et `Prefabs`.
L'alternative qui a été choisie est de changer, lors du chargement d'un chunk, les LODs pour les forcer à un certain niveau de détail, ici LOD 0, le plus détaillé.
Ceci ajoute un overhead CPU lors de la frame physique de chargement des chunks.
Il s'agit donc d'un compromis entre fidélité de résultats de tests et simplicité d'architecture.

Malheureusement, la répétition de plusieurs d'opérations `GetComponent` est coûteuse.
Procéder de la sorte implique une complexité d'appel à `GetComponent` en $O(n)$, où $n$ est le nombre d'objets dans le `Chunk`. 
Pour pallier à cela, un script C\# `Chunk` contenant les informations relatives à chaque chunk, permet un accès rapide aux composants.
Ce script a une complexité $O(1)$ en opération `GetComponent` pour chaque `Chunk` à charger.
À noter néanmoins qu'une itération sur tous les objets d'un `Chunk` est tout de même nécessaire.

@blender-lod-maker

== Imposteurs

Unity considère ajouter une solution officielle d'imposteurs, mais celle-ci n'est pas encore planifiée au contraire des nombreuses autres fonctionnalités présentes sur la roadmap du moteur de jeu.
En l'absence d'une solution unique officielle, plusieurs tentatives d'implémentations ont été faites.

@unity-roadmap

=== IMP

Parmi les solutions existantes pour des imposteurs dans Unity, le répertoire public IMP propose, pour la pipeline Standard, une solution complète.
Ce répertoire a également été forké pour URP sous le nom de URPIMP.
Mais ce répertoire URP a été archivé et manque de fichiers pour atteindre un niveau fonctionnel.

Une première tentative a été de porter IMP vers HDRP.
Mais coder des shaders HDRP est bien plus complexe car Unity favorise l'usage de l'outil Shader Graph pour créer des Shaders à l'aide de noeuds.

Cette solution a été mise de côté, tandis que d'autres essais ont été explorés.

@imp
@urpimp

=== Approche naïve

Une seconde tentative a été d'implémenter des imposteurs de manière naïve.
Ceux-ci seront représentés sous la forme de billboards en runtime affichant l'objet capturé distant à l'aide d'un script C\#.
Ceci a comme avantage de pouvoir rapidement prototyper au coût de performances plus basses.
Cette approche a été proposée en tant que Proof of Concept.
Pour un imposteur en runtime, deux paramètres sont nécessaires :
- la distance à partir de laquelle l'imposteur est activé
- la différence d'angle à partir duquel un rafraîchissement de l'imposteur est effectué

De plus, un imposteur doit posséder une `RenderTexture` qui rendra ce qu'une caméra voit.
Cette caméra est différente de celle du joueur puisqu'elle ne rendra que les modèles sujets à être des imposteurs.
Elle sera orientée vers l'objet à rendre, dont la taille totale à rendre est connue par les limites du modèle 3D.
Le FOV et la position de la caméra sont ensuite ajustés de manière à cadrer l'objet à rendre dans la `RenderTexture`.

La pipeline HDRP requière néanmoins un paramétrage précis.
À savoir : Il faut sélectionner le format `R16G16B16A16_UNORM` pour la `RenderTexture`.
Il faut également choisir, dans les paramètres du projet, le format de couleur `R16G16B16A16` afin de supporter la transparence.
Ce format de couleur pour le projet est deux fois plus lourd en mémoire que celui par défaut `R11G11B10` en utilisant 64 bits plutôt que 32 bits pour chaque couleur.
Le format correspondant, en terme d'API de script Unity, est appelé `RGBAHalf`.

Une fois ceci fait, la texture rendue est affichée sur un `Quad`, un modèle 3D représentant un plan constitué de deux triangles, qui est lui également redimensionné pour correspondre aux limites du modèle 3D.

```cs
float angleToRefresh = 10f, distanceFromCamera = 50f;
bool isEnabled = false, lastAngleRefreshed = false;
// Comportement des imposteurs
if (distance(cam.position, position) > distanceFromCamera) {
    float angle = Angle(this.forward, cam.position - position); 
    if (!isEnabled || angle > angleToRefresh) {
        lastAngleRefreshed = angle;
        ToggleImpostor(true);
        RefreshImpostor();
    }
} else if (isEnabled) {
    ToggleImpostor(false);
}
```

=== Amplify Impostors

Finalement, une solution payante mais constituant, en soi, l'état de l'art pour Unity est celle proposée par Amplify.
Cet outil s'est révélé être aisé à prendre en main et de qualité significative.
Les jours de travail dédiés aux tentatives d'implémentations des imposteurs auraient pu être économisées en utilisant ce plugin dès le début.

Amplify Impostors propose des imposteurs de plusieurs types : sphérique, octahèdre ou semi-octahèdre.
Ceux-ci sont baked dans cinq fichiers de texture allant de 32x32 à 8192x8192 pixels.
Ces textures permettent un meilleur rendu visuel mais ont une incompatiblité au niveau des shaders.
Les shaders utilisés par les matériaux des modèles à afficher en tant qu'imposteurs doivent exposer un chemin `Deferred`, à la manière des shaders Unity par défaut.
Le cas échéant, un shader personnalisé de baking devra être écrit pour chaque shader de matériel utilisé.

C'est ce qui s'est produit pour un asset utilisé dans le prototype. 
Convertir ses matériaux en matériaux standards HDRP a permis de résoudre le problème.

Pour l'implémentation, les imposteurs Amplify se greffent sur un `LOD Group` existant.
Les imposteurs seront considérés comme $"LOD" n + 1$ où $n$ est le nombre de LODs déjà présents.
Il est également possible de choisir que les imposteurs remplacent le niveau de $"LOD" n$.

À noter que, de la même manière que l'implémentation pour le LOD, les imposteurs sont implémentés au niveau des `Prefabs` pour une architecture simplifiée.
Cela a donc comme le même désavantage, lorsque les imposteurs sont désactivés, de devoir parcourir chaque instance de `Prefab` pour désactiver ceux-ci lors du chargement d'un chunk. Cet overhead CPU a néanmoins comme complexité d'opération `GetComponent` en $O(1)$, à la manière du chargement des LODs désactivés.

@amplify-impostors

#figure(
  image("images/impostor_example_atlas.jpg", width: 50%),
  caption: [
    Exemple d'un atlas albedo pour des imposteurs octahèdres résultant de Amplify Impostors.
  ],
)

== Optimisations GPU

L'outil de statistiques de rendu disponible dans l'éditeur de Unity permet de visualiser rapidement les performances.


#figure(
  image("images/GameViewStats.png", width: 60%),
  caption: [
    Fenêtre de statistiques de rendu dans l'éditeur.
  ],
)

Voici les données les plus intéressantes parmi ces statistiques :
- FPS et CPU sont liés et représentent la même mesure, de deux manières différentes.

  $"FPS" = 1/"CPU"$

  FPS est le nombre de frames par secondes, tandis que CPU est le temps de rendu d'un frame en millisecondes.
  Le temps de rendu de la frame est une meilleure mesure, dans le contexte d'une frame unique, mais est moins parlant que celle des FPS.
  Le plus haut les FPS sont, le mieux c'est, et inversement le plus bas le temps CPU est, le mieux c'est.
- Batches correspond au nombre total de batches de draw call effectués durant une frame.
  Le plus bas, le mieux c'est.
- Saved by batching correspond au nombre de batches que Unity a pu combiner entre deux batches.
  Cela se produit lorsqu'un `Material` est partagé entre plusieurs objets.
  Cela se produit lorsque le GPU instancing est utilisé.
  Le plus haut, le mieux c'est.
- SetPass calls correspond au moment où Unity charge un nouveau shader du CPU au GPU.
  Le plus bas, le mieux c'est.
- Tris et Verts correspondent, respectivement, au nombre de triangles et de sommets rendus.
  Le plus bas, le mieux c'est.

@unity-doc-rendering-stats

=== GPU Instancing

Dans des moteurs de jeux tels que Unity, cette technique est déjà implémentée par les shaders par défaut et peut être activée individuellement pour chaque matériel utilisant ce shader.

@unity-doc-gpu-instancing

=== SRP Batcher

SRP Batcher est une manière de préparer et transmettre les données qui est incompatible avec GPU Instancing.
Cette méthode est uniquement possible avec les Scriptable Render Pipeline de Unity, dont URP et HDRP font partie.
Elle consiste à réduire le nombre de render-state effectué entre deux appels via l'utilisation d'un buffer.
Ces opérations sont en effet coûteuse puisqu'un nouveau `Material` doit être transmis à chaque fois du CPU au GPU.
Ici, le SRP Batcher va garder un lien persistent vers un buffer `Material` jusqu'à ce qu'une nouvelle variante soit utilisée et provoque un rafraîchissement du buffer.
Cette méthode est donc plus efficace en cas de peu d'utilisation de variantes de `Material`.

Le SRP Batcher dispose d'un accès permettant une mise à jour directe du buffer du GPU.

#figure(
  image("images/SROShaderPass.png", width: 100%),
  caption: [
    Préparation d'un batch pour un draw call vs SPR Batcher
  ],
)

@unity-doc-srp-batcher

=== DOTS

Data Oriented Technology Stack est l'implémentation dans Unity d'un pattern ECS afin de pouvoir traiter une grande quantité de données.
Cela découple la logique des Entités, de celles des Composants et des Systèmes.
Il est également possible d'utiliser DOTS pour améliorer le rendu graphique en cas de nombreux objets à rendre dans une scène.
Les fonctionnalités attendues des pipelines URP et HDRP ne sont néanmoins pas toutes implémentées dans DOTS.

DOTS est un système complexe permettant de traiter la logique de nombreux éléments.
Malgré la promesse de pouvoir améliorer les performances en cas de nombreux objets, il n'a pas été jugé pertinent de l'utiliser pour ce projet, son utilisation dépassant de loin le cadre de celui-ci.

@unity-entities
@unity-entities-graphics

=== Cas d'étude

Pour le cas d'étude choisi, des brins d'herbe, plusieurs solutions existent pour les représenter.
Il existe notamment plusieurs solutions pour les instancer au travers de l'outil `Terrains`.
- Mesh.
  Il est assez intuitif de vouloir représenter des brins d'herbe via des modèles 3D.
  Bien que l'on puisse envisager dans un premier temps de modéliser chaque brin d'herbe en 3D, il existe une meilleure solution, comme le montre le package de démonstration officiel de Unity TerrainDemoScene HDRP.
  Il convient d'utiliser la transparence de textures pour simuler le volume.
  Les brins d'herbe sont, en réalités, des `Quads` complexes.
  Pour les `Terrains` dans Unity, cette solution correspond à l'option `Detail Mesh`.
- Billboard.
  Pour éviter de ne disposer que de brins d'herbes plats il est possible de disposer de plusieurs `Quads` pour chaque brin d'herbe.
  Chacun de ces `Quads` seront orientés de manière régulière autour de l'axe Y afin de donner l'illusion du volume.
  Pour les `Terrains`, cette solution correspond à l'option `Grass Texture`.
  Cette option n'est pas disponible pour HDRP malheureusement.
- Geometry Shader.
  Cette solution consiste à modéliser individuellement chaque brin d'herbe, à l'aide des shaders.
  Les geometry shaders sont néanmoins bien plus complexes à mettre en place et plus demandants en performance.
  Écrire de tels shaders ne peut être fait qu'en HLSL ou ShaderLab pour URP et HDRP.

À noter que Unity URP et HDRP proposent un outil d'édition de shaders par noeuds, appelé Shader Graph, mais que celui-ci ne traite que des opérations Vertex et Fragment.
VFX Graph, un système complexe permettant de simuler des particules, pourrait être utilisé pour représenter des brins d'herbe, mais cela est un usage détourné de l'outil.

==== Grass Mesh

Unity Technologies met à disposition de nombreuses assets libre d'usage à fin de démontrer l'usage et la puissance de leur outils.
Le package TerrainDemoScene HDRP propose un exemple d'implémentation d'herbe, pour la pipeline HDRP.
Celui-ci est basé sur les meshes, via des Terrain Details.

En l'état, ces buissons, plus que brins d'herbe, ne comportent pas d'imposteurs ni de `LOD Group` et sont donc très coûteux en performance.
Leur affichage se fait via le `Terrain` sur lequel ils sont placés, et celui-ci possède des options de distance d'affichage pour les détails.

#figure(
  image("images/grass_mesh.jpg", width: 55%),
  caption: [
    Exemple d'un buisson d'herbe et de son maillage, représenté par Mesh.
  ],
)

==== EmmetOT HDRPGrass

Ce répertoire public propose deux shaders utilisant l'étape de Geometry pour représenter de nombreux brins d'herbes.
Un patchage de ce répertoire a été requis pour le rendre compatible avec les versions d'outils modernes, cet outil n'ayant pas été mis à jour depuis 2021.

Deux shaders sont proposés :
- L'étape Tesselation est utilisée pour subdiviser le maillage d'un objet en des points où des brins d'herbe seront placés.
  C'est une solution assez complexe mais qui est aussi simple à implémenter que d'assigner un `Material` à un objet.
- Une alternative plus simple, Compute, génère des points aléatoires sur une surface. 
  Cette solution ne se base pas que sur un `Material` mais demande à un script C\# de générer le maillage subdivisé de manière préliminaire.
  Cela ne s'adapte donc pas pour les modèles sujets à des modifications en runtime, sous peine de devoir recalculer le maillage à chaque fois. 

@emmetot-hdrpgrass

#figure(
  image("images/hdrpgrass_compute.png", width: 60%),
  caption: [
    Exemple d'herbe représenté à l'aide du shader Compute de EmmetOT HDRPGrass.
  ],
)

==== Bruteforce Grass Shader

Cette solution disponible sur le Unity Asset Store n'en est qu'une parmi de nombreuses autres, mais elle offre un support HDRP via geometry shader.
Elle est de plus compatible avec les `Terrains` et permet plusieurs types d'interaction tels qu'un aplatissement suivant le parcours d'un agent, ou même une coupe de l'herbe.

Son implémentation a été assez aisée mais est adaptée à des plus petites tailles de terrains, telles que 50x50.

@bruteforce-grass-shader

#figure(
  image("images/bruteforce_shader_grass.jpg", width: 60%),
  caption: [
    Exemple d'un terrain dont l'herbe est représenté par Bruteforce Grass Shader.
  ],
)

== Mesures de performance

=== Graphy

Pour mesurer les performances lors d'un build, bien qu'il soit possible, pour un build local, de le connecter au profiler Unity pour débugger, il est néanmoins plus agréable de profiter d'une solution visuelle permettant, en un coup d'oeil, de voir une estimation de la performance du jeu.

Un tel outil existe sous le nom de Graphy, 
Cet outil permet de visualiser sous forme de graphe les performances pour les dernières frames afin d'observer les variations soudaines.

Des raccourcis uniques à cet outil permettent de :
- cycler dans les options de profiler : `ctrl + F10`
- activer/désactiver le profiler : `ctrl + F11`

Une scène de démonstration permet de comparer les performances de plusieurs techniques sous la forme d'un benchmark.
Dans cette scène sont comparé les différentes implémentations d'herbe, ainsi que les imposteurs.

@unity-graphy

#figure(
  table(
    columns: 2,
    table.header[Implémentation][FPS moyen],
    "Écran vide", "~150",
    "Mesh", "~100",
    "Tesselation Shader", "~150",
    "Compute Shader", "~100",
    "BruteForce Grass Shader", "~150",
  ),
  caption: "Comparaison des performances des différentes implémentations d'herbe."
)

Ceci permet de constater que le compute shader est plus demandant que prévu; il est aussi peu optimisé que des simples meshes sans imposteurs.

#pagebreak()

=== Unity Test Framework

L'implémentation de tests à l'aide de Unity Test Framework requière des annotations spécifiques sur les méthodes de test afin de spécifier les conditions dans lesquelles elles seront exécutées.
L'annotation `TestFixture` est utilisée pour une classe de test tandis que celle `Test` pour les fonctions signifie que celle-ci est un test.
On différencie les tests en mode Edit, en mode Play, ou via un Player pour simuler différentes plate-formes.

#codly(languages: codly-languages)
```cs
[TestFixture]
public class SimpleTests {
  // Load a Prefab located in Resources folder
  private GameObject prefab = Resources.Load<GameObject>("Prefab");

  [Test]
  public void TestInstantiation() {
    GameObject instance = GameObject.Instantiate(prefab, Vector3.zero, Quaternion.identity);
    Assert.That(instance, !Is.Null);
  }
}
```

Créer des test, par contre, requière de créer une Assembly pour les tests.
Les Assemblies en C\# sont des collections de ressources compilées consistant en une unité logique de fonctionnalité.
L'avantage des Assemblies est de diviser un large projet en plusieurs petites unités afin de réduire le temps de compilation à long terme.
Les Assemblies n'ayant pas été modifiées depuis la dernière compilation ne sont en effet pas recompilées.

Afin de pouvoir référencer les méthodes des scripts existants dans le projet, il est nécessaire de disposer d'une seconde Assembly, pour les scripts du jeu lui-même.

Les tests de performance, eux, permettent de mesurer plusieurs frames et d'évaluer la durée de chaque frame via un histogramme, pour chaque test.
En raison de la capture de plusieurs frames, les méthodes de test utilisent l'annotation `UnityTest` et retourne un IEnumerator.

Les IEnumerator dans Unity permettent à des fonctions d'être exécutées sur plusieurs frames.
Cette structure retourne, pour chaque yield, une fonction à exécuter.
Lorsqu'une fonction retourne null, Unity attend la frame suivante pour continuer l'exécution de la fonction appellante, celle retournant un IEnumerator.

```cs
[UnityTest, Performance]
public IEnumerator MoveForward_PerformanceTest() {
  yield return new wait for seconds(3);
  using (Measure.Frames()
              .WarmupCount(_warmUpCount)
              .MeasurementCount(_measurementCount)
              .Scope()) {
      for (int i = 0; i < _measurementCount; i++) {
          GameManager.Instance.ChunkManager.Player.transform.position += Vector3.forward * _moveDistance);
          yield return null;
      }
  }
}
```

L'implémentation du package Input System pour les test s'est révélé bien plus complexe que prévu.
En effet, les tests de performance de Unity ne s'effectuent pas exactement selon le pattern AAA - Arrange, Act, Assert.
Des états sont permanents entre deux tests, notamment tout ce qui est du chargement de scènes.
La manière dont les entrées utilisateurs sont simulées est également sujette à cette permanence.
Ainsi, pour s'assurer que deux tests possèdent les mêmes conditions il faut passer par deux autres annotations `Setup` et `TearDown` qui indiquent respectivement les actions à effectuer avant et après chaque test.

Quant à la plus-value d'utiliser Input System, elle est moindre dans le cadre des tests de performance, ici le coeur de ce projet.
Aussi, après plusieurs essais infructueux de son implémentation, ajoutant une couche de complexité aux tests, il a été décidé de ne pas utiliser Input System.

Conditions de test :
- Les tests ont été réalisés avec une distance d'affichagee de 25 chunks, sauf dans le cas du test `ChunkLoading`.
- Il n'y a pas de recentrage du monde effectué
- Les tests `Impostors`, ou `Imp.` nécessitent également l'utilisation de LODs.
  Ils ne sont donc pas représentables des imposteurs seuls.
- Deux tests d'imposteurs existent afin de comparer les performances avec GPU Instancing, la technique présente par défaut dans tous les autres tests, ou avec SRP Batcher.

==== Résultats

#figure(
  grid(
    columns: 2,
    image("images/NoOptimization.jpg", width: 88%),
    image("images/LOD.jpg", width: 88%),
  ),

  caption: [
    À gauche, statistiques sans aucune optimisation.
    
    À droite, statistiques avec LOD.
  ],
)

#figure(
  grid(
    columns: 2,
    image("images/ImpostorsGPU.jpg", width: 88%),
    image("images/ImpostorsSRP.jpg", width: 88%),
  ),

  caption: [
    À gauche, statistiques imposteurs et GPU Instancing.
    
    À droite, statistiques imposteurs et SRP Batcher.
  ],
)

#figure(
    image("images/ChunkLoading.jpg", width: 50%),

  caption: [
    Statistiques chunk loading.
  ],
)

#let parse_performance_data() = {
  let content = read("diagrams/PerformanceTestResults.csv")
  
  let lines = content.split("\n").filter(line => line.trim().len() > 0)
  let start_idx = if lines.at(0).starts-with("//") { 1 } else { 0 }
  let headers = lines.at(start_idx).split(",").map(s => s.trim())
  
  let data = ()
  for (i, line) in lines.slice(start_idx + 1).enumerate() {
    if line.trim() == "" { continue }
    
    let parts = line.split(",")
    if parts.len() < 9 { continue } // Skip malformed lines
    
    let row = (:)
    
    // Extract the basic first fields
    for j in range(9) {
      row.insert(headers.at(j), parts.at(j))
    }
    
    let values_str = parts.slice(9).join(",")
    let values = if values_str.trim() != "" {
      values_str.split(",")
        .filter(s => s.trim() != "")
        .map(s => float(s.trim()))
    } else {
      ()
    }
    
    row.insert("Values", values)
    
    data.push(row)
  }
  
  return (headers: headers, data: data)
}

#import "@preview/lilaq:0.4.0" as lq

#let compare_test_across_categories(test_name, data) = {
  let categories = (:)
  for row in data {
    let full_test_name = row.at("Test Name")
    let parts = full_test_name.split(".")
    
    if parts.len() >= 3 {
      let category = parts.at(1)
      let method = parts.at(2)
      method = method.slice(0, method.len() - 1)
      
      if method == test_name {
        let values = row.at("Values")
      
        categories.insert(category, values)
      }
    }
  }
  
  let category_names = categories.keys().sorted()
  let values = category_names.map(cat => categories.at(cat))
  category_names = category_names.map(cat => cat.replace("Tests", ""))
  category_names = category_names.map(cat => cat.replace("ChunkLoading", "Chunk Loading"))
  category_names = category_names.map(cat => cat.replace("ImpostorsGPUInstancing", "Imp. GPU I."))
  category_names = category_names.map(cat => cat.replace("ImpostorsSRPBatcher", "Imp. SRP B."))
  category_names = category_names.map(cat => cat.replace("NoOptimization", "No Opt."))
  category_names.insert(0, "")

  lq.diagram(
    xaxis: (
      ticks: category_names
        .map(text.with(size: 0.8em))
        .map(rotate.with(-45deg, reflow: true))
        .map(align.with(right))
        .enumerate(),
      subticks: none,
    ),
    yaxis: (
      label: text(test_name + " [ms]", size: 0.8em),
    ),
    lq.boxplot(
      stroke: blue.darken(50%),
      outliers: none,
      ..values
    )
  )

  return
  lq.boxplot(
    stroke: blue.darken(50%),
    (1, 2, 3, 4, 5, 6, 7, 8, 9, 21, 19),
    range(1, 30),
    (1, 28, 25, 30),
    (1, 2, 3, 4, 5, 6, 32),
  )
}

#let data = parse_performance_data()

#pagebreak()

#figure(
  grid(
    columns: 2,
    rows: 3,
    compare_test_across_categories("HorizontalPan", data.data),
    compare_test_across_categories("FastHorizontalPan", data.data),
    compare_test_across_categories("MoveForward", data.data),
    compare_test_across_categories("MoveFast", data.data),
    compare_test_across_categories("BackAndForth", data.data),
    compare_test_across_categories("Teleport", data.data),
  ),

  caption: [Comparaison des statistiques, par test.],
)

#pagebreak()

==== Discussion des résultats

Le test Teleport est de loin le test le plus demandant avec un changement différent de chunk à chaque frame.
Pour toutes les catégories de tests, possédant de l'optimisation, ou non, le test Teleport connaît la plus haute variance.
Il s'agit du résultat escompté en raison de sa fréquence attendue faible lors d'une séquence de gameplay habituel.

Chaque technique d'optimisation réduit significativement le temps dédié à chaque frame.
Sans aucune technique d'optimisation, le temps CPU est deux à trois fois plus grand qu'avec les techniques d'optimisation.

Il n'y a que peu de différences entre `GPU Instancing` et `SRP Batcher`.
Ceci peut s'expliquer par le fait que le prototype n'offre pas de situation apropriée où chacune de ces techniques pourrait briller indépendamment.

Entre `LOD` et `Impostors` il n'y a également que peu de différences.
Les imposteurs permettent de néanmoins réduire le temps de calcul par frame par un sixième en moyenne.
Cette différence mineure peut être expliquée par le fait que les imposteurs sont davantages efficaces pour des maillages complexes, typiquement de la végétation, et ce prototype en est dépourvu à longue distance au vu du paysage désertique, d'autant plus que les modèles distants sont ignorés et non rendus passé une certaine distance.

`Chunk Loading` est de loin la technique la plus efficace en raison de la distance d'affichage réduite considérable.
De plus, le nombre restreint de chunks à charger est également bénéfique.
Diminuer la distance d'affichage permet très rapidement d'atteindre des bons résultats, bien que légèrement moins bons dans le cas d'allers et retours rapides.
En effet, `Chunk Loading` devra charger et décharger à répétition les mêmes chunks, tandis que dans les autres cas, ceux-ci sont déjà chargés en tout temps.
Cette différence n'est pas observable au niveau de `Teleport` car celui-ci est demandant pour toutes les techniques en terme de rendu.
