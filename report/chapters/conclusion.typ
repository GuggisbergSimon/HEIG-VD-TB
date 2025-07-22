= Conclusion <conclusion>

Ce rapport présente le travail de recherche et d'exploration de l'état de l'art des techniques d'optimisation dans un premier temps.
Puis, dans un second temps, le rapport détaille l'implémentation d'un prototype de jeu vidéo en monde ouvert et de certaines de ces techniques, lorsque celles-ci sont appropriées.

C'est en tentant de respecter l'état de l'art du métier que j'ai rencontré plusieurs difficultés.
La _pipeline_ HDRP s'est révélée en effet autant complexe que puissante.
Mais un problème inattendu et majeur de son usage a été la difficulté à créer, ou à faire fonctionner, des outils avec celle-ci.
La majorité des ressources libres sont disponibles pour la _pipeline_ Standard uniquement.
De plus les spécificités HDRP et le langage HLSL, non content d'être un nouveau langage auquel je n'étais pas familier, ont rendu tout le travail d'implémentation des tâches _nice-to-have_ plus compliqué que prévu, me forçant à revoir mes priorités et à me rabattre sur des solutions pré-existantes, réalisables durant le délai imparti.

Travailler avec de nombreuses et larges ressources, comme ce qui sied à un prototype _Open World_, a également été un défi en soi.
Trouver des ressources compatibles, ou en convertir vers le format de matériel HDRP ne s'est pas fait sans mal, même si les outils d'automatisation de Unity ont grandement facilité la tâche.
Pour les tâches répétitives, je me suis appuyé sur la création d'outils de l'éditeur afin d'automatiser autant que faire se peut ces tâches.

Dans l'ensemble, néanmoins, la totalité des objectifs du cahier des charges ont été atteints, ou, à défaut, traités de manière significative.
Seule l'utilisation de shaders pour représenter l'herbe n'a pas pu être menée complètement à terme, en raison de la complexité de cette tâche.
Une comparaison des différentes solutions ainsi qu'une démonstration permettant de visualiser l'implémentation de celles-ci ont été implémentés dans le projet, sans qu'elles soient implémentées dans le prototype en elles-mêmes.

Il a également été difficile de suivre la méthodologie de travail décrite dans le cahier des charges.
L'utilisation de _GitHub Project_ dès la _milestone_ 1 était trop prématurée; le projet constituait principalement de recherche et de prototypage à ce moment-là.
Mais une fois l'usage du _GitHub Project_ mis en place, après le passage de la _milestone_ 3, celui-ci a été utilisé de manière à consigner et organiser les nombreuses tâches restantes à effectuer.
Son usage a été plus que bénéfique.
Les sprints de deux semaines lors de la _milestone_ 4 n'ont également pas été scrupuleusement respectés, mais le compte rendu hebdomadaire m'a forcé à faire le point chaque semaine, bien que moins formel qu'un sprint review.

Quant à _Unity_ et les prochaines avancées technologiques mentionnées dans l'état de l'art, certaines sont considérées pour le moteur, telles que les _Impostors_, _mesh shaders_, ou _Streaming Virtual Textures_ @unity-roadmap.
Mais, en l'état, tant _Unity_ que la _pipeline_ HDRP n'offrent pas des solutions miracles pour améliorer les performances si ce n'est une lecture attentive de la documentation et tests de performances réguliers pour évaluer l'état du projet.
Les techniques standard d'optimisation restent d'actualité, avec les LODs amenant un gain considérable de performance, et ce malgré une fidélité réaliste toujours plus grande.

Si un projet de cette envergure devrait dépasser le cadre du prototype, je ne peux qu'encourager de procéder à des recherches similaires pour les autres moteurs, en particulier _Unreal Engine_ pour un rendu haute fidélité et de nombreux outils déjà présents au sein de celui-ci.

Finalement, ce travail met en valeur l'importance de l'optimisation des performances, via anciennes et nouvelles techniques.
Le rendu graphique en temps réel est un domaine complexe.
Les challenges rencontrés à la course au photoréalisme vont de pair avec ceux qui en découlent pour les performances.
Cette course sur deux fronts est un équilibre délicat à maintenir pour tout projet d'application en temps réel.

== Remerciements

Je tiens à remercier *Bertil Chapuis* pour son encadrement et ses conseils tout au long de ce travail.
Sans sa grande confiance dans ce projet ambitieux, celui-ci n'aurait pas vu le jour sous cette forme.

Je remercie également ma famille et mes proches pour leur soutien et leur indéfectible patience durant ce travail.
