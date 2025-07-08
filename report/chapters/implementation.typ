= Implémentation <implementation>

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

== Prototype

Des assets provenant du Unity Asset Store et de Fab ont été utilisées pour le prototype.
Ces assets sont listées et leur license est détaillée dans le fichier `unity/assets/CREDITS.md`

Un premier contrôleur physique pour le joueur, assez sommaire, permet de facilement tester le chargement du monde.
Celui-ci a été complètement remplacé par un second contrôleur, plus abouti, simulant la physique d'un hovercraft pour qu'il adhère au terrain.

En raison de la contrainte de la taille de fichier maximum de 100Mo pour les assets, il a été requis de séparer la scène principale en plusieurs scènes, ou chunks, dès le début.
En effet, peupler un terrain de 8000x8000m avec toutes sortes de `Prefabs` atteint cette limite de taille de fichier.
Réaliser le prototype final a donc requis d'implémenter la partie du chargement de chunks.
Ainsi, la réalisation ne s'est pas produite de la manière prévue initialement, mais d'avantage sous la forme d'un aller et retour constant entre les prototype et optimisation de performance.
Les tests de performance ont effectués à la fin du projet, plutôt qu'après chaque étape du projet.

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
Cette liste est utilisée afin de garder en mémoir les chunks chargés, et de pouvoir les décharger par la suite.

Une première modification consiste à n'ajouter et à supprimer dans la liste des chunks chargés que lorsque ceux-ci sont effectivement chargés ou déchargés, soit après réussite de l'opération asynchrone.
Ceci est fait via une écoute de l'événement confirmant la fin de l'opération de chargement ou déchargement du chunk.

De plus, pour accéder aux scènes plus rapidement, un double tableau `sortedScenes` contenant le nom des scènes correspondant aux des chunks est utilisé.
Les indices x et y de celui-ci représentent les coordonnées du chunk, pour un accès plus rapide.
Ce tableau est créé une seule fois lors de l'initialisation de la scène composant le monde.
Cette solution a été envisagée en raison de la taille limitée du monde.

Avec cette structure, il est facile d'itérer sur les chunks chargés et de décharger ceux qui ne sont plus nécessaire.

```cs
string[,] sortedScenes;
// Déchargement des chunks
List<Vector2Int> chunksLoaded = new List<Vector2Int>();
List<Vector2Int> chunksToUnload = FindChunksToUnload();
foreach (var coords in chunksToUnload) {
    AsyncOperation unloadOperation = SceneManager.UnloadSceneAsync(sortedScenes[coords.x][coords.y]);
    unloadOperation.completed += _ => { chunksLoaded.Remove(coords); };
}
```

Pour régler d'autres problèmes de concurrence lors du chargement des chunks, le calcul du positionnement des chunks en fonction de la position du joueur n'est effectué qu'une fois l'opération de chargement terminée.
Ce problème est survenu après l'implémentation du recentrage du monde, dont le code n'est pas détaillé

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

=== Distance d'affichage

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

== Recentrer le monde

Garder le joueur au centre du monde, à un intervalle donné, demande de déplacer le monde entier et les acteurs, joueur compris, dans la direction opposée à son déplacement.
Un intervalle approprié, au vu de l'utilisation de chunks pour ce projet, est à chaque passage d'un chunk à un autre.
Ainsi, pour un déplacement du joueur d'un chunk A à B, nous avons un déplacement vectoriel de celui-ci sous la forme $delta d = arrow("AB")$.
Le déplacement de chaque acteurs et du monde est donc $-delta d = arrow("BA")$.

Cette implémentation pose néanmoins problème avec celle du chargement des chunks, qui prend en compte la position du joueur.
En effet, le déplacement du joueur, avec le recentrage du monde sur celui-ci, est de la forme : $(0, 0) arrow arrow("AB") arrow (0, 0)$.
Il faut donc garder en mémoire la position relative du joueur, et la mettre à jour pour charger les chunks correspondants.

```cs
bool recenterChunks = true;
Vector2Int gridOffset = Vector2Int.one * 8; // position initiale du joueur en tant qu'offset dans la grille
// Recentrage du monde
Vector3 playerPos = Player.transform.position;
Vector2Int currentGridPos = GetGridPosition(playerPos);
if (recenterChunks && currentGridPos != gridOffset) {
    Vector2Int diff = currentGridPos - gridOffset;
    Vector3 worldOffset = new Vector3(diff.x * gridSize.x, 0, diff.y * gridSize.y);

    foreach (var coords in _chunksLoaded) {
        Scene loadedScene = SceneManager.GetSceneByName(_sortedScenes[coords.x][coords.y]);
        foreach (var rootObj in loadedScene.GetRootGameObjects()) {
            rootObj.transform.position -= worldOffset;
        }
    }

    Player.MoveToPosition(playerPos - worldOffset);
    _playerGridPos += diff;
    UpdateLoadedChunks();
} else if (!recenterChunks && currentGridPos != _playerGridPos) {
    _playerGridPos = currentGridPos;
    UpdateLoadedChunks();
}
```

Un autre problème avec le recentrage du joueur a été le comportement des corps physiques lors de la frame de recentrage.
Dans Unity, les calculs physiques se produisent lors de l'étape `FixedUpdate`, qui n'est exécutée qu'à des intervalles réguliers, en opposition à l'étape `Update`, qui est exécutée autant que possible, jusqu'à atteindre le framerate requis.
Pour éviter des comportements physiques aberrants il faut s'assurer de ne modifier les propriété physiques que lors des frames `FixedUpdate`.
Puisque le passage d'un chunk à un autre ne se produit que de manière ponctuelle, toute la logique de vérification de chunk se trouve dans l'étape `FixedUpdate`.

Quant à l'impact sur la performance qu'a cette modification, il n'est pas notable puisque seuls les objets à la racine sont modifiés.
Dans le cadre de ce projet, il n'existe qu'un seul objet à la racine de chaque `Chunk`, le `Terrain`.
Une autre limitation est que, pour pouvoir déplacer des objets, ceux-ci ne peuvent être statiques.
Un `GameObject` étant taggé comme statique, dans Unity, permet d'accélérer certaines étapes de calculs pour améliorer les performances.
Les étapes concernées ont trait au pathfinding, à la lumière précalculée, et à l'utilisation d'occlusion culling.
Pour ce projet, aucun de ces trois éléments ne sont utilisés, mais dans le cas d'un jeu en monde ouvert certaines de ces techniques pourraient être utiles.

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
Ceci ajoute un léger overhead CPU lors de la frame physique de chargement des chunks, mais ceci n'impactera que les performances du prototype non optimisé.

Il s'agit donc d'un compromis entre fidélité de résultats de tests et simplicité d'architecture.
Après des rapides tests, il s'est avéré que ce compromis était strictement positif puisque la baisse de performance sur la frame physique attendue n'était que peu notable malgré le coût de l'opérattion `GetComponent`.
Une optimisation supplémentaire serait de passer par un Manager pour chaque `Chunk` qui ferait le pont entre `ChunkManager` et `LOD Group`.
Celui-ci contiendrait déjà les informations nécessaires, sauvegardées au préalable.

```cs
if (!enableLOD) {
    foreach (var lodGroup in terrainObj.GetComponentsInChildren<LODGroup>(true)) {
        lodGroup.ForceLOD(0);
    }

    Terrain terrain = terrainObj.GetComponent<Terrain>();
    terrain.forceLOD(0);
}
```

@blender-lod-maker

== Imposteurs

Le problème que les imposteurs tentent de résoudre est celui de l'overdraw.

=== IMP

Parmi les solutions existantes pour des imposteurs dans Unity, le répertoire public IMP propose, pour la pipeline Standard, une solution complète.
Ce répertoire a également été forké pour URP sous le nom de URPIMP.
Mais ce répertoire a été archivé et manque des fichiers pour parvenir à un niveau fonctionnel.

Une première tentative a été de porter IMP vers HDRP.
Mais coder des shaders HDRP est bien plus complexe car Unity favorise l'usage de l'outil Shader Graph pour créer des Shaders à l'aide de noeuds.

@imp
@urpimp

=== Approche naïve

Une seconde tentative a été d'implémenter des imposteurs de manière naïve, sous la forme billboards représentant l'objet capturé distant à l'aide d'un script C\#.
Ceci a comme avantage de pouvoir rapidement prototyper au coût de performances plus basses.
Cette approche a été proposée en tant que Proof of Concept.
Pour un imposteur en runtime, deux paramètres sont nécessaires :
- la distance à partir de laquelle l'imposteur est activé 
- la différence d'angle à partir duquel un rafraîchissement de l'imposteur est effectué

De plus, un imposteur doit posséder une `RenderTexture` qui rendra ce qu'une caméra voit.
Cette caméra est différente de celle du joueur puisqu'elle ne rendra que les modèles sujets à être des imposteurs.
Cette caméra sera orientée vers l'objet à rendre, dont la taille totale à rendre est connue par les limites du modèle 3D.
Le FOV et la position de la caméra sont ensuite ajustés de manière à cadrer l'objet à rendre dans la `RenderTexture`.

La pipeline HDRP requière néanmoins un paramétrage précis.
À savoir : Il faut sélectionner le format `R16G16B16A16_UNORM` pour la `RenderTexture`.
Il faut également choisir, dans les paramètres du projet, le format de couleur `R16G16B16A16` afin de supporter la transparence.
Ce format de couleur pour le projet est deux fois plus lourd en mémoire que celui par défaut `R11G11B10` en utilisant 64 bits plutôt que 32 bits pour chaque couleur.
Le format correspondant, en terme d'API de script Unity, est appelé `RGBAHalf`.

Une fois ceci fait, la texture rendu est affichée sur un `Quad`, un modèle 3D représentant un plan constitué de deux triangles, qui est lui également redimensionné pour correspondre aux limites du modèle 3D.

```cs
float angleToRefresh = 10f;
float distanceFromCamera = 50f;
bool isEnabled = false;
float lastAngleRefreshed;
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

Finalement, une solution payante mais très efficace et utilisée à titre professionnel pour une fonctionnalité pareille est celle proposée par Amplify.
Cet outil s'est révélé être aisé à prendre en main et de qualité significative.
Les jours de travail dédiés aux tentatives d'implémentations des imposteurs auraient pu être économisées en utilisant ce plugin dès le début.

Amplify Impostors propose des imposteurs de plusieurs types : sphérique, octahedron ou mi-octahedron.
Ceux-ci sont pré calculés dans un fichier de texture allant de 32x32 à 8192x8192 pixels.
Un modèle d'imposteur peut ensuite être aujouté pour chaque objet possédant `LOD Group`.
Les imposteurs seront considérés comme $"LOD" n + 1$ où $n$ est le nombre de LODs existants.
Il est également possible de choisir que les imposteurs remplacent le niveau de $"LOD" n$.

À noter que, de la même manière que l'implémentation pour le LOD, les imposteurs sont implémentés au niveau des `Prefabs` pour une architecture simplifiée.
Cela a donc comme même désavantage, lorsque les imposteurs sont désactivés, de devoir parcourir chaque instance de `Prefab` pour désactiver ceux-ci lors du chargement d'un chunk.

#figure(
  image("images/impostor_example_atlas.jpg", width: 52%),
  caption: [
    Atlas d'imposteurs résultant de Amplify Impostors.
  ],
)

@amplify-impostors

== Optimisations GPU

=== GPU Instancing

Un problème fréquemment rencontré dans les jeux vidéo est l'affichage d'une large quantité d'objets 3D identiques, tels que des brins d'herbe ou des arbres.

Pour chaque objet à représenter le CPU communique avec le GPU, et ceci représente un goulot d'étranglement pour les performances.
En effet, bien que le GPU soit très puissant pour de nombreux calculs répétitifs, transmettre de nombreuses informations de CPU à GPU est une opération coûteuse.

Une solution habituellement utilisée est de diminuer les appels de rendu, ou draw call, via une instantiation de données sur le GPU.
Ceci est d'avantage connu sous le nom de GPU Instanting.
Au lieu de transmettre les informations de maillage et de matériaux à chaque fois, il est possible, pour un même modèle 3D, de transmettre uniquement les informations uniques à chaque instance de celui-ci, telles que la position, rotation et échelle.
Ceci permettra ensuite, du côté GPU, de réutiliser les informations du modèle 3D pour rendre chaque instance à un coût moindre en échange de données.

TODO test performance of gpu instancing

@unity-doc-gpu-instancing

=== SRP Batcher

TODO try SRP batcher

SRP Batcher est une manière de préparer et transmettre les données qui est incompatible avec GPU Instancing.
Cette méthode est uniquement possible avec les Scriptable Render Pipeline de Unity, dont URP et HDRP font partie.
Cela va réduire le nombre de render-state effectué entre deux appels.
Il s'agit de ces opérations qui sont en effet coûteuse puisqu'un nouveau `Material` doit être transmis à chaque fois.
Ici, SRP Batcher va garder un lien persistent vers un buffer `Material` jusqu'à ce qu'une nouvelle variante soit utilisée et provoque un rafraîchissement du buffer.
Cette méthode est donc plus efficace en cas de peu d'uttilisation de variantes de `Material`.

Le SRP Batcher dispose d'un accès permettant une update directe du buffer du GPU.

#figure(
  grid(
    columns: 2,
    image("images/SROShaderPass.png", width: 100%),
    image("images/SRP_Batcher_loop.png", width: 100%),
  ),
  caption: [
    À gauche: Préparation d'un batch pour un draw call vs SPR Batcher
    
    À droite: Boucle du fonctionnement du SRP Batcher.
  ],
)

@unity-doc-srp-batcher

=== DOTS

Data Oriented Technology Stack est l'implémentation dans Unity d'un pattern ECS afin de pouvoir traiter une grande quantité de données.
Cela découple la logique des entités, de celles des composants et des systèmes.
Il est également possible d'utiliser DOTS pour améliorer le rendu graphique en cas de nombreux objets à rendre dans une scène.
Les fonctionnalités attendues des pipelines URP et HDRP ne sont néanmoins pas toutes implémentées dans DOTS.

DOTS est un système complexe permettant de traiter la logique de nombreux éléments.
Malgré la promesse de pouvoir améliorer les performances en cas de nombreux objets, il n'a pas été jugé pertinent de l'utiliser pour ce projet, son utilisation dépassant du cadre de celui-ci.

@unity-entities
@unity-entities-graphics

=== Cas d'étude

Pour le cas d'étude choisi, des brins d'herbe, plusieurs solutions existent pour les représenter, notamment pour les instancer au travers de l'outil des `Terrains`.
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
  Écrire de tels shaders ne peut être fait qu'en HLSL, le langage 

#figure(
  image("images/grass_mesh.jpg", width: 52%),
  caption: [
    Exemple d'un buisson d'herbe et de son maillage, représenté par Mesh.
  ],
)

Un test d'implémentation des deux shaders HDRP ci-dessous a été effectué mais ceux-ci n'ayant pas été mis à jour pour la version 6.0 de Unity, ceux-ci présentent des incompatibilités.
- https://github.com/EmmetOT/HDRPGrass?tab=readme-ov-file
- https://github.com/flamacore/UnityHDRPTerrainDetailGrass

TODO Test d'implémentation

== Tests

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

Créer des test, par contre, requière de créer différentes Assemblies pour les tests.
Les Assemblies en C\# sont des collections de ressources compilées consistant en une unité logique de fonctionnalité.
L'avantage des Assemblies est de diviser un large projet en plusieurs petites unités afin de réduire le temps de compilation à long terme.
Les Assemblies n'ayant pas été modifiées depuis la dernière compilation ne sont en effet pas recompilées.

Afin de pouvoir néanmoins continuer de référencer les méthodes des scripts existants dans le projet, il convient de référencer les Assemblies afin de pouvoir profiter de leur fonctionnalité.
Une seconde Assembly pour les scripts du jeu lui-même a été créée.

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

TODO extrait histogramme test performance

L'implémentation du package Input System pour les test s'est révélé bien plus complexe que prévu.
En effet, les tests de performance de Unity ne s'effectuent pas exactement selon le pattern AAA - Arrange, Act, Assert.
Des états sont permanents entre deux tests, notamment tout ce qui est du chargement de scènes, y compris la manière dont les entrées utilisateurs sont simulées.
Ainsi, pour s'assurer que deux tests possèdent les mêmes conditions il faut passer par deux autres annotations `Setup` et `TearDown` qui indiquent respectivement les actions à effectuer avant et après chaque test.

Quant à la plus-value d'utiliser Input System, elle est moindre dans le cadre des tests de performance, ici le coeur de ce projet.
Aussi, après plusieurs essais infructueux en raison à la complexité de charger des scènes et de les décharger dans le cadre de tests utilisant des enttrées utilisateurs, il a été décidé de ne pas uttiliser Input System.
