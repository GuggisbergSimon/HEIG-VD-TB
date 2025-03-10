= Outils utilisés <tools>

Unity dispose de 3 pipelines de rendus graphique.
- Standard - built-in est celle par défaut. Il s'agit d'une option legacy que les deux suivantes tentent de remplacer depuis plusieurs années.
- URP - Universal Render Pipeline est un rendu visant la performance afi de couvrir le grand marché mobile (\~50% du marché).
- HDRP - HD Render Pipeline est un rendu visant la qualité graphique. Plus compliqué à prendre en main. Les plate-formes vouées pour de tels projets sont celles PC et consoles.

Parmi ces trois pipelines, URP est la plus adaptée pour le type de projet qu'est ce travail de bachelor. 
La performance est en effet au coeur de la problématique, disposer d'un rendu photoréaliste n'est pas nécessaire.

Une GitHub Action de GameCI permet d'automatiser tests unitaires et builds de Unity.
Ceci n'est pas requis mais est une bonne pratique 

GitHub LFS est utilisé pour stocker tout type de fichiers binaires, tels que les assets 3D. 
Ceci n'est pas requis mais est une bonne pratique pour un projet possédant de nombreuses ressources binaires, tel qu'un jeu vidéo.

Linear vs Gamma color space -> visual detail -> skip

impostor : pixyz -> unity industry
plugins : amplify
