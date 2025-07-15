= Conclusion <conclusion>

Ce travail de bachelor m'a permis de suivre les différentes étapes de création d'un projet complexe et ambitieux.
Quand bien même ce projet n'est qu'un prototype, au final, une simple démonstration technique, celle-ci adhère autant que faire se peut à l'état de l'art du métier.

C'est en tentant de respecter celles-ci que plusieurs difficultés ont été rencontrées.
La pipeline HDRP s'est révélée en effet autant complexe que puissante.
Mais un problème inatttendu et majeur de son usage a été la difficulté à créer, ou à faire fonctionner, des outils à celle-ci.
Les spécificités HDRP du langage HLSL, non content d'être un nouveau langage auquel je n'était pas familier, ont rendu tout le travail d'implémentation des tâches nice-to-have plus compliqué que prévu.

De plus, travailler avec de nombreuses et larges assets, comme ce qui sied à un prototype _Open World_, a été un défi en soi.
Trouver des assets compatibles, ou en convertir vers le format de matériel HDRP ne s'est pas fait sans mal, même si les outils d'automatisations de Unity ont grandement facilité la tâche.
Pour les tâches répétitives, je me suis appuyé sur la créattion d'outils, utilisables uniquement dans l'éditeur, pour les automatiser autant que faire se peut.

Dans l'ensemble, néanmoins, la totalité des objectifs du cahier des charges ont été atteints, ou, à défaut, traités de manière significative.
Seule l'utilisation de shaders pour représenter l'herbe n'a pas pu être menée à terme, en raison de la complexité de cette tâche.

Il a également été difficile de suivre la méthodologie de travail décrite dans le cahier des charges.
Les sprints de deux semaines lors de la milestone 4 n'ont pas été scrupuleusement respectés, mais le compte rendu hebdomadaire m'a forcé à réaliser un compte rendu personnel chaque semaine, bien que moins formel.
L'utilisation de GitHub Project dès la milestone 1 était trop prématurée; le projet constituait principalement de recherches et de prototypage à ce moment-là.
Mais une fois l'usage du GitHub Project mise en place, après le passage de la milestone 3, celui-ci a été utilisé de manière à consigner organiser les nombreuses tâches restantes à effectuer, et son usage a été plus que bénéfique.

Quant à Unity et les prochaines avancées technologiques pour le moteur, certaines sont considérées, telles que les imposteurs ou Streaming Virtual Textures.
Mais en l'état tant Unity que la pipeline HDRP n'offrent pas des solutions miracles pour améliorer les performances si ce n'est une lecture attentive de la documentation et tests de performances réguliers pour évaluer l'état du projet.

@unity-roadmap

À côté de la compétition Unreal Engine et ses nombreuses solutions disponibles directement dans le moteur, Unity fait pâle figure.
Et si l'on compare le moteur avec son concurrent open source, Godot, force est de constater que la communauté de Unity, tant au niveau des assets que des outils mis à disposition, est en grande partie divisée, la faute probablement aux différentes pipelines de rendu.

Finalement, 

TODO closing words