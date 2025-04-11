using UnityEditor;
using UnityEngine;

[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/TerrainScriptableObject")]
public class TerrainScriptableObject : ScriptableObject {
    public SceneAsset scene;
    public Vector2Int coords;
}
