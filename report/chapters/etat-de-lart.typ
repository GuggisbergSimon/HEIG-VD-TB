= État de l'art <etatdelart>

== Moteurs de jeux

Le développement de jeux vidéos est complexe car il demande une spécialisation dans de nombreux domaines : programmation en temps réel, rendu graphique, gestion du son, plusieurs types d'inputs utilisateur, simulation d'intelligence artificielle, etc. 

Les moteurs de jeux ont grandement évolué, incorporant de nombreuses fonctionnalités et outils pour faciliter le développement.
L'utilisation de moteurs de jeux établis et populaires, plutôt qu'un moteur de jeu _in-house_ exclusif à une compagnie, permet de disposer d'un large panel de fonctionnalités pour toutes sortes d'échelles et types de projets. L'intégration de nouveaux employés et le partage de connaissances est également simplifié, à la condition qu'ils soient familiers avec le moteur de jeu utilisé, bien entendu.

#figure(
  table(
    columns: (21%, auto, auto, auto, auto, auto, auto),
    table.header[Moteurs de jeu][Début][Rendu][Langage][Open Source][Code Source][Sorties 2024],
    "Unity", "2005", "2D/3D", "C#", "Non", "Partiellement", "12638",
    "Unreal Engine", "1998", "3D", "C++", "Non", "Oui", "4707",
    "Godot", "2014", "2D/3D", "GDScript C#", "Oui", "Oui", "1296",
    "GameMaker", "2007", "2D", "GML", "Non", "Non", "1120",
    "PyGame", "2000", "2D/3D", "Python", "Oui", "Oui", "870",
    "Ren'Py", "2004", "2D", "Python", "Oui", "Oui", "839",
    "RPG Maker", "1992", "  2D", "Ruby Js", "Non", "Non", "704",
    "Löve", "2008", "2D", "Lua", "Oui", "Oui", "41",
    "idTech", "1993", "3D", "C++", "Partiellement", "Partiellement", "14",
    "CryEngine", "2002", "3D", "C++ C#", "Non", "Oui", "1",
  ),
  caption: [Liste non exhaustive de moteurs de jeux, par nombre de sorties steam 2024, estimées selon steamDB @steamdb.]
)

À noter que, pour le cas de Godot, le nombre de sorties a doublé depuis 2023.
C'est pour cette raison et de sa caractéristique d'un moteur de jeu _open source_ 3D qu'il a été étudié ci-dessous, avec _Unity_ et _Unreal Engine_.

=== Godot

_Godot_ est un moteur de jeu _open source_, principalement axé 2D, mais dont la partie 3D a connu une amélioration significative ces dernières années.

Très léger et bien plus compact que les deux autres moteurs, il manque néanmoins de certaines fonctionnalités.
_Godot_ ne dispose pas de _Raytracing_, pas de _Mesh Shader_, pas d'_Impostors_, pas de _Terrains_, pas de _build_ consoles, pas de système de _package_, etc. 
Il est alors souvent nécessaire de passer par des _workarounds_ ou de développer soi-même les fonctionnalités manquantes afin d'éventuellement rendre public un répertoire contenant les outils développés, ce qui s'inscrit dans la philosophie _FOSS_ du projet.

Les contributions par _pull request_ sont possibles, mais ne sont pas toujours acceptées si celles-ci sortent du cadre des corrections de _bugs_, certaines ignorées jusqu'à une année.
Le moteur présente néanmoins un certain manque de maturité et les rares projets commerciaux ayant rencontré le succès sont des projets indépendants de petite envergure, pour le moment.
La grande majorité des projets commerciaux réalisés avec ce moteur sont des jeux 2D @steamdb.
Parmi les nombreux jeux _Godot_ 3D modernes mis en avant dans le _reel_ 2024 du moteur, seuls des récents projets, encore en développement, tendent vers l'_open world_, à savoir _Zitifono_, _No Gasoline_, _Paw Rescuers_ et _Road to Vostok_ @godot-showcase.
Seul ce dernier possède un rendu proche du photoréalisme, tandis que les autres ont un rendu stylisé.

=== Unity

_Unity_ représente \~50% des jeux sortis en 2024 sur la plateforme de vente _Steam_.
C'est un moteur polyvalent capable de faire autant 2D que 3D, populaire parmis les amateurs et les professionnels.

Des projets complexes _open world live service_ tels que _Genshin Impact_ ont été réalisés avec ce moteur et chaque année de nombreux projets commerciaux de moindre envergure connaissent le succès.
Facile à prendre en main, le moteur dispose d'une large documentation malgré un code source partiellement indisponible.
Celui-ci peut être acheté par une entreprise, au besoin.

Malheureusement, _Unity_ a de la difficulté à s'adapter à une grande quantité d'assets ainsi qu'une large équipe.
De plus, un grand nombre de fonctionnalités importantes, disponibles via des _packages_ officiels externes, ne sont pas toujours bien intégrés, restant souvent sans mises à jour ou en _preview_ pendant de longues années.
Pour ne rien arranger, la communication de _Unity_ en 2024 concernant des changements majeurs de prix a laissé à désirer, entraînant perte de confiance et l'exode vers d'autres moteurs de jeux, tel que _Godot_.

=== Unreal Engine

_Unreal Engine_ représente \~30% des jeux sortis en 2024 sur la plateforme de vente _Steam_.
C'est un moteur axé 3D dont le rendu se veut principalement photoréaliste, et ce au travers de nombreuses techniques de rendu et d'optimisation.

Au contraire de _Unity_, il dispose de nombreux outils et d'une bien meilleure gestion des assets et des équipes, ce qui rend son utilisation plus aisée pour des projets à grande échelle.
_Epic Games_, la société derrière _Unreal Engine_, travaille également sur des jeux vidéo, tels que _Fortnite_, et ajoute au moteur les nombreuses fonctionnalités développées pour ces projets.

Malheureusement, _Unreal Engine_ est plus difficile d'accès et demande souvent de modifier le code source quand les rares fonctionnalités prévues ne suffisent pas.
Réaliser une _pull request_ pour ajouter sa contribution au moteur est possible mais est bien souvent ignoré.
De plus, en raison de la large complexité du moteur, la _codebase_ est vaste et difficile à appréhender pour un nouveau venu.

=== Conclusion

Chaque moteur dispose de forces et de faiblesses.
Certains sont plus adaptés pour des projets très spécifiques, tel que _Ren'Py_ pour les _visual novels_, tandis que d'autres permettent une plus grande flexibilité ou proposent des outils uniques, au prix d'une courbe d'aprentissage plus élevée.

Pour un projet tel que ce travail de Bachelor, _Godot_ ou _Unity_ seraient appropriés en terme d'échelle et de facilité de prise en main.
Le premier manque malheureusement encore de fonctionnalités 3D et représente une prise de risque quant à la réussite de ce projet, là où _Unity_ est déjà bien établi.
De plus, _Godot_ ne dispose pas, pour le moment, d'outils permettant un rendu haute fidélité qui permettrait de pousser les limites du prototype et de tester réellement les techniques d'optimisation, selon l'état de l'art.

Pour ces raisons, il a été décidé d'utiliser _*Unity*_ pour le développement de ce projet.

== Contexte et Concepts

Cette section liste de manière succinte plusieurs concepts importants dans le rendu 3d.

=== glTF

glTF, _Graphics Library Transmission Format_, est un standard développé par _Khronos Group_, aussi connu pour _OpenXR_, _OpenGL_, _Vulkan_ et _WebGL_ @gltf-khronos. 
Il s'agit d'un standard de format de fichier 3D qui permet de transmettre de manière efficiente des modèles, scènes 3D, et animations.
Le format est entre autres connu pour son standard de matériaux _PBR_, _Physically Based Rendering_ @pbr-khronos.
Ce standard a pour but d'homogénéiser les valeurs et de le rapprocher d'un rendu réaliste en implémentant différentes fonctionnalités telles que :
- _Emissive_
- _Metallic_
- _Normal_
- _Roughness_
- _Specular_
Ces propriétés sont présentes dans la plupart des moteurs de jeu et de logiciels de modélisation 3D mais ne suivent pas forcément les mêmes standards de nom ou de valeurs.
Ce standard, en particulier le _subset PBR_, a été largement adopté par l'industrie du jeu vidéo.

=== Overdraw

_Overdraw_ est le terme désignant le fait de rendre à l'écran un pixel plusieurs fois.
À grande échelle, c'est une perte de performance massive car le GPU doit traiter plusieurs fois chaque pixel de l'écran.
Ce problème explose de manière quadratique en cas de résolution plus élevée.

Cela peut être dû à des objets transparents, superposés, ou à un maillage trop complexe.
En effet, chaque triangle visible d'un maillage va produire un appel au GPU pour calculer les pixels qu'il occupe à l'écran.

=== Lumières

Les lumières, et particulièrement les ombres, ont toujours été un problème dans la course au rendu réaliste 3D.
Traditionellement, chaque lumière produisant une ombre doit effectuer un _pass_ de rendu selon la résolution de ces ombres afin d'établir un _Z-buffer_ qui va pouvoir déterminer si des objets sont dans l'ombre, ou non.
En cas d'ombres douces, cela est différent, mais la complexité du rendu ne fait que monter, et ce, pour chaque source de lumière.

Il existe également des méthodes plus modernes pour aboutir à une fidélité graphique plus élevée, telles que le _Raytracing_ ou le _Pathtracing_, ces méthodes sont très coûteuses en termes de performances et ne sont pas supportées par tout type de matériel.

=== Stockage

On distingue plusieurs catégories de stockage.
- Mémoire vive - RAM
- Mémoire vidéo - VRAM
- Mémoire de stockage - SSD, HDD

Les deux premiers types de mémoire sont ceux impactant principalement le rendu graphique.
Les textures, modèles, et autres ressources graphiques nécessaires pour le rendu sont stockées dans la mémoire vidéo du GPU.
Bien que le GPU soit très rapide pour traiter de larges quantités de données, il est limité par la vitesse de transfert entre mémoire vive et lui-même.
Il n'est pas non plus possible de tout stocker sur le GPU en raison de la taille de mémoire vidéo limitée, bien plus que la RAM.

Il convient alors de faire un compromis entre fidélité graphique, temps de chargement et performances.

=== Shaders

Un shader est un programme, souvent exécuté sur le GPU, pour effectuer le rendu d'un objet 3D.
Ils permettent de déplacer une charge de travail répétitive depuis le CPU jusqu'au GPU, plus performant pour des calculs nombreux et répétés.

On distingue plusieurs catégories de shaders :
- Vertex shader : 
  Ce shader s'applique aux sommets d'un modèle 3D.
  C'est aussi dans ces points que les valeurs importantes sont sauvegardées, telles que les coordonnées UV.
- Fragment shader :
  Ce shader s'applique à chaque pixel d'une face d'un modèle 3D.
  Comme cette quantité de points est dépendante du placement de la caméra par rapport au modèle, il est impossible d'enregistrer des informations pour chacun de celles-ci.
  Une caméra proche affichera bien plus de pixels pour une face qu'une caméra éloignée.
  Un fragment shader procède par interpolation entre les sommets d'une face pour déterminer les informations à afficher.
  De cette manière, la coordonnée précise d'une texture peut être déterminée, par exempl, par interpolation entre trois autres connues.
- Tessellation shader :
  Ce shader permet de subdiviser de manière uniforme un maillage.
  Cela permet d'ajouter des détails de manière dynamique à un modèle, par exemple lorsque la caméra s'en approche.
- Geometry shader :
  Ce shader prend une primitive en paramètre et produit plusieurs primitives.
  Il peut générer des triangles pour représenter des simples éléments 3D, tel qu'un brin d'herbe.

De plus, il est possible d'utiliser la base d'un shader complexe mais de l'altérer pour arriver à des résultats stylistiques différents, que ce soit un rendu stylisé tel celui d'un cartoon, ou via cel shading, ou ombrage de celluloïd.

La limite des shaders consiste en leurs entrées et sorties.
Ceux-ci ne connaissent que ce qu'ils reçoivent en entrée pour procéder au rendu graphique, et la sortie habituelle d'un shader est la production d'un visuel.
Les sorties peuvent être détournées de différente manière, par exemple en écrivant en sortie une texture en mémoire, mais cela reste limité.
Les shaders ne peuvent pas être utilisés pour affecter le comportement d'autres systèmes indépendants, tel qu'un moteur physique.
Mais ils peuvent, par exemple, prendre un vecteur en entrée pour représenter le vent et simuler l'impact de celui-ci sur des brins d'herbe.

#figure(
  image("images/shader_pipeline.png", width: 20%),
  caption: [
    Pipeline de rendu d'un shader OpenGL, en bleu les étapes programmables @opengl-khronos.
  ],
)

==== GPU Instancing

Un problème fréquemment rencontré dans les jeux vidéo est l'affichage d'une large quantité d'objets 3D identiques, tels que des brins d'herbe ou des arbres.

Pour chaque objet à représenter le CPU communique avec le GPU, et ceci représente un goulot d'étranglement pour les performances.
En effet, bien que le GPU soit très puissant pour de nombreux calculs répétitifs, transmettre de nombreuses informations de CPU à GPU est une opération coûteuse.

Une solution habituellement utilisée est de diminuer les appels de rendu, appelés _draw call_, via une instantiation de données sur le GPU.
Ceci est d'avantage connu sous le nom de _GPU Instancing_ @unity-doc-gpu-instancing.
Au lieu de transmettre les informations de maillage et de matériaux à chaque fois, il est possible, pour un même modèle 3D, de transmettre uniquement les informations spécifiques à chaque instance de celui-ci, telles que la position, rotation et échelle.
Ceci permettra ensuite, du côté GPU, de réutiliser les informations du modèle 3D pour rendre chaque instance à un coût moindre en échange de données.

=== Textures

Lorsqu'un pixel de l'écran couvre de nombreux pixels de texture, appelé texels, il est difficile de déterminer rapidement la couleur du pixel à afficher.
La manière correcte revient à établir la moyenne de chaque texel présent dans le pixel, mais c'est une opération coûteuse pour n'afficher, au final, qu'un pixel pour un modèle distant.

La technique des _mipmaps_ consiste à pré-calculer un set de textures de résolutions plus petites que celle originale à afficher @unity-doc-mipmap.
La texture correspondant à la distance de la caméra est ensuite chargée, pour éviter ces problèmes de rendu visuel, tout en garantissant une bonne performance.
Pour une texture originale de 64x64, la _mipmap_ 0, alors les niveaux suivants seraient une _mipmap_ 1 de 32x32, 2 de 16x16, 3 de 8x8, etc.

Cette technique n'a pour défaut que l'augmentation de l'espace disque et vidéo utilisé par l'application.
Ceci se fait au prix d'un facteur 4/3, soit 33% espace mémoire supplémentaire, ce qui reste minime pour une amélioration visuelle significative comme celle-ci.

Une alternative aux _mipmaps_ est un filtre anisotrope. 
Celui-ci permet d'améliorer le rendu visuel dans les cas où la face d'un modèle est orientée de manière oblique à la caméra.
Le prix pour cette technique est un facteur 4, soit 300% d'espace mémoire supplémentaire.

Une contrainte pour ces deux techniques est de disposer de textures dont la taille sont des puissances de 2.
Cette particularité est entre autres utilisée par la technique d'optimisation d'assets appelée _Crunch Compression_.
Celle-ci permet une compression des assets très agressive pour l'espace disque du _build_ tout en ayant de très bonnes performances en runtime.

#figure(
  image("images/mipmaps.png", width: 60%),
  caption: [
    Exemples de différentes mipmaps par taille décroissante @unity-doc-mipmap.
  ],
)

=== Précision floating point

Les _floats_ sont préférés par rapport aux _doubles_ pour le développement de jeux vidéo en raison de leur taille moindre en mémoire au coût d'une précision moindre.
Cette précision n'est pas requise pour la plupart des calculs.
Néanmoins, lorsque l'échelle des mondes virtuels atteint une taille immense, ou minuscule, la précision des _floats_ peut poser problème.
Une manière commune de contourner ces problèmes est de changer la taille initiale du monde virtuel, par exemple, en le réduisant de 1000x, mais pour un monde virtuel possédant plusieurs échelles de grandeur à respecter, ceci n'est pas une solution viable.

La manière dont un _float_ 32 est encodé en mémoire est la suivante @oracle-float.
- 1 _bit_ pour le signe
- 8 _bits_ pour l'exponent
- 23 _bits_ pour la fraction

Un nombre _float_ 32 est donné sous la forme :
$(-1)^{"signe"} dot 2^{"exponent"-127} dot (1 + "fraction")$

La formule pour l'erreur est donnée sous la forme :
$~2^(floor(log_2("distance"))-"fraction")$

Ainsi, pour une valeur telle que le rayon de la terre, ~6378 km, la précision d'un _float_ 32 est de \~0.5m.
Pour une échelle humaine cela n'est plus tolérable et pourrait même être directement observable.

== Techniques

Un grand nombre de techniques visant à améliorer les performances ont vu le jour au fil des années.
Certaines sont devenues de facto standardes tandis que d'autres tardent encore à être implémentées par les moteurs de jeux.
Parfois des techniques disparaissent de l'horizon pour revenir sous un autre nom, tel que les _megatexture_, maintenant plus connues sous le nom de _Streaming Virtual Texturing_.

Certaines de ces techniques devront être implémentées dans le prototype afin de satisfaire le cahier des charges.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    table.header[Techniques][Godot][Unity][Unreal Engine],
    "Frustum Culling", "Oui", "Oui", "Opt out",
    "Occlusion Culling", "Opt in", "Opt in", "Opt in",
    "Lightmap", "Opt in", "Opt in", "Opt in",
    "Streaming Virtual Texturing", "Non", "Experimental", "Opt in",
    "Mesh Shader", "Non", "Non", "Opt in",
    "LOD", "Opt in", "Opt in", "Opt in",
    "Impostor", "Plugins", "Plugins", "Opt in",
    "Terrain et Landscape", "Plugins", "Opt in", "Opt in",
  ),
  caption: "Techniques couvertes par les trois moteurs de jeux plus populaires"
)

=== Viewing-Frustum Culling

_Viewing-Frustum Culling_ est une technique qui consiste à limiter l'affichage à ce qui est visible par la caméra dans un hexaèdre @unity-doc-occlusion-culling @godot-doc-occlusion-culling @unreal-doc-visibility-culling.
Cet hexaèdre est plus communément connu sous le nom de _bounding box_.
Cette _box_ contient un _near clipping plane_, un _far clipping plane_, et les bords de la caméra, consistant, ainsi, une boîte à 6 faces.
Seuls les éléments présents dans celle-ci vont être affichés.
Cela représente une amélioration simple et efficace implémentée par défaut dans les trois moteurs de jeux analysés.

Les valeurs telles que les bords de la caméra sont directement dépendantes de la caméra et du champ de vision, _FOV_, utilisé.
Le _near_ et _far clipping plane_ sont des valeurs définies par l'utilisateur. 
Des valeurs trop petites pour le _near clipping plane_ créeraient des artefacts graphiques proches d'un modèle tandis que des valeurs trop grandes pour le _far clipping plane_ nécessiterait de rendre à l'écran des objets distants à peine visible.

#figure(
  image("images/frustum_culling.png", width: 60%),
  caption: [
    _Frustum culling_ en action, en rouge les objets ayant été retirés @unreal-doc-visibility-culling.
  ],
)

=== Hidden-surface determination (Occlusion culling)

_ Occlusion culling_ est une technique qui consiste à ne pas afficher un élément étant caché par un autre afin d'éviter les problèmes d'_overdraw_ @unity-doc-occlusion-culling @godot-doc-occlusion-culling @unreal-doc-visibility-culling.
Cela est très efficace dans les espaces intérieurs mais nécessite une mise en place particulière dans la plupart des moteurs de jeux.
En effet, pour pouvoir indiquer au moteur de jeu quelles parties omettre, ou non, il faut que la scène soit constituée de plusieurs éléments, plutôt que d'un seul modèle 3D.
De plus, il faudra ensuite indiquer quels éléments peuvent déclencher une occlusion, un mur typiquement, et quels éléments seraient sujets à cela, des objets cachés derrière un mur, par exemple. 

#figure(
  image("images/occlusion_culling.png", width: 59%),
  caption: [
    _Occlusion culling_ en action, en bleu les objets ayant été retirés @unreal-doc-visibility-culling.
  ],
)

_Unreal Engine_ permet une utilisation dynamique de cette technique, qui peut néanmoins être désactivée.

=== Lightmap

Une _Lightmap_ est une texture contenant les informations précalculées de l'éclairage et des ombres @unity-doc-lightmap @godot-doc-lightmap @unreal-doc-lightmap.
Cette technique permet une excellente combinaison entre fidélité de rendu graphique et performance.
Cela s'effectue au prix de :
- En amont :
  - Mise en place de différents composants.
  - Temps de calcul requis, appelé _baking_.
- En _runtime_ :
  - Espace mémoire utilisé pour stocker la texture.
  - Impossibilité de changer la lumière dynamiquement.

Certains moteurs de jeux, tels que _Unity_, permettent de mélanger différents modes de rendu de lumière.
Ainsi, un objet serait sensible à la lumière d'une _lightmap_, mais également à une lumière dynamique, afin d'ajouter, par exemple, un éclairage dramatique dans un endroit précis.

La contrainte la plus importante des _lightmaps_ reste la rigidité face aux lumières dynamiques.
Simuler un cycle jour-nuit est incompatible avec cette technique, en raison de la lumière dynamique globale du soleil.
Cette technique reste néanmoins utile pour tous les milieux dépourvus de lumière dynamique, tels que des intérieurs.

=== Streaming Virtual Textures

_Streaming Virtual Textures_ est une technique aussi connue sous le nom de _Megatexture_ dans le moteur _idTech_, pré-datant leurs implémentations modernes dans _Unity_ et _Unreal Engine_ @unity-doc-svt @unreal-doc-svt.
Elle consiste à disposer d'une seule grande texture avec des coordonnées UV pour l'indexer.
En runtime, cette texture est ensuite streamée et mise en mémoire selon les besoins.
Cela a comme avantage visuel de bénéficier de textures uniques pour chaque surface ainsi que de limiter le chargement et déchargement de textures en mémoire, puisqu'une seule est chargée en tout temps.

=== Mesh Shader

_Mesh Shader_ est une technologie qui n'a pour le moment qu'une implémentation dans le moteur _Unreal Engine_ sous le nom de _Nanite_ @nvidia-mesh-shader @unreal-doc-nanite.
Elle ne s'applique que pour les objets statiques, ceux qui ne bougent pas, typiquement un environnement fixe.
Les modèles sont analysés lors de l'import afin d'être streamé de manière efficace lors du runtime et de n'afficher que les triangles visibles au niveau de détail requis.
Cela permet l'affichage de modèles 3D très complexes, en s'affranchissant du nombre de polygones comme métrique de ralentissement, et donc d'améliorer grandement la fidélité visuelle.

Une implémentation future de cette technique est en considération par _Unity_ pour le moment @unity-roadmap.

=== Level of detail (LOD)

Lorsque des modèles au maillage complexe sont affichés à l'écran de manière distante, le GPU va devoir traiter pour chaque pixel tous les triangles à sa position.
Afficher des modèles complexes distants est donc très coûteux en terme de performances et n'apporte pas une grande valeur au rendu graphique.
Il s'agit d'un problème typique d'_overdraw_.

Les LODs ou _Level of Detail_ sont des modèles 3D basse résolution, qui, comme leur nom l'indique, possèdent plusieurs niveaux de détails @lod-3d-graphics.
La technique est similaire aux _mipmaps_, mais pour les modèles.
Ainsi, un modèle faible résolution est chargé lorsque la caméra est éloignée, et inversement.
Le niveau de détail original est LOD 0 tandis qu'un moins détaillé serait LOD 1 puis LOD 2, etc.
Une autre amélioration est de ne plus afficher totalement les objets entièrement passés une certaine distance.
Ceci est particulièrement utile pour des objets de petites tailles, dont leur absence à une distance éloignée ne sera pas remarquée par l'utilisateur.

Cette technique a néanmoins plusieurs coûts :
- Espace disque. 
  Plusieurs modèles pour un seul modèle 3D va accroître l'espace disque utilisé par l'application. 
  Bien que ceci soit négligeable puisque les modèles LODs seront strictement plus légers que celui original, cela reste un coût à prendre en compte.
- Travail de modélisation.
  Modéliser ces LODs peut être réalisé de manière automatique, mais pour une meilleure fidélité, il est préférable d'allouer plus de temps pour une modélisation manuelle de ces LODs.
- Chargement additionel.
  - Espace mémoire limité.
    Il serait possible de charger l'entièreté des LODs en mémoire, tel un atlas de modèles, mais ce coût est autrement plus conséquent que pour les _mipmaps_.
  - Charger les modèles n'est pas instantané.
    Il est possible, pour des modèles particulièrement lourds, que la transition entre les différents LODs soit trop soudaine ou que le chargement du modèle LOD requis soit trop longue.
    Cela peut créer un effet de _popping_ et peut nuire à l'expérience utilisateur.

Pour pallier à ce dernier problème, il est possible d'effectuer une transition entre deux LODs via un effet de _dithering_.
Le _dithering_, ou diffusion d'erreur, est une technique de rendu graphique qui consiste à ajouter du bruit à une texture pour simuler un effet de transparence.
Ici, le LOD disparaissant verra sa transparence progressivement augmenter via le _dithering_.
Cette technique a néanmoins un coût puisque cela ajoute de l'_overdraw_ entre les deux LODs, l'un deux semi-transparent.

#figure(
  image("images/LOD0Image.png", width: 60%),
  caption: [
    Exemple de deux LODs d'un même modèle 3D @unity-doc-lod.
  ],
)

=== Impostor

Les _Impostors_ sont une forme avancée de _Billboards_ qui tentent de résoudre le problème de l'_overdraw_ @nvidia-true-impostors.
Les _Billboards_ consistent en un _quad_ où une texture représentant un modèle distant est affiché.
La rotation d'un _Billboard_ peut être ajustée pour toujours faire face à la caméra.
Différentes variantes existent, certaines permettant aux _Billboards_ de figer la rotation d'un ou plusieurs axes.
Une utilisation commune de cette technique est pour représenter la végétation, que ce soit herbe ou arbres.
Les _Billboards_ ont comme particularité de représenter une image 2D dans un environnement 3D, ce qui est parfait pour des objets distants, mais cette solution comporte des limitations.

Afin de rendre l'image d'un modèle 3D dans un environnement 3D, il faut dessiner le modèle, selon l'angle requis et les conditions de lumière.
Lorsque l'angle entre la caméra et l'objet est trop grand par rapport à celui-ci initial pour l'imposteur actuel, alors un second imposteur est dessiné.
Les GPUs modernes disposent d'API facilitant la génération d'imposteurs, en raison de la popularité de la technique.

_Unity_, au contraire de _Unreal Engine_, ne propose pas de solution facile d'accès pour les imposteurs @unreal-doc-impostor.
Une solution existe pour les utilisateurs souscrivant à _Unity Industry_ seulement.
Le _package_ offrant cette option est _Pixyz_, un outil permettant l'import de modèles CAD sous plusieurs formes, telles qu'un nuage de points @unity-pixyz-impostor.

Une autre solution notable pour _Unity_ est l'utilisation d'un _plugin_ inofficiel, tel que _Amplify Impostors_, disponible sur _Unity Asset Store_ @amplify-impostors.

==== Types d'imposteurs

Une première solution est de rendre les imposteurs en _runtime_ via une caméra virtuelle capturant ceux-ci.
Cela a comme avantage d'être plus simple à implémenter et de rendre correctement les conditions de lumières, d'éventuelles animations procédurales, textures animées, etc.

Une seconde solution possible est celle précalculée, _Baked_ @medium-octahedral-impostors.
Ce type d'imposteurs est bien moins coûteux en performance, mais est plus complexe à mettre en place.

Cela consiste à générer des atlas de textures représentant le modèle 3D d'un imposteur selon différents angles de vue.
L'imposteur consistera ensuite à afficher la texture correspondant à l'angle de vue actuel de la caméra.
Cette technique demande un plus grand espace mémoire vidéo pour stocker l'atlas de textures générées.
Chaque texture générée aura une taille habituellement de 2048x2048 pixels, ce qui résultera, dans le cas d'un atlas 16x16, de 128x128 pixels attribués à chaque image servant d'imposteur.
Le nombre de ces textures peut varier selon la qualité du shader utilisé pour représenter les imposteurs.
Un bon shader peut également ajouter des conditions de lumières, des ombres, interpolation entre deux points de vue, etc.

Il existe plusieurs types d'imposteurs _Baked_ : sphérique, octahèdre et semi-octahèdre.
Cette spécification détermine la manière dont les captures de perspective sont effectuées.
Chaque capture de perspective est effectuée à un angle défini par un sommet.

Pour une meilleure qualité d'image l'octahèdre est recommandé, ou semi-octahèdre si les imposteurs ne seront pas vus depuis le bas.
La répartition sphérique est souvent plus rapide mais présente des défauts visuels lors du changement d'un imposteur à un autre.

#figure(
  grid(
    columns: 3,
    image("images/Spherical.png", width: 50%),
    image("images/Octahedron.png", width: 50%),
    image("images/HemiOctahedron.png", width: 50%),
  ),
  caption: [
    Les différents types d'imposteurs _Baked_, de gauche à droite : sphérique, octahèdre et semi-octahèdre @amplify-impostors.
  ],
)

#figure(
  grid(
    columns: 2,
    image("images/impostors_camera.jpg", width: 70%),
    image("images/impostors_atlas.jpg", width: 70%)
  ),
  caption: [
    À gauche: Placement de caméras pour le rendu _Baked_ d'un imposteur semi-octahèdre.
    
    À droite: Atlas de textures pour un imposteur _Baked_ semi-octahèdre @medium-octahedral-impostors.
  ],
)

=== Terrain et Landscape

Il s'agit de la manière de représenter la surface d'un environnement 3D, partitionné via une grille.
Chaque case de cette grille représente un morceau de terrain.
Ces cases, souvent appelées tiles, peuvent être mis bout à bout lorsque chargés consécutivement.
Leurs dimensions peuvent grandement varier, tout comme leurs fonctionnalités.
Parmi lesquelles :
- Une _heightmap_ qui sert à dénoter l'élevation du terrain depuis un fichier de texture noir et blanc où les valeurs [0, 1] représentent les valeurs minimales et maximales du modèle.
- Des textures qui sont appliquées sur le terrain, souvent en fonction de la hauteur, de la pente, ou d'autres critères.
- Des détails qui sont des objets 3D placés sur le terrain, tels que de la végétation, rochers, etc.

Chacun des trois moteurs de jeu dispose de sa propre solution pour afficher un environnement 3D.
Que ce soient les _Landscapes_ dans _Unreal Engine_ ou les _Terrains_ dans _Unity_, ceux-ci remplissent la même fonction @unreal-doc-landscape @unity-doc-terrain.
À noter que _Godot_ ne dispose pas de solution intégrée directement, mais plusieurs _plugins_ permettent de pallier à ce manque @godot-terrain3D.

==== Catégories d'échelles de grandeur

Bien que l'échelle des mondes virtuels varie grandement, il est possible de distinguer trois grandes catégories, ce qui n'empêche pas des titres ambitieux de vouloir couvrir plusieurs de ces échelles. :
- Une échelle à taille humaine est la plus courante dans les jeux vidéo car elle est celle qui permet de faciliter l'immersion du joueur en incarnant directement un personnage.
  Le personnage sera souvent contraint à des tailles, vitesses, habituels pour un humain.
  Outre les mondes générés procéduralement, il est rare que des mondes pour cette échelle dépassent les 150km².
  Malgré la popularité de cette échelle, elle comporte une charge de travail accru au niveau animation/modélisation de l'avatar, si celui-ci est visible.
  
  Jeux notables : 
    - _The Elder Scrolls V : Skyrim_ - 40km²
    - _The Legend of Zelda : Breath of the Wild_ - 80km²
    - _The Witcher 3_ - 125 km²

- Une échelle à taille véhicule est moins habituelle et dispose d'une grande variation.
  En effet, cela peut autant couvrir la zone d'une ville, la surface d'un continent, voire même de la planète Terre entière.
  Que ce soit voiture, hélicoptère, avion, le mode de transport choisi va grandement influencer la taille du monde virtuel.
  Les assets pour cette échelle seront souvent moins détaillés puisque ceux-ci seront ou trop éloignés de la caméra, ou le joueur ne pourra pas les examiner attentivement en raison de la vitesse du véhicule.

  Jeux notables : 
    - _The Crew_ - 5 200 km²
    - _Fuel_ - 15 000 km²
    - _Microsoft Flight Simulator_ - 510 000 000 km² - Carte aux dimensions 1:1 de la Terre.

- Une échelle à taille spatiale est tout ce qui se trouve au-delà, couvrant tant un système solaire que celui d'une galaxie entière.
  Les unités pour ces mondes sont souvent quantifiées en unités astronomiques.
  En raison de ces tailles colossales, ces mondes sont souvent représentés via de la génération procédurale, plutôt que d'avoir été méticuleusement designés par des artistes. À titre d'exemple, _No Man's Sky_ dispose de 18 quintillions de planètes que les joueurs peuvent explorer à échelle humaine.

D'autres mondes virtuels sont eux générés intégralement de manière procédurale lors du lancement d'une partie.
Ceci garantit un monde unique pour chaque utilisateur, variant à chaque génération.
Leur taille, quant à elle, explose et est difficilement quantifiable, allant du milliard de km² jusqu'à des unités spatiales permettant de représenter notre galaxie.

==== Cesium

_Cesium_ est une plate-forme mettant différentes ressources à disposition pour le rendu géospatial @cesium.
Cela inclue une large base de données de _3DTiles_ ou d'imageries satellites @3D-tiles.
Plusieurs implémentations existent, que ce soit pour le web avec _CesiumJS_, ou pour les moteurs de jeux avec _Unreal_ et _Unity_.
Cet outil requière néanmoins une connexion internet pour streamer les données, et est donc dépendant d'un service tiers, ce qui n'est pas forcément souhaitable pour un jeu vidéo.

_3DTiles_ est un format de données 3D géospatial permettant l'affichage, streaming et partage de celles-ci.
Le format est maintenu par _Cesium_ et est particulièrement adapté pour le streaming de données massives en runtime.
_3DTiles_ utilise le format glTF pour les tiles.
Un _tileset_ est un ensemble de tiles, et chaque tile peut contenir des tiles enfants.
L'affichage se fait via _Frustum culling_, et affiche l'entiéreté d'une tile enfant.

Plusieurs types de tiles existent :
- Modèles 3D : Dans le cas de modèles répétés de nombreuses fois avec de faibles variations il est possible de procéder par instanciation en faisant varier les propriétés de chaque instance.
- Nuages de points : Ce type de données est obtenu via photogrammétrie ou par un scan LIDAR. 
  Ce format permet d'approximer la surface d'un objet 3D en représentant, dans l'espace, l'ensemble du nuage de points.
- Tiles composites : Il est également possible de mélanger les différents types de tiles ensemble.

==== Génération procédurale de terrain

Il existe de nombreux outils de générations procédurale de terrains.
Ceux-ci se présentent sous la forme de _plugins_ dans un moteur de jeu ou en tant qu'outils externes.
Parmi les outils externes, _Gaea_, _Houdini_ et _World Creator_ sont les plus importants dans l'état de l'art @world-machine @world-creator @houdini.
Ces outils permettent, entre autres, de simuler des effets de météo tel que l'érosion, de générer un terrain de manière infinie, et d'exporter les ressources nécessaires dans différents formats qui seront exploitables par les moteurs de jeux.
Ces outils utilisent l'édition via noeuds pour pouvoir et représenter chaque étape intermédiaire de manière intuitive pour les artistes, et permettre aux opérations de ne pas être destructives.

#figure(
  image("images/gaea_example.jpg", width: 100%),
  caption: [
    Interface de Gaea, avec un terrain généré en exemple @gaea.
  ],
)

En raison de l'utilisation industrielle de ces outils, ils ne sont néanmoins pas tous mis à disposition à des fins d'éducation comme pour le cas de ce projet.
Le cas échéant, certaines fonctionnalités restent indisponibles, telles que la génération par tile, limitées à un accès payant.
