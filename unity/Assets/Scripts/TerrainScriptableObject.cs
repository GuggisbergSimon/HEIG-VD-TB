using UnityEditor;
using UnityEngine;

[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/TerrainScriptableObject")]
public class TerrainScriptableObject : ScriptableObject {
    public string sceneName;
    public Vector2Int coords;
}
