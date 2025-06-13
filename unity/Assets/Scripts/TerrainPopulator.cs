using UnityEngine;
#if UNITY_EDITOR
using UnityEditor.SceneManagement;
using System.IO;
#endif

public class TerrainPopulator : MonoBehaviour {
    [SerializeField] private int seed = 42;
    [SerializeField] private string chunksDirectory = "Assets/Scenes/Chunks";
    [SerializeField] private GameObject[] buildingPrefabs;
    [SerializeField] private float yOffset = -5f;
    [SerializeField] private int buildingCountPerTerrain = 50;
    [SerializeField] private int clusterCount = 5;
    [SerializeField] private float clusterSize = 50;

    [ContextMenu("Place and Save Buildings")]
    private void PlaceBuildings() {
#if UNITY_EDITOR
        string[] sceneFiles = Directory.GetFiles(chunksDirectory, "*.unity");

        foreach (string sceneFile in sceneFiles) {
            EditorSceneManager.OpenScene(sceneFile, OpenSceneMode.Single);
            PlaceBuildingsInActiveTerrains();
            EditorSceneManager.SaveScene(EditorSceneManager.GetActiveScene());
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

            for (int c = 0; c < clusterCount; c++) {
                Vector3 clusterCenter = FindFlatArea(terrain, terrainData, posX, posZ);
                int buildingsInCluster = buildingCountPerTerrain / clusterCount;

                for (int i = 0; i < buildingsInCluster; i++) {
                    Vector2 offset = Random.insideUnitCircle * clusterSize;

                    Vector3 position = new Vector3(
                        clusterCenter.x + offset.x,
                        0,
                        clusterCenter.z + offset.y
                    );

                    position.y = GetTerrainHeight(terrain, position.x, position.z) + yOffset +
                                 terrain.transform.position.y;

                    Quaternion rotation =
                        Quaternion.FromToRotation(Vector3.up, GetTerrainNormal(terrainData,
                            position.x - terrain.transform.position.x,
                            position.z - terrain.transform.position.z)) *
                        Quaternion.Euler(0, Random.Range(0, 360), 0);

                    GameObject building = buildingPrefabs[Random.Range(0, buildingPrefabs.Length)];
                    Instantiate(building, position, rotation, terrain.transform);
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

    private Vector3 FindFlatArea(Terrain terrain, TerrainData terrainData, int posX, int posZ) {
        // We'll sample multiple positions and choose the flattest one
        const int maxAttempts = 30;
        const float flatnessThreshold = 0.95f; // Dot product with Vector3.up (1.0 = perfectly flat)

        Vector3 bestPosition = Vector3.zero;
        float bestFlatness = 0f;

        for (int i = 0; i < maxAttempts; i++) {
            Vector3 testPosition = new Vector3(
                Random.Range(posX, posX + terrainData.size.x),
                0,
                Random.Range(posZ, posZ + terrainData.size.z)
            );

            Vector3 normal = GetTerrainNormal(terrainData,
                testPosition.x - terrain.transform.position.x,
                testPosition.z - terrain.transform.position.z);

            float flatness = Vector3.Dot(normal, Vector3.up);

            if (flatness > bestFlatness) {
                bestFlatness = flatness;
                bestPosition = testPosition;

                // If we found an area flat enough, use it immediately
                if (flatness >= flatnessThreshold) {
                    break;
                }
            }
        }

        return bestPosition;
    }
}