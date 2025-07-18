= État de l'art <etatdelart>

== Moteurs de jeux

Le développement de jeux vidéos est complexe car il demande une spécialisation dans de nombreux domaines : programmation en temps réel, rendu graphique, gestion du son, plusieurs types d'inputs utilisateur, intelligence artificielle, etc. 

Les moteurs de jeux ont grandement évolué, incorporant de nombreuses fonctionnalités et outiles pour facilier le développement.
L'utilisation de moteurs de jeux établis et populaires, plutôt qu'un moteur de jeu in-house exclusif à une compagnie, permet de disposer d'un large panel de fonctionnalités pour toutes sortes d'échelles et types de projets. L'intégration de nouveaux employés et le partage de connaissances est également simplifié, à la condition qu'ils soient familiers avec le moteur de jeu utilisé, bien entendu.

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
  caption: "Liste non exhaustive de moteurs de jeux, par nombre de sorties steam 2024, estimées selon steamDB"
)

À noter que, pour le cas de Godot, le nombre de sorties a doublé depuis 2023.
C'est pour cette raison et de sa caractéristique d'un moteur de jeu open source 3D qu'il a été étudié ci-dessous, avec Unity et Unreal Engine.

@steamdb

=== Godot

Godot est un moteur de jeu open source, principalement axé 2D, mais dont la partie 3D a connu une amélioration significative ces dernières années.

Très léger et bien plus compact que les deux autres moteurs, il manque néanmoins de beaucoup de fonctionnalités.
Il est alors souvent nécessaire de passer par des workarounds ou de développer soi-même les fonctionnalités manquantes afin d'éventuellement, par la suite, en faire part le reste de la communité, ce qui s'inscrit dans la philosophie FOSS du projet.

Les contributions par pull request sont possibles, mais ne sont pas toujours acceptées si celles-ci sortent du cadre des corrections de bugs, certaines ignorées jusqu'à une année.
Le moteur présente néanmoins un certain manque de matûrité et les rares projets commerciaux ayant rencontré le succès sont des projets indépendants de petite envergure, pour le moment.

=== Unity

Unity représente \~50% des jeux sortis en 2024 sur la plateforme de vente Steam.
C'est un moteur polyvalent capable de faire autant 2D que 3D, populaire autant parmis les amateurs que parmis les professionnels.

Des projets complexes open world live service tels que Genshin Impact ont été réalisés avec ce moteur et chaque année de nombreux projets commerciaux de moindre envergure rencontrent le succès.
Il est facile à prendre en main et d'une très large documentation malgré un code source partiellement indisponible, code source qui peut être acheté par une entreprise, au besoin.

Malheureusement, Unity ne scale néanmoins pas très bien pour une grande quantité d'assets ainsi qu'une large équipe.
De plus, un grand nombre de fonctionnalités importantes, disponibles via des packages officiels externes, ne sont pas toujours bien intégrés, restant souvent sans mises à jour ou en preview pendant de longues années.
Pour ne rien arranger, la communication de Unity concernant certains changements majeurs de prix a laissé à désirer, entraînant perte de confiance et exode vers d'autres moteurs de jeux, tel que Godot.

=== Unreal Engine

Unreal Engine représente \~30% des jeux sortis en 2024 sur la plateforme de vente Steam.
C'est un moteur axé 3D dont le rendu se veut principalement photoréaliste, et ce au travers de nombreuses techniques de rendu et d'optimisation.

Au contraire de Unity, il dispose de nombreux outils et d'une bien meilleure gestion des assets et des équipes, ce qui rend son utilisation plus aisée pour des projets à grande échelle.
Epic Games, la société derrière Unreal Engine, travaille également sur des jeux vidéo, tels que Fortnite, et ajoutent au moteur les nombreuses fonctionnalités développées pour ces projets.

Malheureusement, Unreal Engine est plus difficile d'accès et demande souvent de modifier le code source quand les rares fonctionnalités prévues ne suffisent pas.
Réaliser une pull request pour ajouter sa contribution au moteur est possible mais est bien souvent ignoré.
De plus, en raison de la large complexité du moteur, la codebase est vaste et difficile à appréhender pour un nouveau venu.

=== Conclusion

Chaque moteur dispose de forces et de faiblesses.
Certains sont plus adaptés pour des projets très spécifiques, tel que Ren'Py pour les visual novels, tandis que d'autres permettent une plus grande flexibilité ou proposent des outils uniques, au prix d'une courbe d'aprentissage plus élevée.

Pour un projet tel que ce travail de Bachelor, Godot ou Unity seraient appropriés en terme d'échelle et de facilité de prise en main.
Le premier manque malheureusement encore de fonctionnalités 3D et représente une prise de risque quant à la réussite de ce projet, là où Unity est déjà bien établi.

Pour ces raisons, il a été d'utiliser *Unity* pour le développement de ce projet.

== Contexte et Concepts

Cette section liste de manière succinte plusieurs concepts importants dans le rendu 3d.

=== glTF

glTF, Graphics Library Transmission Format, est un standard développé par Khronos Group, aussi connu pour OpenXR, OpenGL, Vulkan et WebGL. 
Il s'agit d'un standard de format de fichier 3D qui permet de transmettre de manière efficiente des modèles, scènes 3D, et animations.
Le format est entre autres connu pour son standard de matériaux PBR, Physically Based Rendering.
Ce standard a pour but d'homogénéiser les valeurs et de le rapprocher d'un rendu réaliste en implémentant différentes fonctionnalités telles que :
- Emissive
- Metallic
- Normal
- Roughness
- Specular
Ces propriétés sont présentes dans la plupart des moteurs de jeu et de logiciels de modélisation 3D mais ne suivent pas forcément les mêmes standards de nom ou de valeurs.
Ce standard, en particulier le subset PBR, a été largement adopté par l'industrie du jeu vidéo.

@gltf-khronos
@pbr-khronos

=== Overdraw

Overdraw est le terme désignant le fait de rendre à l'écran un pixel plusieurs fois.
Cela est, à grande échelle, une perte de performance massive car le GPU doit traiter plusieurs fois chaque pixel de l'écran.
Ce problème explose de manière quadratique en cas de résolution plus élevée.

Cela peut être dû à des objets transparents, superposés, ou un maillage trop complexe.
En effet, chaque triangle visible d'un maillage va produire un appel au GPU pour calculer les pixels qu'il occupe à l'écran.

=== Lumières

Les lumières, et particulièrement les ombres, ont toujours été un problème dans la course au rendu réaliste 3D.
Traditionellement, chaque lumière produisant une ombre doit effectuer un pass de rendu selon la résolution de ces ombres afin d'établir un Z-buffer qui va pouvoir déterminer si des objets sont dans l'ombre, ou non.
En cas d'ombres douces, cela est différent, mais la complexité du rendu ne fait que monter, et ce, pour chaque source de lumière.

Il existe également des méthodes plus modernes pour aboutir à une fidélité graphique plus élevée, telles que le raytracing ou le pathtracing, ces méthodes sont très coûteuses en termes de performances et ne sont pas supportées par tout type de hardware.

=== Stockage

On distingue plusieurs catégories de stockage.
- Mémoire vive (RAM)
- Mémoire vidéo (VRAM)
- Mémoire de stockage (SSD, HDD)

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
  Comme la quantité de points est usuellement bien plus conséquente que les sommets, il convient de procéder par interpolation de données de chaque sommet pour déterminer celle du pixel concerné.
  Ainsi la coordonnée précise d'une texture peut être déterminée, par interpolation entre trois autres connues.
- Tessellation shader :
  Ce shader permet de subdiviser de manière uniforme un maillage.
  Cela permet d'ajouter des détails de manière dynamique à un modèle, par exemple lorsque la caméra s'en approche.
- Geometry shader :
  Ce shader prend une primitive en paramètre et produit plusieurs primitives.
  Il peut générer des triangles pour représenter des simples éléments 3D, tel qu'un brin d'herbe.

De plus, il est possible d'utiliser la base d'un shader complexe mais de l'altérer pour arriver à des résultats stylistiques différents, que ce soit un rendu stylisé tel celui d'un cartoon, ou via cel-shading.

La limite des shaders consiste en leurs entrées et sorties.
Ceux-ci ne connaissent que ce qu'ils reçoivent en entrée pour procéder au rendu graphique, et la sortie habituelle d'un shader est la production d'un visuel.
Les sorties peuvent être détournées de différente manière, par exemple en écrivant en sortie une texture en mémoire, mais cela reste limité.
Les shaders ne peuvent pas être utilisés pour affecter le comportement d'autres systèmes indépendants, tel qu'un moteur physique.
Mais ils peuvent, par exemple, prendre un vecteur en entrée pour représenter le vent et simuler l'impact de celui-ci sur des brins d'herbe.

@opengl-khronos

#figure(
  image("images/shader_pipeline.png", width: 18%),
  caption: [
    Pipeline de rendu d'un shader OpenGL, en bleu les étapes programmables.
  ],
)

==== GPU Instancing

Un problème fréquemment rencontré dans les jeux vidéo est l'affichage d'une large quantité d'objets 3D identiques, tels que des brins d'herbe ou des arbres.

Pour chaque objet à représenter le CPU communique avec le GPU, et ceci représente un goulot d'étranglement pour les performances.
En effet, bien que le GPU soit très puissant pour de nombreux calculs répétitifs, transmettre de nombreuses informations de CPU à GPU est une opération coûteuse.

Une solution habituellement utilisée est de diminuer les appels de rendu, appelés draw call, via une instantiation de données sur le GPU.
Ceci est d'avantage connu sous le nom de GPU Instancing.
Au lieu de transmettre les informations de maillage et de matériaux à chaque fois, il est possible, pour un même modèle 3D, de transmettre uniquement les informations spécifiques à chaque instance de celui-ci, telles que la position, rotation et échelle.
Ceci permettra ensuite, du côté GPU, de réutiliser les informations du modèle 3D pour rendre chaque instance à un coût moindre en échange de données.

@unity-doc-gpu-instancing

=== Textures

Lorsqu'un pixel de l'écran couvre de nombreux pixels de texture, appelé texels, il est difficile de déterminer rapidement la couleur du pixel à afficher.
La manière correcte revient à établir la moyenne de chaque texel présent dans le pixel, mais c'est une opération coûteuse pour n'afficher, au final, qu'un pixel pour un modèle distant.

La technique des mipmaps consiste à pré-calculer un set de textures de résolutions plus petites que celle originale à afficher.
La texture correspondant à la distance de la caméra est ensuite chargée, pour éviter ces problèmes de rendu visuel, tout en garantissant une bonne performance.
Pour une texture originale de 64x64, la mipmap 0, alors les niveaux suivants seraient une mipmap 1 de 32x32, 2 de 16x16, 3 de 8x8, etc.

Cette technique n'a pour défaut que l'augmentation de l'espace disque et vidéo utilisé par l'application.
Ceci se fait au prix d'un facteur 4/3, soit 33% espace mémoire supplémentaire, ce qui reste minime pour une amélioration visuelle significative comme celle-ci.

Une alternative aux mipmaps est un filtre anisotrope. 
Celui-ci permet d'améliorer le rendu visuel dans les cas où la face d'un modèle est orientée de manière oblique à la caméra.
Le prix pour cette technique est un facteur 4, soit 300% espace mémoire supplémentaire.

Une contrainte pour ces deux techniques est de disposer de textures dont la taille sont des puissances de 2.
Cette particularité est entre autres utilisée par la technique d'optimisation d'assets appelée Crunch Compression.
Celle-ci permet une compression des assets très agressive pour l'espace disque du build tout en ayant de très bonnes performances en runtime.

@unity-doc-mipmap

#figure(
  image("images/mipmaps.png", width: 60%),
  caption: [
    Exemples de différentes mipmaps par taille décroissante.
  ],
)

=== Précision floating point

Les floats sont préférés par rapport aux doubles pour le développement de jeux vidéo en raison de leur taille moindre en mémoire au coût d'une précision moindre.
Cette précision n'est pas requise pour la plupart des calculs.
Néanmoins, lorsque l'échelle des mondes virtuels atteint une taille immense, ou minuscule, la précision des floats peut poser problème.
Une manière commune de contourner ces problèmes est de changer la taille initiale du monde virtuel, par exemple, en le réduisant de 1000x, mais pour un monde virtuel possédant plusieurs échelles de grandeur à respecter, ceci n'est pas une solution viable.

La manière dont un float 32 est encodé en mémoire est la suivante : 
- 1 bit pour le signe
- 8 bits pour l'exponent
- 23 bits pour la fraction

Un nombre float 32 est donné sous la forme : 
$(-1)^{"signe"} dot 2^{"exponent"-127} dot (1 + "fraction")$

La formule pour l'erreur est donnée sous la forme :
$~2^(floor(log_2("distance"))-"fraction")$

Ainsi, pour une valeur telle que le rayon de la terre, ~6378 km, la précision d'un float 32 est de \~0.5m.
Pour une échelle humaine cela n'est plus tolérable et pourrait même être directement observable.

@oracle-float

== Techniques

Un grand nombre de techniques visant à améliorer les performances ont vues le jour au fil des années.
Certaines sont devenues de facto standard tardent encore à être implémentées par les moteurs de jeux.
Parfois des techniques disparaissent de l'horizon pour revenir sous un autre nom, tel que les megatexture, maintenant plus connues sous le nom de Streaming Virtual Texturing.

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

Cette technique consiste à limiter l'affichage à ce qui est visible par la caméra dans un hexaèdre.
Cet hexaèdre est plus communément connu sous le nom de bounding box.
Cette box contient un near clipping plane, un far clipping plane, et les bords de la caméra, consistant, ainsi, une boîte à 6 faces.
Seuls les éléments présents dans celle-ci vont être affichés.
Cela représente une amélioration simple et efficace implémentée par défaut dans les trois moteurs de jeux analysés.

Les valeurs telles que les bords de la caméra sont directement dépendantes de la caméra et du champ de vision, FOV, utilisé.
Le near et far clipping plane sont des valeurs définies par l'utilisateur. 
Des valeurs trop petites pour le near clipping plane créeraient des artefacts graphiques proches d'un modèle tandis que des valeurs trop grandes pour le far clipping plane nécessiterait de rendre à l'écran des objets distants à peine visible.

@unity-doc-occlusion-culling
@godot-doc-occlusion-culling
@unreal-doc-visibility-culling

#figure(
  image("images/frustum_culling.png", width: 60%),
  caption: [
    Frustum culling en action, en rouge les objets ayant été retirés.
  ],
)

=== Hidden-surface determination (Occlusion culling)

Cette technique consiste à ne pas afficher un élément étant caché par un autre afin d'éviter les problèmes d'overdraw.
Cela est très efficace dans les espaces intérieurs mais nécessite une mise en place particulière dans la plupart des moteurs de jeux.
En effet, pour pouvoir indiquer au moteur de jeu quelles parties omettre, ou non, il faut que la scène soit constituée de plusieurs éléments, plutôt que d'un seul modèle 3D.
De plus, il faudra ensuite indiquer quels éléments peuvent déclencher une occlusion, un mur typiquement, et quels éléments seraient sujets à cela, des objets cachés derrière un mur, par exemple. 

#figure(
  image("images/occlusion_culling.png", width: 60%),
  caption: [
    Occlusion culling en action, en bleu les objets ayant été retirés.
  ],
)

Unreal Engine permet une utilisation dynamique de cette technique, qui peut néanmoins être désactivée.

@unity-doc-occlusion-culling
@godot-doc-occlusion-culling
@unreal-doc-visibility-culling

=== Lightmap

Il s'agit d'une texture contenant les informations précalculées de l'éclairage et des ombres.
Cette technique permet une excellente combinaison entre fidélité de rendu graphique et performances.
Cela s'effectue au prix de :
- En amont :
  - Mise en place de différents composants.
  - Temps de calcul requis, appelé baking.
- En runtime :
  - Espace mémoire utilisé pour stocker la texture.
  -  Impossibilité de changer la lumière dynamiquement.

Certains moteurs de jeux, tels que Unity, permettent de mélanger différents modes de rendus de lumière.
Ainsi, un objet serait sensible à la lumière d'une lightmap, mais également à une lumière dynamique, afin d'ajouter, par exemple, un éclairage dramatique dans un endroit précis.

Néanmoins, la contrainte la plus importante des lightmaps reste que, pour une lumière globale comme un soleil pour simuler un cycle jour-nuit, la technique de lightmap ne peut pas être utilisée.
Cette technique reste néanmoins utile pour tous les milieux dépourvus de lumière dynamique, tels que des intérieurs.

@unity-doc-lightmap
@godot-doc-lightmap
@unreal-doc-lightmap

=== Streaming Virtual Texturing

Il s'agit d'une technique aussi connu sous le nom de Megatexture dans le moteur idTech, pré-datant leurs implémentations modernes dans Unity et Unreal Engine.
Elle consiste à disposer d'une seule grande texture avec des coordonnées UV pour l'indexer.
En runtime, cette texture est ensuite streamée et mise en mémoire selon les besoins.
Cela a comme avantage visuel de bénéficier de textures uniques pour chaque surface ainsi que de limiter le chargement et déchargement de textures en mémoire, puisqu'une seule est chargée en tout temps.

@unity-doc-svt
@unreal-doc-svt

=== Mesh Shader

Cette technologie n'a pour le moment qu'une implémentation dans le moteur Unreal Engine sous le nom de Nanite.
Elle ne s'applique que pour les objets statiques, ceux qui ne bougent pas, typiquement un environnement fixe.
Les modèles sont analysés lors de l'import afin d'être streamé de manière efficace lors du runtime et de n'afficher que les triangles visibles au niveau de détail requis.
Cela permet l'affichage de modèles 3D très complexes, en s'affranchissant du nombre de polygones comme métrique de ralentissement, et donc d'améliorer grandement la fidélité visuelle.

Une implémentation future de cette technique est en considération par Unity pour le moment.

@nvidia-mesh-shader
@unreal-doc-nanite

=== Level of detail (LOD)

Lorsque des modèles au maillage complexe sont affichés à l'écran de manière distante, le GPU va devoir traiter pour chaque pixel tous les triangles à sa position.
Afficher des modèles complexes distants est donc très coûteux en terme de performances et n'apporte pas une grande valeur au rendu graphique.
Il s'agit d'un problème typique d'overdraw.

Les LODs ou Level of Detail sont des modèles 3D basse résolution, qui, comme leur nom l'indique, possèdent plusieurs niveaux de détails.
La technique est similaire aux mipmaps, mais pour les modèles.
Le niveau de détail original est LOD 0 tandis qu'un moins détaillé serait LOD 1 puis LOD 2, etc.
Une autre amélioration est de supprimer les objets entièrements passés une certaine distance.
Ceci est particulièrement utile pour des objets de petites tailles, dont leur absence ne sera pas visible par l'utilisateur passé une certaine distance.

Cette technique a néanmoins plusieurs coûts :
- Espace disque. 
  Plusieurs modèles pour un seul modèle 3D va accroître l'espace disque utilisé par l'application. 
  Bien que ceci soit négligeable puisque les modèles LODs seront strictement plus légers que celui original, cela reste un coût à prendre en compte.
- Travail de modélisation.
  Modéliser ces LODs peut être réalisé de manière automatique, mais pour une meilleure fidélité, il est préférable d'allouer plus de temps pour une modélisation manuelle de ces LODs.
- Chargement additionel.
  - Espace mémoire limité.
    Il serait possible de charger l'entiéreté des LODs en mémoire, tel un atlas de modèles, mais ce coût est autrement plus conséquent que les mipmaps.
  - Charger les modèles n'est pas instantané.
    Il est possible, pour des modèles particulièrement lourds, que la transition entre les différents LODs soit trop soudaine ou que le chargement du modèle LOD requis soit trop longue.
    Cela peut créer un effet de popping et peut nuire à l'expérience utilisateur.

Pour pallier à ce dernier problème, il est possible d'effectuer une transition entre deux LODs via un effet de dithering.
Le dithering est une technique de rendu graphique qui consiste à ajouter du bruit à une texture pour simuler un effet de transparence.
Ici, le LOD disparaissant verra sa transparence progressivement augmenter via le dithering.
Cette technique a néanmoint un coût puisque cela ajoute de l'overdraw entre les deux LODs, l'un deux semi-transparent.

@lod-3d-graphics

#figure(
  image("images/LOD0Image.png", width: 60%),
  caption: [
    Exemple de deux LODs d'un même modèle 3D.
  ],
)

=== Impostor

Les imposteurs sont une forme avancée de Billboards qui tentent de résoudre le problème de l'overdraw.
Les Billboards affichent la texture pour un modèle distant sur des quads dont la rotation peut être ajustée pour toujours faire face à la caméra.
Différentes variantes existent, certaines permettant aux billboards de figer la rotation d'un ou plusieurs axes.
Une utilisation commune de cette technique est pour représenter la végétation, que ce soit herbe ou arbres.
Les Billboards ont comme particularité de représenter une image 2D dans un environnement 3D, ce qui est parfait pour des objets distants, mais cette solution comporte des limitations.

Afin de rendre l'image d'un modèle 3D dans un environnement 3D, il faut dessiner le modèle, selon l'angle requis et les conditions de lumière.
Lorsque l'angle entre la caméra et l'objet est trop grand par rapport à celui-ci initial pour l'imposteur actuel, alors un second imposteur est dessiné.
Les GPUs modernes disposent d'API facilitant la génération d'imposteurs, en raison de la popularité de la technique.

Unity, au contraire de Unreal Engine, ne propose pas de solution facile d'accès pour les imposteurs.
Une solution existe pour les utilisateurs souscrivant à Unity Industry seulement.
Le package offrant cette option est Pixyz, un outil permettant l'import de modèles CAD sous plusieurs formes, telles qu'un nuage de points.

Une autre solution notable pour Unity est l'utilisation d'un plugin inofficiel, tel que Amplify Impostors, disponible sur Unity Asset Store.

Une première solution est de rendre les imposteurs en runtime via une caméra virtuelle capturant ceux-ci.
Cela a comme avantage d'être plus simple à implémenter et de rendre correctement les conditions de lumières, d'éventuelles animations procédurales, textures animées, etc.

Une seconde solution possible est celle précalculée, Baked.
Ce type d'imposteurs est bien moins coûteux en performance, mais est plus complexe à mettre en place.

Cela consiste à générer des atlas de textures représentant le modèle 3D d'un imposteur selon différents angles de vue.
L'imposteur consistera ensuite à afficher la texture correspondant à l'angle de vue actuel de la caméra.
Cette technique demande un plus grand espace mémoire vidéo pour stocker l'atlas de textures générées.
Chaque texture générée aura une taille habituellement de 2048x2048 pixels, ce qui résultera, dans le cas d'un atlas 16x16, de 128x128 pixels attribués à chaque image servant d'imposteur.
Le nombre de ces textures peut varier selon la qualité du shader utilisé pour représenter les imposteurs.
Un bon shader peut également ajouter des conditions de lumières, des ombres, interpolation entre deux points de vue, etc.

Il existe plusieurs types d'imposteurs Baked : sphérique, octahèdre et semi-octahèdre.
Cette spécification détermine la manière dont les captures de perspective sont effectuées.
Chaque capture de perspective est effectuée à un angle défini par un sommet.

Pour une meilleure qualité d'image l'octahèdre est recommandé, ou semi-octahèdre si les imposteurs ne seront pas vus depuis le bas.
La répartition sphérique est souvent plus rapide mais présente un défaut visuel lors du changement d'un imposteur à un autre.

@amplify-impostors
@medium-octahedral-impostors
@nvidia-true-impostors
@unreal-doc-impostor
@unity-pixyz-impostor

#figure(
  grid(
    columns: 3,
    image("images/Spherical.png", width: 50%),
    image("images/Octahedron.png", width: 50%),
    image("images/HemiOctahedron.png", width: 50%),
  ),
  caption: [
    Les différents types d'imposteurs Baked, de gauche à droite : sphérique, octahèdre et semi-octahèdre.
  ],
)

#figure(
  grid(
    columns: 2,
    image("images/impostors_camera.jpg", width: 70%),
    image("images/impostors_atlas.jpg", width: 70%)
  ),
  caption: [
    À gauche: Placement de caméras pour le rendu Baked d'un imposteur semi-octahèdre.
    
    À droite: Atlas de textures pour un imposteur Baked semi-octahèdre.
  ],
)

=== Terrain et Landscape

Il s'agit de la manière de représenter la surface d'un environnement 3D, partitionné via une grille.
Chaque case de cette grille représente un morceau de terrain.
Ces cases, souvent appelées tiles, peuvent être mis bout à bout lorsque chargés consécutivement.
Leurs dimensions peuvent grandement varier, tout comme leurs fonctionnalités.
Parmi lesquelles :
- Une heightmap qui sert à dénoter l'élevation du terrain depuis un fichier de texture noir et blanc où les valeurs [0, 1] représentent les valeurs minimales et maximales du modèle.
- Des textures qui sont appliquées sur le terrain, souvent en fonction de la hauteur, de la pente, ou d'autres critères.
- Des détails qui sont des objets 3D placés sur le terrain, tels que de la végétation, rochers, etc.

Chacun des trois moteurs de jeu dispose de sa propre solution pour afficher un environnement 3D.
Que ce soient les Landscapes dans Unreal Engine ou les Terrains dans Unity, ceux-ci remplissent la même fonction.
À noter que Godot ne dispose pas de solution intégrée directement, mais plusieurs plugins permettent de pallier à ce manque.

Bien que l'échelle des mondes virtuels varie grandement, il est possible de distinguer trois grandes catégories, ce qui n'empêche pas des titres ambitieux de vouloir couvrir plusieurs de ces échelles. :
- Une échelle à taille humaine est la plus courante dans les jeux vidéo car elle est celle qui permet de faciliter l'immersion du joueur en incarnant directement un personnage.
  Le personnage sera souvent contraint à des tailles, vitesses, habituels pour un humain.
  Outre les mondes générés procéduralement, il est rare que des mondes pour cette échelle dépassent les 150km².
  À noter que, malgré la popularité de cette échelle, elle comporte une charge de travail accru au niveau animation/modélisation de l'avatar, si celui-ci est visible.
  
  Jeux notables : 
    - The Elder Scrolls V : Skyrim - 40km²
    - The Legend of Zelda : Breath of the Wild - 80km²
    - The Witcher 3 - 125 km²

- Une échelle à taille véhicule est moins habituelle et dispose d'une grande variation.
  En effet, cela peut autant couvrir la zone d'une ville, la surface d'un continent, voire même de la planète Terre entière.
  Que ce soit voiture, hélicoptère, avion, le mode de transport choisi va grandement influencer la taille du monde virtuel.
  Les assets pour cette échelle seront souvent moins détaillées puisque celles-ci seront ou trop éloignées de la caméra, ou le joueur ne pourra pas les examiner attentivement en raison de la vitesse du véhicule.

  Jeux notables : 
    - The Crew - 5 200 km²
    - Fuel - 15 000 km²
    - Microsoft Flight Simulator - 510 000 000 km² - Carte aux dimensions 1:1 de la Terre.

- Une échelle à taille spatiale est tout ce qui se trouve au-delà, couvrant tant un système solaire que celui d'une galaxie entière.
  Les unités pour ces mondes sont souvent quantifiées en unités astronomiques.
  En raison de ces tailles colossales, ces mondes sont souvent représentés via de la génération procédurale, plutôt que d'avoir été méticuleusement designés par des artistes. À titre d'exemple, No Man's Sky dispose de 18 quintillions de planètes que les joueurs peuvent explorer à échelle humaine.

D'autres mondes virtuels sont eux générés intégralement de manière procédurale lors du lancement d'une partie.
Ceci garantit un monde unique pour chaque utilisateur, variant à chaque génération.
Leur taille, quant à elle, explose et est difficilement quantifiable, allant du milliard de km² jusqu'à des unités spatiales permettant de représenter notre galaxie.

@unity-doc-terrain
@unreal-doc-landscape
@godot-terrain3D

==== Cesium

Cesium est une plate-forme mettant différentes ressources à disposition pour le rendu géospatial.
Cela inclue une large base de données de 3DTiles ou d'imageries satellites.
Plusieurs implémentations existent, que ce soit pour le web avec CesiumJS, ou pour les moteurs de jeux avec Unreal et Unity.
Cet outil requière néanmoins une connexion internet pour streamer les données, et est donc dépendant d'un service tiers, ce qui n'est pas forcément souhaitable pour un jeu vidéo.

3DTiles est un format de données 3D géospatial permettant l'affichage, streaming et partage de celles-ci.
Le format est maintenu par Cesium et est particulièrement adapté pour le streaming de données massives en runtime.
3DTiles utilise le format glTF pour les tiles.
Un tileset est un ensemble de tiles, et chaque tile peut contenir des tiles enfants.
L'affichage se fait via Frustum culling, et affiche l'entiéreté d'une tile enfant.

Plusieurs types de tiles existent :
- Modèles 3D : Dans le cas de modèles répétés de nombreuses fois avec de faibles variations il est possible de procéder par instanciation en faisant varier les propriétés de chaque instance.
- Nuages de points : Ce type de données est obtenu via photogrammétrie ou par un scan LIDAR. 
  Ce format permet d'approximer la surface d'un objet 3D en représentant, dans l'espace, l'ensemble du nuage de points.
- Tiles composites : Il est également possible de mélanger les différents types de tiles ensemble.

@cesium
@3D-tiles

==== Génération procédurale de terrain

Il existe de nombreux outils de générations procédurale de terrains.
Ceux-ci se présentent sous la forme de plugins dans un moteur de jeu ou en tant qu'outils externes.
Parmi les outils externes, Gaea, Houdini et World Creator sont les plus importants pour l'état de l'art actuel.
Ces outils permettent, entre autres, de simuler effets de météo tel que l'érosion, de générer un terrain de manière infinie, et d'exporter les ressources nécessaires dans différents formats qui seront exploitables par les moteurs de jeux.
Ces outils utilisent l'édition via noeuds pour pouvoir et représenter chaque étape intermédiaire de manière intuitive pour les artistes, et permettre aux opérations de ne pas être destructives.

#figure(
  image("images/gaea_example.jpg", width: 100%),
  caption: [
    Interface de Gaea, avec un terrain généré en exemple.
  ],
)

En raison de l'utilisation industrielle de ces outils, ils ne sont néanmoins pas tous mis à disposition à des fins d'éducation.
Le cas échéant, certaines fonctionnalitées restent indisponibles, limités aux tiers payants.

@world-machine
@world-creator
@gaea
@houdini