= Architecture <architecture>

== Prototype

Comme cela a été discuté lors de l'état de l'art, l'échelle des mondes virtuels varie grandement.

En raison des contraintes de ce projet, il a été décidé d'adopter une échelle de type véhicule avec un monde de taille réduite, servant de démonstration technique.

Cette échelle laisse la plus grande liberté d'implémentation, tout en facilitant la création de contenu.
En effet, le joueur ne sera représenté que par un véhicule, sans animation, et au vu de la taille des objets les joueurs seront plus à même de tolérer des défauts de comportement physique.

Par souci de simplification, l'idée d'un hovercraft explorant des dunes d'un paysage post-apocalyptique a été retenue.
Cette idée permet l'utilisation d'une grande variété d'assets existantes, sous prétexte que le monde soit désertique et que des ruines de tout genre parsèment le paysage.
Le désert, de plus, simplifiera considérablement le rendu graphique en excluant des arbres. Ceux-ci pourront être ajoutés, dans un second temps, si les imposteurs sont implémentés.
La caméra sera positionnée à distance du véhicule et suivra celui-ci à la troisième personne.

Une inspiration notable est le jeu vidéo Sable, qui, comme son nom l'indique, se déroule dans un monde désert que le joueur parcourt à bord d'un véhicule mais peut à tout moment débarquer à pied et explorer villages, ruines, et autres lieux d'intérêt.

#figure(
  image("images/maquette.jpg", width: 52%),
  caption: [
    Maquette du prototype.
  ],
)

#figure(
  table(
    columns: (auto, auto, auto),
    table.header[Contrôle][Interaction Jeu][Interaction menu],
    [`A`],[Tourner à gauche],[Naviguer vers la gauche],
    [`D`],[Tourner à droite],[Naviguer vers la droite],
    [`W`],[Accélérer],[Naviguer vers le haut],
    [`S`],[Ralentir],[Naviguer vers le bas],
    [`R`],[Reset le vaisseau],[/],
    [`Esc`],[Ouvrir le menu],[Revenir en arrière],
    [`Mouse`],[Contrôle de la caméra],[Navigation libre],
    [`Left Click`],[/],[Sélectionner],
  ),
  caption: "Contrôle du prototype dans différents contextes."
)

== Représentation du monde

Parmi les solutions de représentations possibles, la solution Cesium propose de nombreux outils et fonctionnalités très complets et puissants pour le rendu géospatial de planètes.
Malheureusement elle n'est que rarement adapté dans le développement d'un jeu vidéo, sans compter que la fidélité graphique proposée ne correspond qu'à une faible portion d'expériences de jeu tels que les simulateurs de vol.

La plupart des jeux vidéo préfèrent se tourner vers des solutions plus adaptées à leurs besoins, afin de créer des mondes virtuels, au travers de la génération procédurale.
Ce travail fera de même, d'autant plus que la complexité des outils de Cesium ne permettrait pas d'implémenter les techniques d'optimisation mentionnées dans le cahier des charges.
En effet, Cesium for Unity implémente déjà le streaming de données du terrain et le recentrage du joueur en tout temps au centre du monde.

En raison de ces contraintes d'outils et de la décision de la taille du prototype, il a été décidé de se limiter à un terrain de taille minimal de 64km².
En effet, Unity ne supporte que l'import d'une heightmap de taille maximale de 8192x8192 pixels.
L'élevation pour un mètre est donc donnée par un pixel de la heightmap, ce qui correspond à un compromis acceptable entre taille et précision du terrain.
La résolution de la heightmap est donc environ de 1 pixel par mètre.

La disposition d'éléments dans le monde est réalisé en fonction de l'inclinaison de la pente de ce terrain.
De plus des clusters d'objets seront placés dans certains endroits, afin de simuler des conditions de stress test.
En raison de la complexité de la génération procédurale et des enjeux de ce travail de bachelor, il n'a pas été donné un soin plus particulier à la réflexion de la disposition procédurale des éléments du décor sur le terrain.

@unity-doc-terrain

== Structure

Unity possède de nombreuses structures permettant le développement de jeux vidéo.
Maintenir une bonne structure dès le début est essentiel.

=== Fichiers

Tout fichier de ressource, qu'il s'agisse d'un script C\#, d'un modèle 3D, d'une texture, est appelé une Asset.

Les Assets seront stockées dans le dossier `Assets` et plus spécifiquement dans les sous-dossiers correspondants à leur type.
Ainsi, le dossier `Scripts` contiendra des scripts C\#, dans celui `Prefabs`, des préfabs, etc.

La seule exception à cela concernera les différentes assets provenant du Unity Asset Store ou de Fab, deux grandes ressources d'assets pour Unity.
Leur propre structure sera conservée, afin de faciliter le réimport de celles-ci, au besoin.

=== Scènes

Unity charge différents environnements, appelés `Scenes`.
Cela peut être réalisé de manière additive, ou en remplaçant complètement l'environnement précédent.

Ces scènes contiennent toutes sortes d'instances d'objets, appelés `GameObjects`.
Ces `GameObjects` peuvent représenter des éléments visuels 3D, de la lumière, une caméra, contenir des scripts, etc.
Ceci est déterminé par les composants attachés à chacun de ces `GameObjects`.
Le composant par défaut, pour les objets 3D, est le Transform, qui détermine position, rotation et échelle d'un objet.
Chaque `GameObject` peut posséder plusieurs composants, dont certains qui peuvent être attachés au runtime à un objet.
De plus, chaque `GameObject` peut contenir plusieurs enfants `GameObjects` afin d'aider à structurer une Scène.
Garder une hiérarchie de `Scene` claire et logique est essentiel pour un projet, mais varie de projet en projet.
On dénote néanmoins souvent un `GameObject` racine pour tous les éléments visuels de la `Scene`, appelé "Monde".

Il est possible de sauvegarder un `GameObject` et ses enfants en tant qu'`Asset`, afin de facilement pouvoir le réutiliser dans d'autres scènes et synchroniser certains changements dans l'éditeur Unity.
Ce type d'`Asset` est appelé `Prefab`, la forme raccourcie de préfabriqué.
Les `Prefabs` ont le rôle d'un template puisque deux instances d'un même préfab auront des comportements indépendants.

==== GameManager

Un modèle de programmation typiquement utilisé dans le milieu du jeu vidéo est celui du Singleton, ici sous la forme d'un `GameManager`, qui va pouvoir être accédé par tout objet présent dans la scène.
Ce singleton aura le rôle de chef d'orchestre, s'assurant des bonnes communications entre les différents composants.

Ce `GameManager` possédera différents types de managers, éventuellement accessibles au travers d'une propriété, pour gérer différents aspects du jeu.
Ainsi, un `SceneManager` gérera le chargement et déchargement des scènes, tandis qu'un `SoundManager` gérera les différents effets sonores, etc.

Pour s'assurer qu'un `GameManager` soit présent dans une scène, une structure simple est celle du boot, où tous les éléments initiaux requis sont chargés dans une scène dédiée avant de passer au comportement attendu, qu'il s'agisse d'un menu principal, ou droit au jeu.

Le chargement de scènes plus complexes, telles qu'un menu ou le jeu, peut être fait de manière additive lors d'un écran de chargement, afin d'éviter que l'application soit immobilisée lors du chargement initial.

#figure(
  image("images/boot_loading.png", width: 70%),
  caption: [
    Exemple de structure d'initialisation de scène.
  ],
)

=== Monde

==== Chunks

Une solution très populaire pour charger en mémoire un monde virtuel par élément, plutôt que dans son ensemble, est de le diviser en parties, appelées chunks.

Chaque chunk correspond à un fichier scène séparé de Unity afin de pouvoir être chargé de manière additive et asynchrone.
Ceci permet aux chunks de posséder moults `GameObjects` qui peuvent représenter toutes sortes d'éléments du décor.
Un terrain de 8000x8000 peut être divisé en chunks de 500x500 formant ainsi une sous-grille de 16x16.

Pour enregistrer les coordonnées de chaque chunk et les charger au bon endroit dans l'espace 3D monde, il faut ajouter des méta informations aux chunks.
En raison de limitations de Unity, les scènes, et par extension les chunks, ne peuvent pas offrir ces informations en lecture sans être chargées.
Heureusement, Unity propose la structure de fichier `ScriptableObjects` qui permettent de stocker toutes sortes de données.
Il suffit alors de créer un ScriptableObject pour chaque chunk, contenant toutes les méta informations nécessaires pour ceux-ci.

Les `ScriptableObjects` ont comme avantage principal de pouvoir stocker des larges quantités de données et de les partager entre objets à faible coût.
Leur utilisation, ici, profite du fait que les données modifiées en tant que ScriptableObject dans l'éditeur Unity sont conservées en tant qu'asset.
À noter néanmoins que ces `ScriptableObjects` ne conservent les changements que dans l'éditeur, et non pas lors d'un build.

Maintenir une liste des chunks chargés permet de minimiser le nombre de chunks à charger.
Pour déterminer quel chunk à charger, il est possible de procéder en fonction de la distance au joueur, ou, si l'on simplifie, de la distance à un chunk, celui-ci occupé par le joueur.

Pour simplifier les calculs de distances, il est possible d'enregistrer sous forme de matrice-filtre NxN, où N est impair, les chunks à charger.
Cette matrice contiendra une valeur positive s'il faut charger le chunk.
Les positions dans le monde des chunks seront déterminées en fonction de celle du joueur, qui se trouve au centre de cette matrice-filtre.

#figure(
  grid(
    columns: 2,
    image("images/chunk_shape.png", width: 70%),
    image("images/chunk_loading.png", width: 70%),
  ),

  caption: [
    À gauche, exemple d'un filtre 7x7 de chargement de chunks appliqué sur le monde.
    
    À droite, chargement et déchargement de chunks selone une matrice 3x3, lors d'un changement de chunk par le joueur.
  ],
)

Une autre complication concernant les chunks est l'ajout d'agents en dehors du joueur
Les agents incluent toutes formes d'objets capables de mouvement.
Ceux-ci sont usuellement chargés avec une scène, ici un chunk.
Mais ceci ne peut s'appliquer ici puisque les agents peuvent, au même titre que le joueur, se déplacer d'un chunk à l'autre.

Une manière de résoudre ce problème serait de créer un `AgentManager` qui tiendrait à jour la liste des agents présents dans le monde et les chargerait ou déchargerait en fonction des chunks chargés.
Cette approche permettrait une permanence des agents ainsi qu'une consistence accrue mais ne permettrait pas de simuler des comportements en background, hors de portée du joueur.
Pour arriver à un résultat pareil, il faudrait que l'`AgentManager` mette à jour les agents et le monde non chargés, de manière moins soutenue que ceux visibles.
Ce processus serait similaire aux frames physiques qui ne se produisent qu'à un intervalle donné, indépendant des frames d'affichage.

Malheureusement, la gestion des agents et une implémentation pareille sort du cadre de ce travail de bachelor et ne sera donc pas abordée plus en détail.

@unity-doc-scenemanager
@rain-world-gdc

==== Grandes coordonnées

Lorsque des coordonnées distantes de l'origine du monde sont utilisées, toutes sortes d'aberrations visuelles et logiques peuvent se produire.
Ceci n'est pas le cas pour ce projet borné à un monde de 64km².
Mais, à titre d'exploration de cette technique, cette problématique sera traitée.

Une solution typique pour éviter les valeurs flottantes d'atteindre de trop grandes valeurs est de recentrer le monde autour de l'observateur, ici le joueur.
Ainsi, le joueur et les chunks chargés seront toujours proches de l'origine du monde, bien avant que les effets de perte de précision de float ne se fassent sentir.

Effectuer cette opération, à un intervalle donné, demande de déplacer le monde entier et les acteurs, joueur compris, dans la direction opposée au déplacement du joueur.
Un intervalle approprié, au vu de l'utilisation de chunks pour ce projet, est à chaque passage d'un chunk à un autre.
Ainsi, pour un déplacement du joueur d'un chunk A à B, le déplacement vectoriel de celui-ci sous la forme $delta d = arrow("AB")$.
La modification de position de chaque acteurs et du monde est donc $-delta d = arrow("BA")$.

À noter néanmoins que recentrer le monde n'améliore pas les performances dans le cadre de ce prototype, mais représente une base essentielle pour les vastes mondes virtuels.

== Mesures de performance

Pour s'assurer de la reproductibilité du test de performance, il faudrait privilégier une situation de stress test sans que le joueur n'ait aucun contrôle.
C'est ce qu'un benchmark permet de faire, par exemple sous la forme d'un parcours dirigé de la caméra, avec plusieurs actions se déroulant lors de la durée de celui-ci pour mettre le système à l'épreuve.

Unity propose différents utilitaires de suivis de performances.
Ceux-ci vont du plus simple comme les statistiques visibles dans l'éditeur aux plus complexes comme le Profiler ou le Frame Debugger.

Le Profiler, et en particulier le Deep profiling, a comme désavantage d'ajouter de l'overhead aux mesures de performances.
C'est pour cette raison que le Deep profiling ne sera utilisé que pour investiguer les problèmes de performance.
Si des problèmes plus complexes venaient à survenir, par exemple dans le rendu d'une frame spécifique, alors le Frame Debugger sera utilisé.

Pour un jeu vidéo, la mesure la plus importante n'est pas la moyenne du framerate mais le 95ème, ou 99ème percentile afin de pouvoir isoler les outliers.
Mettre en évidence ceci permet de suivre les chutes de performances.
Une chute brutale du framerate, en dehors des temps de chargement, est particulièrement désagréable comme expérience.

En raison de la nature du projet, il est difficile d'implémenter des outils tels que Cinemachine et Timeline pour tester le chargement des chunks, en particulier à cause du recentrage automatique du joueur, ce qui est contraire à l'idée d'un parcours dirigé.
Mais puisque ce prototype ne contient aucunes fonctionnalités avancées, il est possible de rationaliser les différents types de tests à effectuer.
Ainsi on distingue deux types d'interactions principales, se déplacer et contrôler la caméra.

De plus, plusieurs profils de tests reproductibles seront exécutés :
- un profil sans aucune optimisation, pour servir de référence.
- un profil avec les optimisations considérées essentielles, à savoir : chargement des chunks, recentrage du monde, et LODs.
- un profil avec toutes les optimisations implémentées, à savoir : imposteurs et techniques de batching ou gpu instancing.

Les outils de Unity permettant de réaliser ces tests sont :
- Unity Test Framework pour effectuer des tests unitaires en Edit ou Play Mode.
- Performance Testing Extension, qui, comme son nom l'indique, est une extension de UTF pour ajouter tests de performance au projet sur plusieurs frames.
- Input System met à disposition des manières pour simuler des entrées utilisateur.

#figure(
  table(
    columns: (auto, auto, auto),
    table.header[Type][Situation][Fréquence attendue lors d'une séance habituelle de gameplay],
    "Mouvement", "", "",
    "", "Lent", "fréquent",
    "", "Rapide", "inattendu",
    "", "Téléportation", "ponctuel",
    "", "Aller-retour d'un chunk à un autre", "ponctuel",
    "Caméra", "", "",
    "", "Vue fixe", "fréquent",
    "", "Rotation lente", "fréquent",
    "", "Rotation rapide", "fréquent",
  ),
  caption: "Liste des types d'interactions à tester."
)
