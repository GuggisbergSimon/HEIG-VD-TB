= Outils utilisés <tools>

== Git et GitHub

Une GitHub Action de GameCI permet d'automatiser tests unitaires et builds de Unity.
Bien que cela ne soit pas requis dans ce projet, cela reste une bonne pratique.

En cas de fichier conséquent de plus de 100MB, limite d'upload de GitHub, Git LFS sera utilisé.
Malheureusement, GitHub LFS a grand nombre de limitations par rapport à une solution self-hosted et ne sera donc utilisé qu'au besoin, plutôt que pour tout type de fichier binaire.
Un fichier `.gitattributes` fourni par GameCI a été utilisé, dans un premier temps, pour automatiser l'ajout de fichiers binaires dans Git LFS, mais a été modifié une fois ces limitations apprises.
En effet, un fichier `.gitattributes` ne possède pas de notion de conditions quant à la taille des fichiers.
Cela a comme conséquence que tous les fichiers binaires listés auraient été ajoutés au Git LFS, y compris ceux en dessous de 100MB.

Un projet GitHub Project sous forme Kanban permet de suivre l'implémentation des tâches à réaliser.
Les différents états de celui-ci sont les suivants : Backlog, Ready, In Progress, Done.

@game-ci

== Unity

Unity a eu, pendant plusieurs années, un cycle de développement où 3, puis 2, versions majeures étaient sorties par an, avec une version LTS annuelle.
Ce n'est que récemment que ce cycle a été altéré avec une seule version majeure sortie par an, qui est ensuite supportée via LTS pendant deux ans.
Ainsi, en 2024 est sorti Unity 6.0, et début 2025 la version 6.1.
Pour ce travail de bachelor il a été décidé d'utiliser la dernière version stable, soit Unity 6.0 LTS.

Unity dispose de 3 pipelines de rendus graphique. À noter que certaines assets sont compatibles avec plusieurs pipelines, mais demandent un patch, qui peut en partie être automatisé par Unity.
- Standard - Cette pipeline est aussi connue sous le nom built-in.
  Il s'agit d'une option built-in par défaut mais n'est plus mise à jour depuis plusieurs années, destinée à être remplacée par les deux suivantes.
- URP - Universal Render Pipeline est un rendu visant la performance destiné au grand marché mobile (\~50% du marché).
- HDRP - HD Render Pipeline est un rendu visant la qualité graphique et voué au marché consoles et PC.
  Cette pipeline est plus compliquée à prendre en main au vu de la grande quantités d'outils supplémentaires.

En terme de rendu graphique, il existe deux espaces de couleur différents dans Unity, `Linear` et `Gamma`.
`Linear` est celui-ci par défaut dans Unity mais n'est pas représentatif de la réalité.
`Gamma` est plus proche de la réalité et est le standard actuel, aussi connu sous le nom sRGB.
Il s'agit de ce deuxième espace de couleur qui a été choisi.
Ce choix n'impacte que le rendu graphique et pas les performances.

@unity-doc

=== Packages

Cinemachine est un package officiel Unity qui permet de simplifier implémentation et contrôle d'une caméra.
Le contrôle de la caméra, au même titre que beaucoup de composantes dans un jeu vidéo, est un élément central.
Cinemachine offre, entre autres, la possibilité de contraindre la caméra à suivre des objets ou des chemins.

@unity-cinemachine

Terrain Tools est un package officiel Unity qui ajoute des fonctionnalités aux terrains.
Ce package a pour vocation de faciliter la création, édition et gestion de terrains.

@unity-terrain-tools

== Autres

La rédaction du rapport a été fait avec l'aide de Typst et en particulier d'un template pour les travaux de bachelor HEIG-VD.
Celle-ci a été réalisée avec Visuel Studio Code et l'extension Tinymist pour l'édition Typst.
La rédaction du code a été réalisé avec Jetbrains Rider et l'extension GiHub Copilot.

Pour l'édition de modèles 3D et la génération de LODs, plus particulièrement, bien qu'un simple modificateur decimate sous Blender aurait pu suffire, une extension tel que `Level Of Detail Generator | Lods Maker` permet de simplifier et automatiser la tâche.

Le logiciel GIMP a été utilisé pour l'édition d'images, qu'il s'agisse de textures ou d'images destinées au rapport.

@blender-lod-maker
@typst-template
