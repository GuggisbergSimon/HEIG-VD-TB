= État de l'art <etatdelart>

Le développement de jeux vidéos est complexe car il demande une spécialisation dans de nombreux domaines : Programmation en temps réel, rendu graphique, gestion du son et des inputs utilisateur, intelligence artificielle, etc. 

Pour cette raison, les moteurs de jeux sont des solutions quasiment nécessaires pour un développement rapide. 
Cela a comme second avantage de faciliter de nouveaux employés à rejoindre un projet, pourvu que ceux-ci soient familiers avec les outils. 
Utiliser un moteur de jeu se fait au détriment de la performance ou de la taille du build final.

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

== Godot

Moteur de jeu open source, principalement axé 2D, mais dont la partie 3D a connu une amélioration significative ces dernières années.

Très léger et bien plus compact que les deux autres moteurs, il manque néanmoins de beaucoup de fonctionnalités.
Très souvent, il est alors nécessaire de passer par des workarounds ou de développer soi-même les fonctionnalités manquantes, ce qui va dans le sens de la communité open source que ce moteur représente.

Les contributions par pull request sont possibles, mais ne sont pas toujours acceptées si celles-ci sortent du cadre des corrections de bugs, certaines ignorées jusqu'à une année.

== Unity

Représente \~50% des jeux sortis en 2024 sur la plateforme de vente Steam.
Moteur polyvalent capable de faire autant 2D que 3D, populaire autant parmis les amateurs que parmis les professionnels.

Facile à prendre en main et dispose d'une très large documentation malgré un code source partiellement disponible.
Ce code source peut être acheté par une entreprise, si besoin est.

Malheureusement, Unity ne scale néanmoins pas très bien avec une grande quantité d'assets et de membres d'équipe.
De plus, un grand nombre de fonctionnalités importantes, disponibles via des packages officiels externes, ne sont pas toujours bien intégrés, restant souvent en preview pendant de longues années.

== Unreal Engine

Représente \~30% des jeux sortis en 2024 sur la plateforme de vente Steam.
Moteur axé 3D dont le rendu se veut principalement photoréaliste, et ce au travers de nombreuses techniques de rendu et d'optimisation.

Au contraire de Unity, il dispose de nombreux outils et une bien meilleure gestion des assets et des équipes, ce qui rend son utilisation bien plus aisée pour des projets pour de plus grande envergure.
La raison principale à cela est que les fonctionnalités de celui-ci sont développées sur des projets de jeux vidéo existants, ce que Unity ne fait pas.

Malheureusement, Unreal Engine est plus difficile d'accès et demande souvent de modifier le code source quand les rares fonctionnalités prévues ne suffisent pas.
Réaliser une pull request pour ajouter sa contribution au moteur est possible mais est bien souvent ignoré, bien plus souvent que pour Godot.
De plus, en raison de la large complexité du moteur, la codebase est très grande et difficile à comprendre pour un nouveau venu.

== Conclusion

Chaque moteur dispose de forces et de faiblesses. Certains sont plus adaptés pour des projets très spécifiques, tel que Ren'Py pour les visual novels, tandis que d'autres permettent une plus grande flexibilité.

Pour un projet tel que pour un travail de Bachelor, Godot ou Unity seraient appropriés en terme d'échelle et de facilité de prise en main.
Le premier manque malheureusement encore de fonctionnalités 3D et représente une prise de risque quant à la réussite de ce projet, là où Unity est déjà très bien établi.

== Techniques

Un grand nombre de techniques visant à améliorer les performances ont vues le jour.
Ci-dessous le tableau résumant la disponibilité de ces techniques dans les trois moteurs de jeu les plus populaires.

Les trois moteurs de jeu les plus populaires permettent tous de couvrir ces techniques, au contraire de Ren'Py, par exemple.

#table(
  columns: (23%, auto, auto, auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Moteurs de jeu*], [*Frustum Culling*], [*Occlusion Culling*], [*Lightmap*], [*LOD*],[*Impostor*],
  ),
  "Godot",          "Oui", "Opt in", "Opt in", "Opt in", "Plugins",
  "Unity",          "Oui", "Opt in", "Opt in", "Opt in", "Plugins",
  "Unreal Engine",  "Opt out", "Opt in", "Opt in", "Opt in", "Opt in",
)

=== Viewing-Frustum Culling

Consiste à ne pas afficher tout élément en dehors du champ de vision du rendu.

=== Hidden-surface determination (Occlusion culling)

Consiste à ne pas afficher tout élément caché par un autre. 
Très efficace dans les espaces intérieurs. 

=== Lightmap

TODO

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
- Runtime : plus coûteux mais rend mieux les conditions de lumières, d'éventuelles animations procédurales, etc

@nvidia-true-impostors
