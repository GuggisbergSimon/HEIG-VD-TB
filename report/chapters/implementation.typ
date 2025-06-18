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

Unity dispose d'un composant appelé LOD Group qui permet d'automatiser le changement de niveau de détail d'un modèle 3D en fonction de la distance à la caméra.
Ceux-ci prennent plusieurs GameObjects en argument, un par niveau de détail.
De plus, pour chaque niveau de détail une distance maximale doit être définie indiquant quand la caméra devra changer le niveau de détail.
Si plus aucun niveau de détail n'est défini et que la distance maximale n'est pas infinie, alors le modèle 3D sera complètement désactivé via culling.

À noter que les éléments logiques sont totalement indépendants des éléments graphiques puisque le maillage de collision physique est un modèle 3D encore plus simplifié que ceux basses résolutions utilisé pour les LODs.

Finalement, il est possible de disposer d'un Cross Fade entre deux niveaux de détails en spécifiant les distances de transitions.
Ce Cross Fade est implémenté via transparence ou via screen space dithering.

Quant à la génération de LODs, puisque ceux-ci possèdent une topologie différente des modèles 3D originaux, il n'est pas possible de conserver les textures existantes pour ceux-ci, puisque le mappage UV ne correspondra plus.
Pour des modèles non texturés, bien qu'un simple modificateur decimate sous Blender pourrait suffire, une extension tel que `Level Of Detail Generator | Lods Maker` permet de simplifier et automatiser la tâche.
C'est pour cette raison, l'incompatibilité des textures entre les LODs, que des assets existantes contenant environ 3 niveaux de détails ont été utilisées pour ce projet.

@blender-lod-maker

== Imposteurs

TODO

== Shader

TODO

== Tests

L'implémentation de tests à l'aide de Unity Test Framework requière des annotations spécifiques sur les méthodes de test afin de spécifier les conditions dans lesquelles elles seront exécutées.
L'annotation [TestFixture] est utilisée pour une classe de test tandis que celle [Test] pour les fonctions signifie que celle-ci est un test.
On différencie les tests en mode Edit, en mode Play, ou via un Player pour simuler différentes plate-formes.

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

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
