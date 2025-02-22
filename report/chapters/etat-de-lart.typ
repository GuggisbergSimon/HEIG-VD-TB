= État de l'art <etatdelart>

Le développement de jeux vidéos est complexe car il demande une grande spécialisation dans de nombreux domaines : Programmation en temps réel, rendu graphique, gestion du son et des inputs utilisateur, intelligence artificielle, etc. 

Pour cette raison, les moteurs de jeux sont des solutions quasiment nécessaires pour un développement rapide et pour facilement rejoindre d'autres projets. Cela se fait au détriment ou de la performance ou du build final, puisque ces moteurs de jeux sont des outils très puissants mais dont les fonctionnalités ne sont pas toutes nécessaires.

En excluant les moteurs de jeux privés, il existe néanmoins beaucoup de possibilités de moteurs de jeux dont les tarifs restent non payants pourvu que ce soit, ou à titre éducatif, ou lorsque les revenus restent au niveau amateur. Voici une liste résumée ainsi qu'une étude détaillée des plus populaires, vis à vis des besoins du projet.

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

Malheuresement, Unreal Engine est plus difficile d'accès et demande souvent de modifier le code source quand les fonctionnalités prévues ne suffisent pas.
Réaliser une pull request pour ajouter sa contribution au moteur est possible mais est bien souvent ignoré.
De plus, en raison de la large complexité du moteur, la codebase est très grande et difficile à comprendre pour un nouveau venu.

== Godot

Moteur de jeu open source, principalement axé 2D, mais dont la partie 3D a connu une amélioration significative ces dernières années.

Très léger et bien plus compact que les deux moteurs précédents, il manque néanmoins de beaucoup de fonctionnalités.
Très souvent, il est alors nécessaire de passer par des workarounds ou de développer soi-même les fonctionnalités manquantes, ce qui va dans le sens de la communité open source que ce moteur représente.

Tout comme Unreal Engine, les contributions par pull request sont possibles, mais ne sont pas toujours acceptées si celles-ci sortent du cadre des corrections de bugs, certaines ignorées jusqu'à une année.
