= État de l'art <etatdelart>

Le développement de jeux vidéos est complexe car il demande une grande spécialisation dans de nombreux domaines : Programmation en temps réel, rendu graphique, gestion du son et des inputs utilisateur, intelligence artificielle, etc. 

Pour cette raison, les moteurs de jeux sont des solutions quasiment nécessaires pour un développement rapide et pour facilement rejoindre d'autres projets. Cela se fait au détriment ou de la performance ou du build final, puisque ces moteurs de jeux sont des outils très puissants mais dont les fonctionnalités ne sont pas toutes nécessaires.

En excluant les moteurs de jeux privés, il existe néanmoins beaucoup de possibilités de moteurs de jeux dont les tarifs restent non payants pourvu que ce soit, ou à titre éducatif, ou lorsque les revenus restent au niveau amateur. Voici une liste résumée ainsi qu'une étude détaillée des plus populaires, répondant aux besoins du projet.

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Moteurs de jeu*], [*Sortie initiale*], [*Rendu graphique*], [*Langage*], [*Open Source*],[*Code Source disponible*],
  ),
  "CryEngine", "2002", "3D", "C++/C#/Lua", "Non", "Oui",
  "GameMaker", "2007", "2D", "GML", "Non", "Non",
  "Godot", "2014", "2D/3D", "GDScript/C#", "Oui", "Oui",
  "Löve", "2008", "2D", "Lua", "Oui", "Oui",
  "Rogue Engine", "2020", "3D", "Js", "Oui", "Oui",
  "Unity", "2005", "2D/3D", "C#", "Non", "Partiellement",
  "Unreal Engine", "2014", "3D", "C++", "Non", "Oui",
)

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
Réaliser une pull request pour ajouter sa contribution au moteur est possible mais est bien souvent ignoré.
De plus, en raison de la large complexité du moteur, la codebase est très grande et difficile à comprendre pour un nouveau venu.

== Godot

Moteur de jeu open source, principalement axé 2D, mais dont la partie 3D a connu une amélioration significative ces dernières années.

Très léger et bien plus compact que les deux moteurs précédents, il manque néanmoins de beaucoup de fonctionnalités.
Très souvent, il est alors nécessaire de passer par des workarounds ou de développer soi-même les fonctionnalités manquantes, ce qui va dans le sens de la communité open source que ce moteur représente.

Tout comme Unreal Engine, les contributions par pull request sont possibles, mais ne sont pas toujours acceptées si celles-ci sortent du cadre des corrections de bugs, certaines ignorées jusqu'à une année.

== Conclusion

Chaque moteur dispose de forces et de faiblesses. Certains sont plus adaptés pour des projets très spécifiques, tel que RenPy pour les visual novels, tandis que d'autres permettent une plus grande flexibilité. Pour un projet tel que pour un travail de Bachelor, Godot ou Unity seraient appropriés en terme d'échelle et de facilité de prise en main. Le premier manque malheureusement encore de fonctionnalités 3D et représente une prise de risque quant à la réussite de ce projet, là où Unity est déjà très bien établi.

De plus, le 

== Techniques

Un grand nombre de techniques visant à améliorer les performances ont vues le jour.
Ci-dessous le tableau résumant la disponibilité de ces techniques dans les trois moteurs de jeu les plus populaires.

#table(
  columns: (auto, auto, auto, auto, auto, auto),
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
