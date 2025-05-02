= État de l'art <etatdelart>

== Moteurs de jeux

Le développement de jeux vidéos est complexe car il demande une spécialisation dans de nombreux domaines : programmation en temps réel, rendu graphique, gestion du son et des inputs utilisateur, intelligence artificielle, etc. 

Pour cette raison, les moteurs de jeux sont des solutions quasiment nécessaires pour un développement rapide.
Utiliser des moteurs de jeux établis et populaires, plutôt qu'un moteur de jeu exclusif à une compagnie, permet de réduire les potentiels bugs rencontrés, de bénéficier de plus nombreuses fonctionnalités, et de faciliter l'intégration de nouveaux employés, à la condition que ceux-ci soient déjà familiers avec ces outils.

#figure(
  table(
    columns: (21%, auto, auto, auto, auto, auto, auto),
    [*Moteurs de jeu*], [*Début*], [*Rendu*], [*Langage*], [*Open Source*],[*Code Source*],[*Sorties 2024*],
    strong("Unity"), "2005", "2D/3D", "C#", "Non", "Partiellement", "12638",
    strong("Unreal Engine"), "1998", "3D", "C++", "Non", "Oui", "4707",
    strong("Godot"), "2014", "2D/3D", "GDScript C#", "Oui", "Oui", "1296",
    "GameMaker", "2007", "2D", "GML", "Non", "Non", "1120",
    "PyGame", "2000", "2D/3D", "Python", "Oui", "Oui", "870",
    "Ren'Py", "2004", "2D", "Python", "Oui", "Oui", "839",
    "RPG Maker", "1992", "  2D", "Ruby/Js", "Non", "Non", "704",
    "Löve", "2008", "2D", "Lua", "Oui", "Oui", "41",
    "idTech", "1993", "3D", "C++", "Partiellement", "Partiellement", "14",
    "CryEngine", "2002", "3D", "C++ C# Lua", "Non", "Oui", "1",
  ),
  caption: "Liste non exhaustive de moteurs de jeux, par nombre de sorties steam 2024, estimées par steamDB"
)

À noter que, pour le cas de Godot, le nombre de sorties a doublé depuis 2023.

Les trois moteurs de jeux 3D les plus populaires sont Unity, Unreal Engine et Godot et ce sont ces trois moteurs qui auront une analyse détaillée dans la section suivante.

@steamdb

=== Godot

Moteur de jeu open source, principalement axé 2D, mais dont la partie 3D a connu une amélioration significative ces dernières années.

Très léger et bien plus compact que les deux autres moteurs, il manque néanmoins de beaucoup de fonctionnalités.
Très souvent, il est alors nécessaire de passer par des workarounds ou de développer soi-même les fonctionnalités manquantes, ce qui va dans le sens de la communité open source que ce moteur représente.

Les contributions par pull request sont possibles, mais ne sont pas toujours acceptées si celles-ci sortent du cadre des corrections de bugs, certaines ignorées jusqu'à une année.

=== Unity

Représente \~50% des jeux sortis en 2024 sur la plateforme de vente Steam.
Moteur polyvalent capable de faire autant 2D que 3D, populaire autant parmis les amateurs que parmis les professionnels.

Facile à prendre en main et dispose d'une très large documentation malgré un code source partiellement indisponible.
Ce code source peut être acheté par une entreprise, si besoin est.

Malheureusement, Unity ne scale néanmoins pas très bien avec une grande quantité d'assets et de membres d'équipe.
De plus, un grand nombre de fonctionnalités importantes, disponibles via des packages officiels externes, ne sont pas toujours bien intégrés, restant souvent en preview pendant de longues années.

=== Unreal Engine

Représente \~30% des jeux sortis en 2024 sur la plateforme de vente Steam.
Moteur axé 3D dont le rendu se veut principalement photoréaliste, et ce au travers de nombreuses techniques de rendu et d'optimisation.

Au contraire de Unity, il dispose de nombreux outils et une bien meilleure gestion des assets et des équipes, ce qui rend son utilisation bien plus aisée pour des projets pour de plus grande envergure.
La raison principale à cela est que les fonctionnalités de celui-ci sont développées sur des projets de jeux vidéo existants, ce que Unity ne fait pas.

Malheureusement, Unreal Engine est plus difficile d'accès et demande souvent de modifier le code source quand les rares fonctionnalités prévues ne suffisent pas.
Réaliser une pull request pour ajouter sa contribution au moteur est possible mais est bien souvent ignoré, bien plus souvent que pour Godot.
De plus, en raison de la large complexité du moteur, la codebase est très grande et difficile à comprendre pour un nouveau venu.

=== Conclusion

Chaque moteur dispose de forces et de faiblesses. Certains sont plus adaptés pour des projets très spécifiques, tel que Ren'Py pour les visual novels, tandis que d'autres permettent une plus grande flexibilité.

Pour un projet tel que pour un travail de Bachelor, Godot ou Unity seraient appropriés en terme d'échelle et de facilité de prise en main.
Le premier manque malheureusement encore de fonctionnalités 3D et représente une prise de risque quant à la réussite de ce projet, là où Unity est déjà très bien établi.

== Problèmes

=== Overdraw

Overdraw est le terme pour désigner le fait de rendre à l'écran un pixel plusieurs fois.
Cela est, à grande échelle, une perte de performance massive car le GPU doit traiter plusieurs fois chaque pixel de l'écran.
Cela peut être dû à des objets transparents, superposés, ou un maillage trop complexe, cf. LOD.

=== Lumières

Les lumières, et particulièrement les ombres, ont toujours été un problème dans la course au rendu réaliste 3D.
Chaque lumière dynamique produisant une ombre doit effectuer un pass via un zbuffer pour chaque objet impacté par celle-ci.

Bien qu'il existe des méthodes plus modernes pour aboutir à une fidélité graphique plus élevée, telles que le raytracing ou le pathtracing, ces méthodes sont très coûteuses en termes de performances et ne sont pas supportées pour toutes les supports.

=== Mémoire vidéo

Les textures, meshes, et autres ressources graphiques nécessaires pour le rendu sont stockées dans la mémoire vidéo, ou VRAM.
Or, celle-ci étant limitée, il n'est pas forcément possible de charger toutes les ressources avec leur qualité maximale.

== Techniques

Un grand nombre de techniques visant à améliorer les performances ont vues le jour.
Les trois moteurs de jeu les plus populaires détaillés précédemment permettent tous de couvrir ces techniques, au contraire de Ren'Py, par exemple.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    [*Techniques*], [*Godot*], [*Unity*], [*Unreal Engine*],
    "Frustum Culling", "Oui", "Oui", "Opt out",
    "Occlusion Culling", "Opt in", "Opt in", "Opt in",
    "Lightmap", "Opt in", "Opt in", "Opt in",
    "LOD", "Opt in", "Opt in", "Opt in",
    "Impostor", text(fill: gray,"Plugins"), text(fill: gray,"Plugins"), "Opt in",
    "Digital Elevation Model", text(fill: gray,"Plugins"), "Opt in", "Opt in",
  ),
  caption: "Techniques couvertes par les trois moteurs de jeux plus populaires"
)

=== Viewing-Frustum Culling

Consiste à limiter l'affichage à ce qui est visible par la caméra.
Ceci est aussi plus communément connu sous le nom de bounding box.
Cette box contient un near clipping plane, un far clipping plane, et les bords de la caméra, consistant, ainsi, une boîte.
Seuls les éléments présents dans celle-ci doivent être affichés, et cela représente une amélioration simple et implémentée par défaut dans les trois moteurs de jeux principaux.

@unity-documentation
@godot-documentation

#figure(
  image("images/frustum_culling.png", width: 60%),
  caption: [
    Frustum culling en action, en rouge les objets ayant été retirés.
  ],
)

=== Hidden-surface determination (Occlusion culling)

Consiste à ne pas afficher un élément étant caché par un autre afin d'éviter les problèmes d'overdraw.
Cette technique est très efficace dans les espaces intérieurs mais nécessite une mise en place particulière.
En effet, pour pouvoir ne pas rendre des parties d'une scène, il faut que la scène soit divisée en plusieurs parties petites.
De plus, les moteurs de jeux Godot et Unity demandent une mise en place additionnelle pour que la technique soit appliquée.

@godot-documentation
@unity-documentation
@unreal-documentation

#figure(
  image("images/occlusion_culling.png", width: 60%),
  caption: [
    Occlusion culling en action, en bleu les objets ayant été retirés.
  ],
)

=== Lightmap

Texture contenant les informations précalculées de l'éclairage et des ombres.
Permet une excellente combinaison entre fidélité de rendu graphique et performances.
Cela s'effectue au prix de :
- En amont :
  - Mise en place de différents composants.
  - Temps de calcul requis.
- En runtime :
- Espace mémoire utilisé pour stocker la texture.
-  Impossibilité de changer la lumière dynamiquement.

Certains moteurs de jeux, tels que Unity, permettent de mélanger différents modes de rendus de lumière.
Ainsi, un objet serait sensible à la lumière d'une lightmap, mais également à une lumière dynamique, afin d'ajouter, par exemple, un éclairage dramatique dans un endroit précis.

Reste que la contrainte la plus importante des lightmaps est que pour une lumière globale, par exemple celle d'un soleil pour simuler un cycle jour-nuit, la technique de lightmap ne peut pas être utilisée.
Cette technique reste néanmoins utile pour tous les milieux dépourvus de lumière dynamique, tels que des intérieurs.

@godot-documentation
@unity-documentation
@unreal-documentation

=== Mipmaps

Il s'agit de set de textures de résolutions plus petites que celle originale à afficher.
Ces textures sont pré calculées et peuvent bien souvent être générées par un moteur de jeu.
C'est une technique smilaires aux LODs, mais pour les textures.
Une mipmap 0 serait de résolution 64x64 par exemple, une mipmap 1 de 32x32, 2 de 16x16, etc.
La texture correspondant à la distance de la caméra est ensuite chargée.

Cette technique possède plusieurs légers défauts néanmoins.
- L'espace disque utilisé par les textures est doublé.
  Le coût est minime, par rapport à la taille occupée par des modèles, mais reste un facteur à prendre en compte.
- Chargement additionnel
  - Espace mémoire limité.
    L'alternative est de charger l'entiéreté de la mipmap, y compris la texture originale, en mémoire, tel un atlas de textures.
    Le coût est double, tout comme pour celui sur le disque, mais ici il s'agit d'un contexte plus critique.
  - Charger les textures n'est pas instantané.
    Si l'on souhaite charger chaque mipmap texture au moment de son utilisation, un effet de popping peut être notable par l'utilisateur.

Une contrainte pour posséder des mipmaps, et de disposer de textures dont la taille sont des puissances de 2.
Cette particularité est également utilisée par la technique d'optimisation d'assets appellée Crunch Compression.
Celle-ci permet une compression des assets très agressive pour l'espace disque du build tout en ayant de très bonnes performances en runtime.

@unity-documentation

#figure(
  image("images/mipmaps.png", width: 60%),
  caption: [
    Exemples de différentes mipmaps par taille décroissante.
  ],
)

=== Level of detail (LOD)

Lorsque des modèles au maillage complexe sont affichés à l'écran de manière distante, le GPU va devoir traiter pour chaque pixel tous les triangles se trouvant dans celui-ci.
Cela est très coûteux en terme de performances et n'apporte pas une grande valeur au rendu graphique.
Il s'agit d'un problème typique dû à l'overdraw, ici non pas de pixels exactement mais de triangles.

Les LODs ou Level of Detail sont des modèles 3D de résolutions basses, qui, comme leur nom l'indique, possèdent plusieurs niveaux de détails.
C'est une technique smilaires aux mipmaps, mais pour les modèles.
Le niveau de détail original est LOD 0 tandis qu'un moins détaillé serait LOD 1 puis LOD 2, etc.
Une autre amélioration est de supprimer les objets entièrements passés une certaine distance.
Ceci est particulièrement utile pour des objets de petites tailles, dont leur absence ne sera pas visible par l'utilisateur passé une certaine distance.
Cette technique a plusieurs coûts, néanmoins.
- Espace disque. 
  Plusieurs modèles pour un seul modèle 3D va accroître l'espace disque utilisé par l'application. 
  Bien que ceci soit négligeable puisque les modèles LODs seront strictement plus légers que celui original, cela reste un coût à prendre en compte.
- Travail de modélisation.
  Modéliser ces LODs peut être réalisé de manière automatique, mais demandent tout de même un travail additionel via un logiciel d'édition 3D.
  Pour une meilleure fidélité, cependant, il est préférable d'allouer plus de temps pour une modélisation manuelle de ces LODs.
- Chargement additionel.
  - Espace mémoire limité.
    Il serait possible de charger l'entiéreté des LODs en mémoire, tel un atlas de modèles, mais ce coût est autrement plus conséquent que les mipmaps.
  - Charger les modèles n'est pas instantané.
    Il est possible, pour des modèles particulièrement lourds, que la transition entre les différents LODs soit trop soudaine ou que le chargement du modèle LOD requis soit trop longue.
    Cela peut créer un effet de popping et peut nuire à l'expérience utilisateur.

Pour pallier à ce dernier problème, il est possible d'effectuer une transition entre deux LODs via un effet de dithering.
Le dithering est une technique de rendu graphique qui consiste à ajouter du bruit à une texture pour simuler un effet de transparence.
Ici, le LOD disparaissant verra sa transparence progressivement augmenter via le dithering.
Cette technique a néanmoint un coût puisque cela ajoute de l'overdraw entre les deux LODs, l'un deux semi transparent.

@lod-3d-graphics

#figure(
  image("images/LOD0Image.png", width: 60%),
  caption: [
    Exemple de deux LODs d'un même modèle 3D.
  ],
)

=== Impostor

Forme avancée de Billboards.
Les Billboards sont des quads affichant une texture dont la rotation est ajustée pour toujours faire face à la caméra.
Différentes variantes existent, certaines permettant aux billboards de figer la rotation d'un ou plusieurs axes afin de contraindre le billboard à n'être visible que depuis une vue panoramique.
TODO explain with picture

Les billboards ont comme particularité de représenter une image 2D dans un environnement 3D, ce qui est parfait pour des objets distants, mais cette solution comporte des limitations.
Afin de rendre une image 3D dans un environnement 3D, il faut dessiner le modèle, selon l'angle requis et les conditions de lumière.
Lorsque l'angle entre la caméra et l'objet est trop grand par rapport à celui-ci initial pour l'imposteur actuel, alors un second imposteur est dessiné.
Les GPUs modernes disposent d'API permettant plus facilement de générer les imposteurs, en raison de la popularité de la technique.

Pour mettre à jour un imposteur deux possibilités existent :
- Baked : Demande un espace de stockage pour l'atlas de textures générées. Un bon shader peut également ajouter des conditions de lumières, des ombres, etc.
- Runtime : plus coûteux mais rend mieux les conditions de lumières, d'éventuelles animations procédurales, etc.

@nvidia-true-impostors

== Digital Elevation Model

Il s'agit de la manière de représenter la surface d'un environnement 3D, partitionné via une grille.
Chaque case de cette grille représente un morceau de terrain, qui peuvent être mis bout à bout lorsque chargés consécutivement.
Ces cases sont souvent appelées tiles, leur taille peut grandement varier, tout comme leur fonctionnalités.
Parmi lesquelles :
- Une heightmap qui sert à dénoter l'élevation du terrain depuis un fichier de texture noir et blanc où les valeurs [0, 1] représentent les valeurs minimales et maximales du modèle.
- Des textures qui sont appliquées sur le terrain, souvent en fonction de la hauteur, de la pente, ou d'autres critères.
- Des détails qui sont des objets 3D placés sur le terrain, tels que de la végétation, rochers, etc.

Chacun des trois moteurs de jeu dispose de sa propre solution pour afficher un environnement 3D.
Que ce soient les Landscapes dans Unreal Engine ou les Terrains dans Unity, ceux-ci remplissent la même fonction.
À noter que Godot ne dispose pas de solution intégrée directement, mais plusieurs plugins permettent de pallier à ce manque.

@unity-documentation
@unreal-documentation
@godot-terrain3D

=== Cesium

Cesium est une plate-forme mettant différentes ressources à disposition pour le rendu géospatial.
Cela inclue une large base de données de 3DTiles ou d'imageries satellites.
Plusieurs implémentations existent, que ce soit pour le web avec CesiumJS, ou pour les moteurs de jeux avec Unreal et Unity.

@cesium

==== 3DTiles

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

@3D-tiles

==== glTF

glTF, Graphics Library Transmission Format, est un standard développé par Khronos Group, aussi connu pour OpenXR, OpenGL, Vulkan et WebGL. 
Il s'agit d'un standard de format de fichier 3D qui permet de transmettre de manière efficiente des modèles, scènes 3D, et animations.
Le format est entre autre connu pour son standard de matériaux PBR (Physically Based Rendering).
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

=== Génération procédurale de terrain

Il existe de nombreux outils de générations procédurale de terrains.
Ceux-ci se présentent sous la forme de plugins dans un moteur de jeu ou en tant qu'outils externes.
Parmi les outils externes, Gaea, Houdini et World Creator sont les plus importants pour l'état de l'art actuel.
Ces outils permettent, entre autres, de simuler effets de météo tel que l'érosion, de générer un terrain de manière infinie, et d'exporter les ressources nécessaires dans différents formats qui seront utilisables par les moteurs de jeux.
En raison de l'utilisation industrielle de ces outils, ils ne sont néanmoins pas tous mis à disposition à des fins d'éducation.
Le cas échéant, certaines fonctionnalitées restent indisponibles, limités aux tiers payants.

L'échelle des mondes virtuels varie grandement :
- The Elder Scrolls V: Skyrim - 40km²
- GTA V - 76km²
- The Legend of Zelda : Breath of the Wild - 80km²
- The Witcher 3 : 125 km²
- The Elder Scrolls II: Daggerfall - 1 600 km²
- The Crew - 5 200 km²
- Fuel - 15 000 km²
- Microsoft Flight Simulator - 510 000 000 km² - Carte aux dimensions 1:1 de la Terre.

D'autres mondes virtuels sont eux générés intégralement de manière procédurale.
Ceci permet un monde unique pour chaque utilisateur, variant à chaque génération.
Leur taille, quant à elle, explose et est difficilement quantifiable, du milliard de km² jusqu'à des unités spatiales permettant de représenter notre galaxie.

@world-machine
@world-creator
@gaea
@houdini

=== Conclusion

La solution Cesium est une solution très complète et puissante pour le rendu géospatial de notre planète.
Ceci n'est malheureusement que rarement adapté dans le développement d'un jeu vidéo.
Cette industrie préfère se tourner vers des solutions plus adaptées à leurs besoins, au travers des outils de génération procédurale mentionnés précédemment.
Finalement, la complexité des outils ne permettrait pas d'implémenter les techniques d'optimisation mentionnées dans le cahier des charges.
En effet, Cesium for Unity implémente déjà le streaming de données du terrain et le recentrage du joueur en tout temps au centre du monde.

En raison de ces contraintes d'outils et de la décision de la taille du prototype, il a été décidé de se limiter à un terrain de taille minimal de 64km².
Celui-ci sera représenté par une heightmap de 8192x8192 pixels.
