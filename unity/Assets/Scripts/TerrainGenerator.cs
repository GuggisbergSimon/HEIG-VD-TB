using System;
using UnityEngine;
using Random = UnityEngine.Random;

public class TerrainGenerator : MonoBehaviour {
    [Header("Terrain")] [SerializeField] private int depth = 20;
    [SerializeField] private int size = 256;
    [SerializeField] private float scale = 20f;
    [SerializeField] private Material terrainMaterial;
    [Header("Buildings")] [SerializeField] private GameObject[] buildingPrefabs;
    [SerializeField] private float yOffset = -5f;
    [SerializeField] private int buildingCount = 100;

    private void OnValidate() {
        GenerateTerrain();
    }

    [ContextMenu("Generate Terrain")]
    private void GenerateTerrain() {
        foreach (var terrain in Terrain.activeTerrains) {
            TerrainData terrainData = terrain.terrainData;
            int HMR = size + 1;
            terrainData.heightmapResolution = HMR;
            terrainData.size = new Vector3(size, depth, size);
            float[,] heights = new float[HMR, HMR];
            for (int x = 0; x < HMR; x++) {
                for (int z = 0; z < HMR; z++) {
                    float worldPosX = (float)x / HMR * HMR + terrain.transform.position.x;
                    float worldPosZ = (float)z / HMR * HMR + terrain.transform.position.z;
                    heights[z, x] = Mathf.PerlinNoise(worldPosX * scale, worldPosZ * scale);
                }
            }

            terrainData.SetHeights(0, 0, heights);
            terrain.materialTemplate = terrainMaterial;
        }
    }

    [ContextMenu("Place Buildings")]
    private void PlaceBuildings() {
        foreach (var terrain in Terrain.activeTerrains) {
            TerrainData terrainData = terrain.terrainData;
            for (int i = terrain.transform.childCount - 1; i >= 0; i--) {
                DestroyImmediate(terrain.transform.GetChild(i).gameObject);
            }

            int posX = (int)terrain.transform.position.x;
            int posZ = (int)terrain.transform.position.z;

            for (int i = 0; i < buildingCount; i++) {
                Vector3 position = new Vector3(
                    Random.Range(posX, posX + size),
                    0,
                    Random.Range(posZ, posZ + size)
                );

                position.y = GetTerrainHeight(terrain, position.x, position.z) + yOffset;

                Quaternion rotation =
                    Quaternion.FromToRotation(Vector3.up, GetTerrainNormal(terrainData, position.x, position.z)) *
                    Quaternion.Euler(0, Random.Range(0, 360), 0);

                GameObject building = buildingPrefabs[Random.Range(0, buildingPrefabs.Length)];
                Instantiate(building, position, rotation, terrain.transform);
            }
        }
    }

    private float GetTerrainHeight(Terrain terrain, float x, float z) {
        return terrain.SampleHeight(new Vector3(x, 0, z));
    }

    private Vector3 GetTerrainNormal(TerrainData terrainData, float x, float z) {
        return terrainData.GetInterpolatedNormal(x / size, z / size);
    }
}