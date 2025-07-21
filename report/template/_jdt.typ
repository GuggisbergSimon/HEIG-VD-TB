== Journal de travail

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header[Milestone][Date][Réalisation],
    "1", "22.02.2025", "- Mise en place repo, GitHub Project
- Familiarisation avec Typst
- Recherche état de l'art
- Rédaction du cahier des charges", 
    "1", "03.03.2025", "- Recherche des techniques à implémenter plus tard (LOD, Imposteurs, Occlusion culling & Frustum Culling)
- Distinction plus en profondeur des différences entre chaque moteur jeu
- Utilisation de Git LFS
- Mise en place un système de CI/CD via GitHub Actions pour automatiser builds + releases
- Prototype sommaire déplacement",
    "1", "12.03.2025", "- Recherche d'assets pour environnement basique
- Implémentation des assets et d'un environnement plus grand
- Améliorations et finition du cahier des charges
- Recherches sur implémentation déplacement personnage
- Tentatives de faire fonctionner CI/CD pour fichiers typst",
    "1", "27.03.2025", "- Modification du cahier des charges
- Rédaction et recherche de plus de technologies State of the Art
- Expérimentations avec l'implémentation Unity de Cesium",
    "1", "03.04.2025", "- Fix un problème de git conséquent lié à Git LFS
- Expérimentation avec Cesium et 3DTiles
- Recherches autres technologies/outils pour génération de monde (GaeWorld Creator, World Machine, Houdini)
- Recherches d'autres assets qui pourraient correspondre au projet",
    "1", "10.04.2025", "- Automatisation builds linux + export typst lors d'une release
- Rédaction une partie de l'état de l'art  concernant les outils pour Digital Elevation Model
- Implémentation d'une large carte de 8x8 km",
    "2", "14.04.2025", "- Finition prototype en améliorant déplacements du joueur.
- Division terrains par chunks et load de dynamique et asynchrone selon la position du joueur",
    "2", "28.04.2025", "Recentrage du monde sur le joueur en tout temps, ou plutôt, sur le chunk actuellement occupé par le joueur",
    "2", "08.05.2025", "Rédaction state of the art",
    "2", "15.05.2025", "- Ajustements rapport + architecture
- Tests HDRP et WIP port du projet vers celui-ci",
    "2", "22.05.2025", "Rédaction rapport intermédiaire",
    "3", "29.05.2025", "- Finalisé rapport intermédiaire
- Port projet vers HDRP
- Ajout nouvelles assets HDRP
- Structure de benchmark pour tests de performance",
    "3", "05.06.2025", "- Amélioration fonctionnalités de load de chunk
- Explorations options de benchmark au travers de cinemachine et timeline
- WIP Implémentation des tests de performance",
    "3", "12.06.2025", "- Implémentation d'une première partie de tests de performance avec des Unity Test Framework
- Ajustements rapport selon feedback rapport intermédiaire
- Rédaction plus détaillée de la partie tests performances + implémentation",
    "4", "20.06.2025", "-Mise en place des différentes issues du Github Project
- Tentative de fix de problèmes Unity HDRP avec Linux
- Fix de bugs relatant au chargement de chunks (problème de concurrence)
- Amélioration du contrôle du joueur
- Mise en place d'une structure de boot/menu/écran de chargement
- Mise en place de plusieurs scènes avec différentes options d'optimisation pour comparer directement
- Utilisation de Graphy pour disposer de données de performance  pour un build
- Rédaction rapport concernant l'implémentation
- Divers ajustement de ressources et de paramètres pour préparer structure de test",
    "4", "27.06.2025", "- Finition de la mise en place des paramètres sélectables dans le menu principal
- Modification de l'algorithme de placement de bâtiments pour créer des `villes`
- Correction d'autres bugs de chargement de chunks
- Finition de l'implémentation des tests automatisés avec une série de tests par série de paramètres définis
- Commencement de l'implémentation des imposteurs
- Test d'usage de RenderTexture pour rendre les imposteurs
- Tentatives d'usage de IMP et URPIMP pour des imposteurs, sans succès
- Rédaction du rapport des derniers points avancés",
    "4", "04.07.2025", "- Finalisation implémentation naïve imposteurs
- Implémentation de amplify impostors
- Support activation/désactivation des imposteurs via le menu
- Tentatives d'implémentation de HDRPGrass et UnityHDRPTerrainDetailGrass
- Implémentation d'ajout de détail d'herbe via Terrain Mesh Detail, assets en provenance de scènes de démos Unity
- Rédaction rapport pour rester à jour",
    "4", "13.07.2025", "- Recherche d'autres techniques d'optimisations GPU Unity : DOTS, SRP Batcher
- Implémentation d'un cycle jour nuit pour démontrer possibilités de lumières dynamiques
- Amélioration des tests de performances pour homogénéiser les résultats
- Ajout de tests unitaires avec fonctionnalités nice to have et un optionnel pour comparer impact du SRP Batcher
- Amélioration des performances lors du chargement de chunks via la sérialisations de données par scènes/chunks
- Finition de l'implémentation de deux types d'herbe dans une scène de tests, à l'instar des imposteurs",
    "4", "18.07.2025", "- Fix de HDRP Grass pour son utilisation avec unity 6.0
- Comparaison de différents types d'herbe dans scène dédiée
- Mise en place d'une structure de demo pour comparer éléments d'herbe/imposteurs
- Ajout de petits détails visuels concernant le joueur
- Fix des distances LODs pour éviter les pops up
- Fix de matériaux n'utilisant pas GPU Instancing
- Tests de performance et analyse des résultats dans le rapport
- Rédaction du rapport pour une première tentative de version finale",
    "4", "24.07.2025", "- Relecture et corrections du rapport final
- Création de l'affiche
- Rédaction du résumé publiable",
  ),
)