= État de l'art <etatdelart>

== Moteurs de jeux

Le développement de jeux vidéos est complexe car il demande une spécialisation dans de nombreux domaines : Programmation en temps réel, rendu graphique, gestion du son et des inputs utilisateur, intelligence artificielle, etc. 

Pour cette raison, les moteurs de jeux sont des solutions quasiment nécessaires pour un développement rapide. 
Utiliser des moteurs de jeux établis et populaires, plutôt qu'un moteur de jeu exclusif à une compagnie, permet de réduire les potentiels bugs rencontrés, de bénéficier de plus nombreuses fonctionnalités, et de faciliter l'intégration de nouveaux employés, à la condition que ceux-ci soient déjà familiers avec ces outils.

Voici une liste non exhaustive de plusieurs moteurs de jeux, et une étude approfondie des trois les plus populaires en 2024.

#table(
  columns: (23%, auto, auto, 20%, 13%, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Moteurs de jeu*], [*Début*], [*Rendu*], [*Langage*], [*Open Source*],[*Code Source*],
  ),
  "CryEngine", "2002", "3D", "C++ C# Lua", "Non", "Oui",
  "GameMaker", "2007", "2D", "GML", "Non", "Non",
  strong("Godot"), "2014", "2D/3D", "GDScript C#", "Oui", "Oui",
  "Löve", "2008", "2D", "Lua", "Oui", "Oui",
  "Ren'Py", "2004", "2D(3D)", "Python", "Oui", "Oui",
  "Rogue Engine", "2020", "3D", "Js", "Oui", "Oui",
  strong("Unity"), "2005", "2D/3D", "C#", "Non", "Partiellement",
  strong("Unreal Engine"), "1998", "3D", "C++", "Non", "Oui",
)

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

== Techniques

Un grand nombre de techniques visant à améliorer les performances ont vues le jour.
Les trois moteurs de jeu les plus populaires détaillés précédemment permettent tous de couvrir ces techniques, au contraire de Ren'Py, par exemple.

#table(
  columns: (auto, auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Techniques*], [*Godot*], [*Unity*], [*Unreal Engine*],
  ),
  "Frustum Culling", "Oui", "Oui", "Opt out",
  "Occlusion Culling", "Opt in", "Opt in", "Opt in",
  "Lightmap", "Opt in", "Opt in", "Opt in",
  "LOD", "Opt in", "Opt in", "Opt in",
  "Impostor", text(fill: red,"Plugins"), text(fill: red,"Plugins"), "Opt in",
  "Digital Elevation Model", text(fill: red,"Plugins"), "Opt in", "Opt in",
)

@godot-documentation
@unity-documentation
@unreal-documentation

=== Viewing-Frustum Culling

Consiste à ne pas afficher tout élément en dehors du champ de vision du rendu.

TODO

=== Hidden-surface determination (Occlusion culling)

Consiste à ne pas afficher tout élément caché par un autre. 
Très efficace dans les espaces intérieurs. 

TODO

=== Mipmaps

Set de textures de résolutions plus petites que celle originale à afficher.
Ces textures sont pré calculées et peuvent bien souvent être générées par un moteur de jeu.
Similaires aux LODs, mais pour les textures.
Une mipmap 0 serait de résolution 64x64 par exemple, une mipmap 1 de 32x32, 2 de 16x16, etc.
La texture correspondant à la distance de la caméra est ensuite chargée.

Une contrainte pour posséder des mipmaps, et de disposer de textures dont la taille sont des puissances de 2.
Cette particularité est également utilisée par la Crunch Compression.
Celle-ci permet une compression des assets très agressive pour le build tout en ayant de très bonnes performances en runtime.

@unity-documentation

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

Certains moteurs de jeux, tels que Unity, permettent de mixer différents modes de rendus de lumière.
Ainsi, un objet serait sensible à la lumière d'une lightmap, mais également à une lumière dynamique, afin d'ajouter, par exemple, un éclairage dramatique dans un endroit précis.

Reste que la contrainte la plus importante des lightmaps est que pour une lumière globale, par exemple celle d'un soleil pour simuler un cycle jour-nuit, la technique de lightmap ne peut pas être utilisée.
Cette technique reste néanmoins utile pour tous les milieux dépourvus de lumière dynamique, tels que des intérieurs.

=== Level of detail (LOD)

TODO

@lod-3d-graphics

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

=== Cesium

Cesium est une plate-forme mettant différentes ressources à disposition pour le rendu géospatial.
Cela inclue une large base de données de 3DTiles ou d'imageries satellites.
Plusieurs implémentations existent, que ce soit pour le web avec CesiumJS, ou pour les moteurs de jeux avec Unreal et Unity.

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

=== Conclusion

La solution Cesium est une solution très complète et puissante pour le rendu géospatial de notre planète.
Ceci n'est malheureusement que rarement adapté dans le développement d'un jeu vidéo.
Cette industrie préfère se tourner vers des solutions plus adaptées à leurs besoins, au travers des outils de génération procédurale mentionnés précédemment.
Finalement, la complexité des outils ne permettrait pas d'implémenter les techniques d'optimisation mentionnées dans le cahier des charges.
En effet, Cesium for Unity implémente déjà le streaming de données du terrain et le recentrage du joueur en tout temps au centre du monde.

En raison de ces contraintes d'outils et de la décision de la taille du prototype, il a été décidé de se limiter à un terrain de 64km².
Celle-ci sera représenté par une heightmap de 8192x8192 pixels.
