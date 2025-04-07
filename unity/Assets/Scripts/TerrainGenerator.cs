using System;
using UnityEngine;
using Random = UnityEngine.Random;

public class TerrainGenerator : MonoBehaviour {
    [SerializeField] private int depth = 20;
    [SerializeField] private int size = 256;
    [SerializeField] private float scale = 20f;
    [SerializeField] private Material terrainMaterial;

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
}