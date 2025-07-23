/*
 * Author: Simon Guggisberg
 */

using UnityEngine;

/*
 * ScriptableObject class to hold terrain data.
 */
[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/TerrainScriptableObject")]
public class TerrainScriptableObject : ScriptableObject {
    public string sceneName;
    public Vector2Int coords;
}