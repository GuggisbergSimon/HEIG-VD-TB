= Conclusion <conclusion>

Ce travail de bachelor m'a permis de suivre les différentes étapes de création d'un projet Unity complexe et ambitieux.
Quand bien même celui-ci n'est au final qu'un prototype, qu'une simple démonstration technique, il adhère autant que faire se peut à l'état de l'art du métier.

C'est en tentant de respecter l'état de l'art que plusieurs difficultés ont été rencontrées.
La pipeline HDRP s'est révélée en effet autant complexe que puissante.
Mais un problème inattendu et majeur de son usage a été la difficulté à créer, ou à faire fonctionner, des outils avec celle-ci.
Les spécificités HDRP et le langage HLSL, non content d'être un nouveau langage auquel je n'étais pas familier, ont rendu tout le travail d'implémentation des tâches nice-to-have plus compliqué que prévu, me forçant à revoir mes priorités et à me rabbatre sur des solutions pré-existantes, réalisables durant le délai imparti.

De plus, travailler avec de nombreux et larges assets, comme ce qui sied à un prototype _Open World_, a été un défi en soi.
Trouver des assets compatibles, ou en convertir vers le format de matériel HDRP ne s'est pas fait sans mal, même si les outils d'automatisation de Unity ont grandement facilité la tâche.
Pour les tâches répétitives, je me suis appuyé sur la création d'outils de l'éditeur afin d'automatiser autant que faire se peut ces tâches.

Dans l'ensemble, néanmoins, la totalité des objectifs du cahier des charges ont été atteints, ou, à défaut, traités de manière significative.
Seule l'utilisation de shaders pour représenter l'herbe n'a pas pu être menée complètement à terme, en raison de la complexité de cette tâche.
Une comparaison des différentes solutions ainsi qu'une démonstration permettant de visualiser l'implémentation de celles-ci ont été implémentés dans le projet, sans qu'elles soient implémentées dans le prototype en elles-mêmes.

Il a également été difficile de suivre la méthodologie de travail décrite dans le cahier des charges.
L'utilisation de GitHub Project dès la milestone 1 était trop prématurée; le projet constituait principalement de recherches et de prototypage à ce moment-là.
Mais une fois l'usage du GitHub Project mise en place, après le passage de la milestone 3, celui-ci a été utilisé de manière à consigner et organiser les nombreuses tâches restantes à effectuer.
Son usage a été plus que bénéfique.
Les sprints de deux semaines lors de la milestone 4 n'ont également pas été scrupuleusement respectés, mais le compte rendu hebdomadaire m'a forcé à faire le point chaque semaine, bien que moins formel qu'un sprint review.

Quant à Unity et les prochaines avancées technologiques mentionnées dans l'état de l'art, certaines sont considérées pour le moteur, telles que les imposteurs ou Streaming Virtual Textures.
Mais en l'état tant Unity que la pipeline HDRP n'offrent pas des solutions miracles pour améliorer les performances si ce n'est une lecture attentive de la documentation et tests de performances réguliers pour évaluer l'état du projet.

@unity-roadmap

La compétition Unreal Engine et ses nombreuses solutions disponibles directement dans le moteur fait pâle figure à Unity.
De plus si l'on compare le moteur avec son concurrent open source, Godot, force est de constater que la communauté de Unity, tant au niveau des assets que des outils mis à disposition, est en grande partie divisée, la faute probablement aux différentes pipelines de rendu.

Si un projet de cette envergure devrait dépasser le cadre du prototype, je ne peux qu'encourager de procéder à des recherches similaires pour les autres moteurs, en particulier Unreal Engine pour un rendu haute fidélité.

Finalement, ce travail met en valeur l'importance de l'optimisation des performances, via anciennes et nouvelles techniques.
Le rendu graphique en temps réel est un domaine complexe.
Les challenges rencontrés à la course au photoréalisme vont de pair avec ceux qui en découlent pour les performances.
Cette course sur deux fronts est un équilibre délicat à maintenir pour tout projet.

== Remerciements

Je tiens à remercier *Bertil Chapuis* pour son encadrement et ses conseils tout au long de ce travail.
Sans sa grande confiance dans ce projet ambitieux, celui-ci n'aurait pas vu le jour sous cette forme.

Je remercie également ma famille et mes proches pour leur soutien et leur indéfectable patience durant ce travail.