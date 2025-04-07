using UnityEngine;

public class TerrainPopulator : MonoBehaviour {
    [SerializeField] private GameObject[] buildingPrefabs;
    [SerializeField] private float yOffset = -5f;
    [SerializeField] private int buildingCount = 100;
    
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
                    Random.Range(posX, posX + terrain.terrainData.size.x),
                    0,
                    Random.Range(posZ, posZ + terrain.terrainData.size.z)
                );

                position.y = GetTerrainHeight(terrain, position.x, position.z) + yOffset + terrain.transform.position.y;

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
        return terrainData.GetInterpolatedNormal(x / terrainData.size.x, z / terrainData.size.z);
    }
}   
