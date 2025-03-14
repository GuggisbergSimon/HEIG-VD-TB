= Outils utilisés <tools>

== Git et GitHub

Une GitHub Action de GameCI permet d'automatiser tests unitaires et builds de Unity.
Ceci n'est pas requis mais est une bonne pratique.

GitHub bloque tout fichier, à l'upload, de plus de 100MB.
Une première limite se situe à 25MB; l'interface web refuse l'upload.
À 50MB, un avertissement est affiché lors d'un push.
Pour éviter ces limitations, et pour faciliter le travail sur des larges assets, Git LFS est la solution à ces problèmes.
GitHub propose avec Git LFS Data, dans sa version gratuite, une bande passante de 1GB/mois et un stockage de 1GB.
Pour automatiser l'ajout de fichiers binaires dans Git LFS, le fichier `.gitattributes` de GameCI est utilisé.
Malheureusement, un fichier `.gitattributes` ne possède pas de notion de conditions quant à la taille des fichiers.
Cela a comme conséquence que tous les fichiers binaires listés seront ajoutés, y compris ceux en dessous de 100MB ou même 25MB.

Un projet GitHub Project sous forme Kanban permet de suivre l'implémentation des tâches à réaliser.
Les différents états de celuic-ci sont les suivants : Backlog -> Ready -> In Progress -> Done.

== Unity

Unity dispose de 3 pipelines de rendus graphique. À noter que certaines assets sont compatibles avec plusieurs pipelines, mais demandent un patchage, qui peut en partie être automatisé par Unity.
- Standard - built-in est celle par défaut. Il s'agit d'une option legacy que les deux suivantes tentent de remplacer depuis plusieurs années.
- URP - Universal Render Pipeline est un rendu visant la performance afin de couvrir le grand marché mobile (\~50% du marché).
- HDRP - HD Render Pipeline est un rendu visant la qualité graphique. Plus compliqué à prendre en main. Les plate-formes vouées pour de tels projets sont celles PC et consoles.

Parmi ces trois pipelines, URP est la plus adaptée pour le type de projet qu'est ce travail de bachelor. 
La performance est en effet au coeur de la problématique, disposer d'un rendu photoréaliste n'est pas nécessaire et la prise en main de cette pipeline représenterait un défi en plus.

En terme de rendu graphique, il existe deux espaces de couleur différents dans Unity, `Linear` et `Gamma`.
`Linear` est celui-ci par défaut dans Unity mais n'est pas représentatif de la réalité.
`Gamma` est plus proche de la réalité et est le standard actuel, aussi connu sous le nom sRGB.
Il s'agit de ce deuxième espace de couleur qui a été choisi.

Un terrain dans Unity est un composant qui permet le sculpage et le texturage d'un relief 3D.
L'intérêt de cette fonctionnalité est pour la génération procédurale d'un terrain, basé sur le bruit de Perlin.

impostor : pixyz -> unity industry
plugins : amplify

== Autres

Typst pour la rédaction du rapport au travers de l'extension Tinymist pour Visual Studio Code.

Jetbrains Rider avec GitHub Copilot.

Blender et l'extension `Level Of Detail Generator | Lods Maker` pour la génération de LODs.

GIMP pour l'édition d'images.
