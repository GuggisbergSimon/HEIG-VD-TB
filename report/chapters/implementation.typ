= Implémentation <implementation>

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

== Prototype

Des assets provenant du Unity Asset Store et de Fab ont été utilisées pour le prototype.
Ces assets sont listées et leur license est détaillée dans le fichier `unity/assets/CREDITS.md`

Un premier contrôleur physique pour le joueur, assez sommaire, permet de facilement tester le chargement du monde.
Un second contrôleur, plus abouti, concerne le hovercraft avec une physique plus complexe pour qu'il adhère à la surface du terrain.

Un simple script de génération prend en paramètres plusieurs préfabs et en instancie un certain nombre de manière aléatoire par terrain.
L'angle de ces préfabs sont ensuite ajustés pour correspondre à la pente du terrain.

== Monde

La heightmap est importée dans un Terrain Unity, permettant tout de suite d'avoir une courbure du terrain, pour 8000x8000m.
Les Terrain Tools séparent ensuite cette heightmap en plusieurs morceaux, ici en chunks de 500x500m.

À ce moment là, un script Unity exécutable uniquement dans l'éditeur va copier chaque chunk dans une scène individuelle. 
Ces scènes sont ensuite sauvegardées en tant qu'assets.
Le script créée également des ScriptableObjects correspondant à chaque scène.
Ceux-ci contiennent les coordonnées de chaque chunk, afin de connaître quelle scène correspond à quel chunk.

== Chunk Loading

Charger les chunks est une opération qui s'effectue de manière asynchrone pour éviter de bloquer la thread principale de Unity.
Ceci implique la gestion de la concurrence en cas de modification d'une ressource partagée, ici, la listes des chunks chargés, afin de pouvoir les décharger par la suite.

Une première modification consiste à n'ajouter et à supprimer dans la liste des chunks chargés que lorsque ceux-ci sont effectivement chargés ou déchargés.
Ceci est fait via une écoute de l'événement confirmant la fin de l'opération de chargement ou déchargement du chunk.

```cs
AsyncOperation unloadOperation =
    SceneManager.UnloadSceneAsync(_sortedScenes[coords.x][coords.y]);
if (unloadOperation != null) {
    unloadOperation.completed += _ => { _chunksLoaded.Remove(coords); };
}
```

=== Distance d'affichage

Les terrains dans Unity représentent des plans 3D.
Représenter un vrai monde, sous forme de sphère, est donc impossible.
Cette contrainte implique la nécessité, également, de marquer la coupure entre le monde modélisé et l'espace vide.
Une approche habituelle consiste à ajouter du brouillard distant, qui permet une transition douce entre ces deux.
Unity propose une telle option au travers du framework de Volume, qui offre toutes sortes d'options graphiques HDRP, dont le brouillard.

@unity-doc-hdrp-volume
@unity-doc-hdrp-fog

Quant à la matrice filtre de chunks à charger, elle est représentée par un tableau double dimension de booléens.
Une manière simple de la remplir est de définir une distance de vue qui détermine le rayon du cercle de chunks à charger autour du joueur.

```cs
[SerializeField, Min(1)] private int viewDistance = 3;
private bool[,] _chunksToLoad;
//...
_chunksToLoad = new bool[viewDistance * 2 + 1, viewDistance * 2 + 1];
for (int x = -viewDistance; x <= viewDistance; x++) {
    for (int y = -viewDistance; y <= viewDistance; y++) {
        if (x * x + y * y <= viewDistance * viewDistance) {
            _chunksToLoad[x + viewDistance, y + viewDistance] = true;
        }
    }
}
```

Une autre considération à prendre en compte est la distance d'affichage de la caméra, ou far clipping plane.
Afin de disposer d'une mesure homogène entre la situation de test et celle du prototype, cette distance doit être la même.
Elle est ajustée de concert avec la distance de vue des chunks à charger et la distance du brouillard, pour un rendu cohérent entre les trois paramètres.

== Recentrer le joueur au centre du monde

Garder le joueur au centre du monde, à un intervalle donné, demande de déplacer le monde entier et les acteurs, joueur compris, dans la direction opposée à son déplacement.
Un intervalle approprié, au vu de l'utilisation de chunks pour ce projet, est à chaque passage d'un chunk à un autre.
Ainsi, pour un déplacement du joueur d'un chunk A à B, nous avons un déplacement vectoriel de celui-ci sous la forme $delta d = arrow("AB")$.
Le déplacement de chaque acteurs et du monde est donc $-delta d = arrow("BA")$.

Cette implémentation pose néanmoins problème avec celle du chargement des chunks, qui prend en compte la position du joueur.
En effet, le déplacement du joueur, avec le recentrage du monde sur celui-ci, est de la forme : $(0, 0) arrow arrow("AB") arrow (0, 0)$.
Il faut donc garder en mémoire la position relative du joueur, et la mettre à jour pour charger les chunks correspondants.

```cs
[SerializeField] private Vector2Int gridOffset = Vector2Int.one * 8;
//...
Vector3 playerPos = Player.transform.position;
Vector2Int currentGridPos = GetGridPosition(playerPos);
if (currentGridPos != gridOffset)) {
    Debug.Log($"Player moved from chunk {_playerGridPos} to {currentGridPos}, ");
    Vector2Int diff = currentGridPos - gridOffset;
    Vector3 worldOffset = new Vector3(diff.x * gridSize.x, 0, diff.y * gridSize.y);

    foreach (var coords in _chunksLoaded) {
        Scene loadedScene = SceneManager.GetSceneByName(_sortedScenes[coords.x][coords.y]);
        foreach (GameObject rootObj in loadedScene.GetRootGameObjects()) {
            rootObj.transform.position -= worldOffset;
        }
    }

    playerPos -= worldOffset;
    Player.MoveToPosition(playerPos);
    _playerGridPos += diff;
    UpdateLoadedChunks();
}
```

Quant à la logique de charger et décharger les chunks, 

Un autre problème avec le recentrage du joueur a été le comportement des corps physiques lors de la frame de recentrage.
Les calculs physiques se produisent lors de l'étape FixedUpdate, qui n'est exécutée qu'à des intervalles réguliers, en opposition à l'étape Update, qui est exécutée autant que possible, jusqu'à cappage du framerate.
Pour éviter des comportements physiques aberrants il faut s'assurer de ne modifier les propriété physiques que lors des frames FixedUpdate.

@unity-doc-script-execution-order

== LOD

Unity dispose d'un composant appelé LOD Group qui permet d'automatiser le changement de niveau de détail d'un modèle 3D en fonction de la distance à la caméra.
Ceux-ci prennent plusieurs GameObjects en argument, un par niveau de détail.
De plus, pour chaque niveau de détail une distance maximale doit être définie indiquant quand la caméra devra changer le niveau de détail.
Si plus aucun niveau de détail n'est défini et que la distance maximale n'est pas infinie, alors le modèle 3D sera complètement désactivé via culling.

À noter que les éléments logiques sont totalement indépendants des éléments graphiques puisque le maillage de collision physique est un modèle 3D encore plus simplifié que ceux basses résolutions utilisé pour les LODs.

Finalement, il est possible de disposer d'un Cross Fade entre deux niveaux de détails en spécifiant les distances de transitions.
Ce Cross Fade est implémenté via transparence ou via screen space dithering.

Quant à la génération de LODs, puisque ceux-ci possèdent une topologie différente des modèles 3D originaux, il n'est pas possible de conserver les textures existantes pour ceux-ci, puisque le mappage UV ne correspondra plus.
Pour des modèles non texturés, bien qu'un simple modificateur decimate sous Blender pourrait suffire, une extension tel que `Level Of Detail Generator | Lods Maker` permet de simplifier et automatiser la tâche.
C'est pour cette raison, l'incompatibilité des textures entre les LODs, que des assets existantes ont été utilisées pour ce projet.
Ces assets contiennent 2 ou 3 niveau de détails.

@blender-lod-maker

== Imposteurs

TODO

== Shader

TODO

== Tests

L'implémentation de tests à l'aide de Unity Test Framework requière des annotations spécifiques sur les méthodes de test afin de spécifier les conditions dans lesquelles elles seront exécutées.
L'annotation [TestFixture] est utilisée pour une classe de test tandis que celle [Test] pour les fonctions signifie que celle-ci est un test.
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
En raison de la capture de plusieurs frames, les méthodes de test utilisent l'annotation [UnityTest] et retourne un IEnumerator.

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
Ainsi, pour s'assurer que deux tests possèdent les mêmes conditions il faut passer par deux autres annotations [Setup] et [TearDown] qui indiquent respectivement les actions à effectuer avant et après chaque test.

Quant à la plus-value d'utiliser Input System, elle est moindre dans le cadre des tests de performance, ici le coeur de ce projet.
Aussi, après plusieurs essais infructueux en raison à la complexité de charger des scènes et de les décharger dans le cadre de tests utilisant des enttrées utilisateurs, il a été décidé de ne pas uttiliser Input System.
