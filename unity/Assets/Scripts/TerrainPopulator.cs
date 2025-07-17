using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using Random = UnityEngine.Random;
#if UNITY_EDITOR
using UnityEditor.SceneManagement;
using System.IO;
#endif

public class TerrainPopulator : MonoBehaviour {
#if UNITY_EDITOR
    [SerializeField] private int seed = 42;
    [SerializeField] private string chunksDirectory = "Assets/Scenes/Chunks";
    [SerializeField] private GameObject[] buildingPrefabs;
    [SerializeField] private GameObject[] clutterPrefabs;
    [SerializeField] private GameObject[] grassPrefabs;
    [SerializeField] private float yOffsetBuilding = 0f;
    [SerializeField] private float yOffsetClutter = 0f;
    [SerializeField] private int sampleFactor = 3;
    [SerializeField] private float clutterDensityAugment = 0.2f;
    [SerializeField] private float clutterDensityFactor = 0.1f;
    [SerializeField] private int buildingCountPerTerrain = 50;
    [SerializeField] private float densityPower = 2.5f;
    [SerializeField] private Vector2Int[] citiesCoords;
    [SerializeField] private int citySampleFactor = 10;
    [SerializeField] private float cityDensityFactor = 3f;
    [SerializeField] private float cityBuildingScaleFactor = 4f;
    [SerializeField] private float minScaleCity = 0.8f, maxScaleCity = 1.2f;
    [SerializeField] private float minScaleGrass = 1f, maxScaleGrass = 2f;
    [SerializeField] private float grassDensityFactor = 0.5f;
    [SerializeField] private float detailDensityFactor = 1f;
    [SerializeField] private int grassDetailResolution = 1024;
    [SerializeField] private int grassDetailResolutionPerPatch = 8;
    
    [ContextMenu("Add Chunk Scripts To Chunk Scenes")]
    private void AddChunkToChunkScenes() {
        string chunksPath = "Assets/Scenes/Chunks/";
        string[] sceneGuids = AssetDatabase.FindAssets("t:Scene", new[] { chunksPath });

        foreach (string guid in sceneGuids) {
            string scenePath = AssetDatabase.GUIDToAssetPath(guid);
            Scene scene = EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Additive);

            GameObject chunkObject = null;
            foreach (GameObject rootObj in scene.GetRootGameObjects()) {
                if (rootObj.GetComponent<Terrain>() != null) {
                    chunkObject = rootObj;
                    break;
                }
            }

            if (chunkObject != null) {
                Chunk chunkComponent = chunkObject.GetComponent<Chunk>();
                if (chunkComponent == null) {
                    chunkComponent = chunkObject.AddComponent<Chunk>();
                }

                chunkComponent.Build();

                EditorSceneManager.SaveScene(scene);
            }

            EditorSceneManager.CloseScene(scene, true);
        }

        AssetDatabase.SaveAssets();
    }

    [ContextMenu("Place and Save Buildings")]
    private void PlaceBuildings() {
        string[] sceneFiles = Directory.GetFiles(chunksDirectory, "*.unity");
        foreach (string sceneFile in sceneFiles) {
            EditorSceneManager.OpenScene(sceneFile, OpenSceneMode.Single);
            PlaceBuildingsInActiveTerrains();
            EditorSceneManager.SaveScene(SceneManager.GetActiveScene());
        }
    }

    [ContextMenu("Place Buildings")]
    private void PlaceBuildingsInActiveTerrains() {
        Random.InitState(seed);
        foreach (var terrain in Terrain.activeTerrains) {
            terrain.gameObject.isStatic = false;
            TerrainData terrainData = terrain.terrainData;
            for (int i = terrain.transform.childCount - 1; i >= 0; i--) {
                DestroyImmediate(terrain.transform.GetChild(i).gameObject);
            }

            int posX = (int)terrain.transform.position.x;
            int posZ = (int)terrain.transform.position.z;

            // Check if this terrain is a city based on its name
            bool isCity = false;
            string terrainName = terrain.gameObject.name;
            if (terrainName.StartsWith("Terrain_")) {
                string[] parts = terrainName.Split('_');
                if (parts.Length >= 3 && int.TryParse(parts[1], out int coordX) &&
                    int.TryParse(parts[2], out int coordY)) {
                    Vector2Int terrainCoord = new Vector2Int(coordX, coordY);
                    isCity = System.Array.Exists(citiesCoords, cityCoord => cityCoord.Equals(terrainCoord));
                    if (isCity) {
                        Debug.Log($"City terrain detected: {terrainName} at coordinates ({coordX}, {coordY})");
                    }
                }
            }
            
            // Get Min/Max heights
            float minHeight = float.MaxValue;
            float maxHeight = float.MinValue;
            int heightmapResolution = terrainData.heightmapResolution;
            for (int x = 0; x < heightmapResolution; x++) {
                for (int z = 0; z < heightmapResolution; z++) {
                    float height = terrainData.GetHeight(x, z);
                    minHeight = Mathf.Min(minHeight, height);
                    maxHeight = Mathf.Max(maxHeight, height);
                }
            }

            float heightRange = maxHeight - minHeight;
            int densityMultiplier = isCity ? citySampleFactor : 1;
            int samplePoints = buildingCountPerTerrain * sampleFactor * densityMultiplier;
            Vector3 terrainCenter = new Vector3(
                terrain.transform.position.x + terrainData.size.x / 2,
                0,
                terrain.transform.position.z + terrainData.size.z / 2
            );
            for (int i = 0; i < samplePoints; i++) {
                Vector3 position = new Vector3(
                    Random.Range(posX, posX + terrainData.size.x),
                    0,
                    Random.Range(posZ, posZ + terrainData.size.z)
                );
                
                // Lower height = higher density
                float terrainHeight = GetTerrainHeight(terrain, position.x, position.z);
                float heightFactor = 1f - Mathf.Clamp01((terrainHeight - minHeight) / heightRange);
                float density = Mathf.Pow(heightFactor, densityPower);

                if (isCity) {
                    density = Mathf.Min(1.0f, density * cityDensityFactor);
                }

                // Buildings placement
                if (Random.value < density) {
                    position.y = terrainHeight + yOffsetBuilding + terrain.transform.position.y;

                    Quaternion rotation;
                    if (isCity) {
                        rotation = Quaternion.Euler(0, Random.Range(0, 360), 0);
                    } else {
                        // For non-city areas, align with terrain normal
                        rotation = Quaternion.FromToRotation(Vector3.up, GetTerrainNormal(terrainData,
                                       position.x - terrain.transform.position.x,
                                       position.z - terrain.transform.position.z)) *
                                   Quaternion.Euler(0, Random.Range(0, 360), 0);
                    }

                    GameObject building = buildingPrefabs[Random.Range(0, buildingPrefabs.Length)];
                    GameObject instance = (GameObject)PrefabUtility.InstantiatePrefab(building, terrain.transform);
                    instance.transform.position = position;
                    instance.transform.rotation = rotation;

                    if (isCity) {
                        float distanceToCenter =
                            Vector3.Distance(new Vector3(position.x, 0, position.z), terrainCenter);
                        float maxDistance = Mathf.Sqrt(terrainData.size.x * terrainData.size.x +
                                                       terrainData.size.z * terrainData.size.z) / 2;
                        float normalizedDistance = Mathf.Clamp01(distanceToCenter / maxDistance);

                        // Scale factor is higher in the center (inverse relationship with distance)
                        float centerScaleFactor = Mathf.Lerp(1.5f, 0.7f, normalizedDistance);
                        float randomFactor = Random.Range(minScaleCity, maxScaleCity);
                        instance.transform.localScale *= cityBuildingScaleFactor * centerScaleFactor * randomFactor;
                    }
                }

                // Clutter placement
                float clutterDensity = clutterDensityFactor * (heightFactor + clutterDensityAugment);
                if (Random.value < clutterDensity) {
                    position.y = terrainHeight + yOffsetClutter + terrain.transform.position.y;
                    Quaternion rotation =
                        Quaternion.FromToRotation(Vector3.up, GetTerrainNormal(terrainData,
                            position.x - terrain.transform.position.x,
                            position.z - terrain.transform.position.z)) *
                        Quaternion.Euler(0, Random.Range(0, 360), 0);

                    GameObject clutter = clutterPrefabs[Random.Range(0, clutterPrefabs.Length)];
                    GameObject instance = (GameObject)PrefabUtility.InstantiatePrefab(clutter, terrain.transform);
                    instance.transform.position = position;
                    instance.transform.rotation = rotation;
                }
            }
        }
    }
    
    
    [ContextMenu("Paint and Save Grass Details")]
    private void PaintGrassDetails() {
        string[] sceneFiles = Directory.GetFiles(chunksDirectory, "*.unity");

        foreach (string sceneFile in sceneFiles) {
            EditorSceneManager.OpenScene(sceneFile, OpenSceneMode.Single);
            PaintGrassDetailsInActiveTerrains();
            EditorSceneManager.SaveScene(SceneManager.GetActiveScene());
        }
    }

    [ContextMenu("Paint Grass Details")]
    private void PaintGrassDetailsInActiveTerrains() {
        Random.InitState(seed);
        foreach (var terrain in Terrain.activeTerrains) {
            TerrainData terrainData = terrain.terrainData;
            
            // Set up detail resolution
            terrainData.SetDetailResolution(grassDetailResolution, grassDetailResolutionPerPatch);
            
            // Create detail prototypes from grass prefabs
            DetailPrototype[] detailPrototypes = new DetailPrototype[grassPrefabs.Length];
            for (int i = 0; i < grassPrefabs.Length; i++) {
                detailPrototypes[i] = new DetailPrototype {
                    usePrototypeMesh = true,
                    prototype = grassPrefabs[i],
                    alignToGround = 0,
                    positionJitter = 0,
                    minWidth = minScaleGrass,
                    maxWidth = maxScaleGrass,
                    minHeight = minScaleGrass,
                    maxHeight = maxScaleGrass,
                    noiseSpread = 0.1f,
                    holeEdgePadding = 0,
                    density = detailDensityFactor,
                    renderMode = DetailRenderMode.VertexLit,
                    useInstancing = true,
                    useDensityScaling = true,
                };
            }
            terrainData.detailPrototypes = detailPrototypes;

            // Clear any existing details first
            for (int i = 0; i < terrainData.detailPrototypes.Length; i++) {
                int[,] emptyDetailLayer = new int[terrainData.detailWidth, terrainData.detailHeight];
                terrainData.SetDetailLayer(0, 0, i, emptyDetailLayer);
            }

            // Get Min/Max heights for density calculation
            float minHeight = float.MaxValue;
            float maxHeight = float.MinValue;
            int heightmapResolution = terrainData.heightmapResolution;
            for (int x = 0; x < heightmapResolution; x++) {
                for (int z = 0; z < heightmapResolution; z++) {
                    float height = terrainData.GetHeight(x, z);
                    minHeight = Mathf.Min(minHeight, height);
                    maxHeight = Mathf.Max(maxHeight, height);
                }
            }
            float heightRange = maxHeight - minHeight;
            
            // Paint details
            int detailWidth = terrainData.detailWidth;
            int detailHeight = terrainData.detailHeight;
            
            for (int layerIndex = 0; layerIndex < detailPrototypes.Length; layerIndex++) {
                int[,] detailLayer = new int[detailWidth, detailHeight];
                
                for (int y = 0; y < detailHeight; y++) {
                    for (int x = 0; x < detailWidth; x++) {
                        // Get terrain height at this position
                        float normalizedX = (float)x / (detailWidth - 1);
                        float normalizedZ = (float)y / (detailHeight - 1);
                        float terrainHeight = terrainData.GetInterpolatedHeight(normalizedX, normalizedZ);
                        
                        // Calculate density based on height
                        float heightFactor = 1f - Mathf.Clamp01((terrainHeight - minHeight) / heightRange);
                        float density = Mathf.Pow(heightFactor, densityPower) * grassDensityFactor;
                        
                        // Add randomness to density
                        density *= Random.Range(0.8f, 1.2f);
                        
                        // Set detail density (0-15)
                        detailLayer[y, x] = Mathf.RoundToInt(Mathf.Clamp01(density) * 15);
                    }
                }
                
                // Apply the detail layer
                terrainData.SetDetailLayer(0, 0, layerIndex, detailLayer);
            }
        }
    }

    private float GetTerrainHeight(Terrain terrain, float x, float z) {
        return terrain.SampleHeight(new Vector3(x, 0, z));
    }

    private Vector3 GetTerrainNormal(TerrainData terrainData, float worldX, float worldZ) {
        float normalizedX = Mathf.Clamp01(worldX / terrainData.size.x);
        float normalizedZ = Mathf.Clamp01(worldZ / terrainData.size.z);
        return terrainData.GetInterpolatedNormal(normalizedX, normalizedZ);
    }
#endif
}