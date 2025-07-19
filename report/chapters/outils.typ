= Outils utilisés <tools>

== Git et GitHub

Une GitHub Action de GameCI permet d'automatiser tests unitaires et builds de Unity.
Bien que cela ne soit pas requis dans ce projet, une bonne pipeline CI/CD reste une bonne pratique et permet une rapide itération pour corriger des problèmes avant que ceux-ci ne prennent trop d'ampleur.

En cas de fichier conséquent de plus de 100MB, limite d'upload de GitHub, Git LFS sera utilisé.
Malheureusement, GitHub LFS a un grand nombre de limitations par rapport à une solution self-hosted et ne sera donc utilisé qu'au besoin, plutôt que pour tout type de fichier binaire.
Un fichier `.gitattributes` fourni par GameCI a été utilisé, dans un premier temps, pour automatiser l'ajout de fichiers binaires dans Git LFS, mais a été modifié une fois ces limitations apprises.
En effet, un fichier de ce type ne possède pas de notion de taille des fichiers.
Cela a comme conséquence que tous les fichiers binaires auraient été ajoutés au Git LFS, y compris ceux en dessous de 100MB.

Un projet GitHub Project sous forme Kanban permet de suivre l'implémentation des tâches à réaliser.
Les différents états de celui-ci sont les suivants : Backlog, Ready, In Progress, Done.
Les différents labels sont les suivants : bug, documentation, required, essential, nice to have.
Des tâches sont créées selon les bugs rencontrés ou en cas de subdivision de tâches plus importantes via une Tasklist.

@game-ci

== Unity

Unity a eu, pendant plusieurs années, un cycle de développement où 3, puis 2, versions majeures étaient sorties par an, avec une version LTS annuelle.
Ce n'est que récemment que ce cycle a été altéré avec une seule version majeure sortie par an, qui est ensuite supportée via LTS pendant deux ans.
Ainsi, en 2024 est sorti Unity 6.0, et début 2025 la version 6.1.

Pour ce travail de bachelor il a été décidé d'utiliser la dernière version stable : *Unity 6.0 LTS*.

Quant à installer Unity et gérer différents projets ou éditeurs, Unity Hub permet ceci en offrant également de nombreux templates de projets.

En terme de rendu graphique, il existe deux espaces de couleur différents dans Unity, `Linear` et `Gamma`.
`Linear` est celui-ci par défaut dans Unity mais n'est pas représentatif de la réalité.
`Gamma` est plus proche de la réalité et est le standard actuel, aussi connu sous le nom sRGB.
Il s'agit de ce deuxième espace de couleur qui a été choisi.
Ce choix n'impacte que le rendu graphique et pas les performances mais certains outils requièrent un espace de couleur spécifique.

@unity-doc-color-space

=== Render Pipeline

Unity dispose de trois pipelines de rendus graphique. À noter que certaines assets sont compatibles avec plusieurs pipelines, mais demandent un patch.
Patcher ces assets peut en partie être automatisé par Unity.
- Standard - Cette pipeline est aussi connue sous le nom built-in.
  Il s'agit d'une option legacy mais n'est plus mise à jour depuis plusieurs années, destinée à être remplacée par les deux suivantes.
  Elle est encore disponible mais les dernières versions de Unity ne la proposent plus par défaut.
- Scriptable Render Pipeline - Aussi abrégée SRP, à ne pas confondre avec Standard Render Pipeline, il s'agit d'une API permettant de configurer différentes commandes de rendu via scripts C\# pour l'éditeur Unity.
  Il ne s'agit pas d'une pipeline en elle-même mais homogénéise les deux pipelines suivantes et offre de créer sa propre pipeline de rendu.
    - URP - Universal Render Pipeline est un rendu visant la performance destiné au grand marché mobile (\~50% du marché).
      Cette pipeline propose moins d'options graphiques, pour des meilleures performances.
    - HDRP - High Definition Render Pipeline est un rendu visant la qualité graphique et voué au marché consoles et PC.
      Cette pipeline est plus compliquée à prendre en main au vu de la grande quantités d'outils uniques à celle-ci.
      Il s'agit de la pipeline permettant d'utiliser du ray tracing, entre autre.

Ce travail de bachelor a pour volonté d'implémenter les méthode de l'art du métier et donc d'utiliser une pipeline moderne, cela exclue la pipeline Standard.
La pipeline HDRP possède de nombreuses assets photoréalistes tandis que celle URP tend vers la stylisation avec des assets moins lourdes, avec un compte de polygones moins élevé, pour un style souvent dénommé low poly.
Il est néanmoins possible de développer des jeux haute fidélité avec URP.

Un premier prototype a été réalisé avec URP lors de la première partie de ce travail de bachelor.
Il a ensuite été porté vers HDRP, en utilisant d'autres assets, pour adhérer à la réalité du métier et tendre à un rendu haute fidélité.

@unity-scriptable-render-pipeline
@unity-urp
@unity-hdrp

=== Packages

Cinemachine est un package officiel Unity qui permet de simplifier implémentation et contrôle d'une caméra.
Le contrôle de la caméra, au même titre que beaucoup de composantes dans un jeu vidéo, est un élément central.
Cinemachine offre, entre autres, la possibilité de contraindre la caméra à suivre des objets ou des chemins.

@unity-cinemachine

Terrain Tools est un package officiel Unity qui ajoute des fonctionnalités aux terrains.
Ce package a pour vocation de faciliter la création, édition et gestion de terrains.
En raison de problèmes de ce package, il a été retiré du projet une fois son utilisation, ponctuelle, terminée.

@unity-terrain-tools

== Autres

La rédaction du rapport a été fait avec l'aide de Typst et en particulier d'un template pour les travaux de bachelor HEIG-VD.
La rédaction en elle-même a été réalisée avec Visual Studio Code et l'extension Tinymist pour l'affichage et export Typst en local.
De plus, pour les passages de code, l'extension Codly a été utilisée pour la mise en forme.
Pour l'affichage de plots, l'extension lilaq a été utilisée.

@typst-template
@typst-codly

La rédaction du code a été réalisé avec Jetbrains Rider et l'extension GiHub Copilot.

Le logiciel GIMP a été utilisé pour la création ou l'édition d'images, qu'il s'agisse de sprites, textures ou d'images destinées au rapport.

PlantUML a été utilisé pour la création de quelques diagrammes.
