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

== Génération procédurale de terrain

Il existe de nombreux outils de générations procédurale de terrains.
Ceux-ci se présentent sous la forme de plugins dans un moteur de jeu ou en tant qu'outils externes.
Parmi les outils externes, Gaea, Houdini et World Creator sont les plus importants pour l'état de l'art actuel.
Ces outils permettent, entre autres, de simuler effets de météo tel que l'érosion, de générer un terrain de manière infinie, et d'exporter les ressources nécessaires dans différents formats qui seront utilisables par les moteurs de jeux.

En raison de l'utilisation industrielle de ces outils, le tiers gratuit qu'ils possèdent éventuellement limitent bon nombre de ressources, notamment l'export sous forme de tiles, qui permettrait de passer outre la limitation de taille d'export 1024 x 1024 px.

L'échelle des mondes virtuelles varie grandement :
- The Elder Scrolls V: Skyrim - 40km²
- GTA V - 76km²
- The Legend of Zelda : Breath of the Wild - 80km²
- The Witcher 3 : 125 km²
- The Elder Scrolls II: Daggerfall - 1 600 km²
- The Crew - 5 200 km²
- Fuel - 18 000 km²
- Microsoft Flight Simulator - 510 000 000 km² - Carte se basant sur la Terre, ceci est sa surface.
- Minecraft - 3 600 000 000 km² - Carte générée entièrement procéduralement selon chaque partie

Les logiciels de génération procédurale permettent de générer jusqu'à 1km² dans les tiers gratuits

== Autres

Typst pour la rédaction du rapport au travers de l'extension Tinymist pour Visual Studio Code.

Jetbrains Rider avec GitHub Copilot.

Blender et l'extension `Level Of Detail Generator | Lods Maker` pour la génération de LODs.

GIMP pour l'édition d'images.
