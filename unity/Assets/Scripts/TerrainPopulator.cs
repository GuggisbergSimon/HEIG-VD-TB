using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;
#if UNITY_EDITOR
using UnityEditor.SceneManagement;
using System.IO;
#endif

public class TerrainPopulator : MonoBehaviour {
    [SerializeField] private int seed = 42;
    [SerializeField] private string chunksDirectory = "Assets/Scenes/Chunks";
    [SerializeField] private GameObject[] buildingPrefabs;
    [SerializeField] private GameObject[] clutterPrefabs;
    [SerializeField] private float yOffsetBuilding = 0f;
    [SerializeField] private float yOffsetClutter = 0f;
    [SerializeField] private int sampleFactor = 3;
    [SerializeField] private float clutterDensityAugment = 0.2f;
    [SerializeField] private float clutterDensityFactor = 0.1f;
    [SerializeField] private int buildingCountPerTerrain = 50;
    [SerializeField] private float densityPower = 2.5f;
    [SerializeField] private Vector2Int[] citiesCoords;
    [SerializeField] private int cityDensityFactor = 10;
    [SerializeField] private float cityBuildingScaleFactor = 4f;

    [ContextMenu("Place and Save Buildings")]
    private void PlaceBuildings() {
#if UNITY_EDITOR
        string[] sceneFiles = Directory.GetFiles(chunksDirectory, "*.unity");

        foreach (string sceneFile in sceneFiles) {
            EditorSceneManager.OpenScene(sceneFile, OpenSceneMode.Single);
            PlaceBuildingsInActiveTerrains();
            EditorSceneManager.SaveScene(SceneManager.GetActiveScene());
        }
#endif
    }

    [ContextMenu("Place Buildings")]
    private void PlaceBuildingsInActiveTerrains() {
        Random.InitState(seed);
        foreach (var terrain in Terrain.activeTerrains) {
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

            // Use a multiplier for cities to increase building density
            int densityMultiplier = isCity ? cityDensityFactor : 1;

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

                float terrainHeight = GetTerrainHeight(terrain, position.x, position.z);

                // Lower height = higher density
                float heightFactor = 1f - Mathf.Clamp01((terrainHeight - minHeight) / heightRange);

                // Density function - exponential falloff with height
                // Very dense at low heights, almost nothing at high points
                float density = Mathf.Pow(heightFactor, densityPower);

                // Increase probability for cities
                if (isCity) {
                    density = Mathf.Min(1.0f, density * 3.0f); // Further increase density chance
                }

                // Buildings placement
                if (Random.value < density) {
                    // Adjust height and rotation base on terrain
                    position.y = terrainHeight + yOffsetBuilding + terrain.transform.position.y;

                    Quaternion rotation;
                    if (isCity) {
                        // For cities, keep buildings upright (independent of terrain normal)
                        rotation = Quaternion.Euler(0, Random.Range(0, 360), 0);
                    } else {
                        // For non-city areas, align with terrain normal
                        rotation = Quaternion.FromToRotation(Vector3.up, GetTerrainNormal(terrainData,
                                       position.x - terrain.transform.position.x,
                                       position.z - terrain.transform.position.z)) *
                                   Quaternion.Euler(0, Random.Range(0, 360), 0);
                    }

                    GameObject building = buildingPrefabs[Random.Range(0, buildingPrefabs.Length)];
                    GameObject instance = Instantiate(building, position, rotation, terrain.transform);

                    if (isCity) {
                        // Calculate normalized distance from center (0 = center, 1 = edge)
                        float distanceToCenter =
                            Vector3.Distance(new Vector3(position.x, 0, position.z), terrainCenter);
                        float maxDistance = Mathf.Sqrt(terrainData.size.x * terrainData.size.x +
                                                       terrainData.size.z * terrainData.size.z) / 2;
                        float normalizedDistance = Mathf.Clamp01(distanceToCenter / maxDistance);

                        // Scale factor is higher in the center (inverse relationship with distance)
                        float centerScaleFactor = Mathf.Lerp(1.5f, 0.7f, normalizedDistance);

                        // Add randomness (±20%)
                        float randomFactor = Random.Range(0.8f, 1.2f);

                        // Apply the combined scale factors
                        instance.transform.localScale *= cityBuildingScaleFactor * centerScaleFactor * randomFactor;
                    }
                }

                // Clutter placement - also increased for cities
                float clutterDensity = clutterDensityFactor * (heightFactor + clutterDensityAugment);
                if (Random.value < clutterDensity) {
                    // Adjust height and rotation base on terrain
                    position.y = terrainHeight + yOffsetClutter + terrain.transform.position.y;
                    Quaternion rotation =
                        Quaternion.FromToRotation(Vector3.up, GetTerrainNormal(terrainData,
                            position.x - terrain.transform.position.x,
                            position.z - terrain.transform.position.z)) *
                        Quaternion.Euler(0, Random.Range(0, 360), 0);

                    GameObject clutter = clutterPrefabs[Random.Range(0, clutterPrefabs.Length)];
                    Instantiate(clutter, position, rotation, terrain.transform);
                }
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
}