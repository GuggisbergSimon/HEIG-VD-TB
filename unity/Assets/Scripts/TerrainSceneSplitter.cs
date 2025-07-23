/*
 * Author: Simon Guggisberg
 */

using UnityEngine;
#if UNITY_EDITOR
using UnityEditor.SceneManagement;
#endif
using System.IO;
using UnityEditor;

/*
 * Class splitting terrains into separate scenes from the Editor.
 */
public class TerrainSceneSplitter : MonoBehaviour {
#if UNITY_EDITOR
    [ContextMenu("Split Terrains Into Scenes")]
    private void SplitTerrainsIntoScenes() {
        Transform[] children = new Transform[transform.childCount];
        for (int i = 0; i < transform.childCount; i++) {
            children[i] = transform.GetChild(i);
        }

        foreach (Transform child in children) {
            if (child.GetComponent<Terrain>() != null) {
                CreateSceneForTerrain(child.gameObject);
                GenerateObjectsFromScenes(child.gameObject);
            }
        }
    }

    private void GenerateObjectsFromScenes(GameObject terrainObject) {
        TerrainScriptableObject terrainSO = ScriptableObject.CreateInstance<TerrainScriptableObject>();
        terrainSO.sceneName = terrainObject.name;
        terrainSO.coords = new Vector2Int(
            int.Parse(terrainObject.name.Split('_')[1]),
            int.Parse(terrainObject.name.Split('_')[2])
        );
        string scriptableObjectsPath = "Assets/Scenes/ScriptableObjects/";
        Directory.CreateDirectory(Path.GetDirectoryName(scriptableObjectsPath) ?? "Assets/Scenes/ScriptableObjects");
        AssetDatabase.CreateAsset(terrainSO, scriptableObjectsPath + terrainObject.name + ".asset");
    }

    private void CreateSceneForTerrain(GameObject terrainObject) {
        string sceneName = terrainObject.name;
        string scenePath = "Assets/Scenes/Chunks/" + sceneName + ".unity";
        Directory.CreateDirectory(Path.GetDirectoryName(scenePath) ?? "Assets/Scenes/Chunks");
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Additive);
        scene.name = sceneName;

        Vector3 worldPosition = terrainObject.transform.position;
        Quaternion worldRotation = terrainObject.transform.rotation;
        Vector3 worldScale = terrainObject.transform.lossyScale;

        GameObject newTerrain = Instantiate(terrainObject);
        newTerrain.name = terrainObject.name;

        newTerrain.transform.position = worldPosition;
        newTerrain.transform.rotation = worldRotation;
        newTerrain.transform.localScale = worldScale;

        EditorSceneManager.SaveScene(scene, scenePath);
    }
#endif
}