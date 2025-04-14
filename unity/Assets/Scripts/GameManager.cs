using System.Collections.Generic;
using System.Linq;
using Unity.Mathematics.Geometry;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;

public class GameManager : MonoBehaviour {
    [SerializeField] private TerrainScriptableObject[] scenes;
    [SerializeField] private Vector2 gridSize = Vector2.one * 500f;
    [SerializeField] private Vector2 gridOffset = Vector2.one * -4000f;

    public static GameManager Instance;

    public GameObject Player;

    private string[][] _sortedScenes;
    private List<Vector2Int> _chunksLoaded = new List<Vector2Int>();
    private Vector2Int _playerGridPos;

    private void Awake() {
        if (Instance == null) {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else {
            Destroy(gameObject);
        }

        Player = GameObject.FindGameObjectWithTag("Player");

        int length = (int)Mathf.Sqrt(scenes.Length);
        _sortedScenes = new string[length][];
        for (int i = 0; i < length; i++) {
            _sortedScenes[i] = new string[length];
        }

        foreach (var scene in scenes) {
            _sortedScenes[scene.coords.x][scene.coords.y] = scene.sceneName;
        }
    }

    private void Update() {
        Vector2Int gridPos = new Vector2Int(
            (int)Mathf.Floor((Player.transform.position.x - gridOffset.x) / gridSize.x),
            (int)Mathf.Floor((Player.transform.position.z - gridOffset.y) / gridSize.y)
        );

        if (_playerGridPos == gridPos) {
            return;
        }
        
        _playerGridPos = gridPos;

        //First unload what is out of the 3x3
        foreach (var coords in _chunksLoaded) {
            if (coords.x >= gridPos.x - 1 && coords.x <= gridPos.x + 1 &&
                coords.y >= gridPos.y - 1 && coords.y <= gridPos.y + 1) {
                continue;
            }

            SceneManager.UnloadSceneAsync(_sortedScenes[coords.x][coords.y]);
            _chunksLoaded = _chunksLoaded.Where(c => c != coords).ToList();
        }

        //Then load what's new in the 3x3
        Debug.Log(_playerGridPos);
        for (int x = -1; x <= 1; x++) {
            int xCoord = gridPos.x + x;
            if (xCoord < 0 || xCoord >= scenes.Length) {
                continue;
            }

            for (int y = -1; y <= 1; y++) {
                int yCoord = gridPos.y + y;
                if (yCoord < 0 || yCoord >= scenes.Length) {
                    continue;
                }

                Vector2Int coords = new Vector2Int(xCoord, yCoord);
                if (_chunksLoaded.Contains(coords)) {
                    continue;
                }
                
                SceneManager.LoadSceneAsync(_sortedScenes[xCoord][yCoord], LoadSceneMode.Additive);
                _chunksLoaded = _chunksLoaded.Append(coords).ToList();
            }
        }
    }

    private void OnMenu() {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
}