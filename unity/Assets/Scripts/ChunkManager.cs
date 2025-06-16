using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ChunkManager : MonoBehaviour {
    [SerializeField] private TerrainScriptableObject[] scenes;
    [SerializeField] private Vector2 gridSize = Vector2.one * 500f;
    [SerializeField] private Vector2Int gridOffset = Vector2Int.one * 8;
    [SerializeField, Min(1)] private int viewDistance = 3;
    [SerializeField] private float yOffset = 0f;
    
    public Player Player { get; set; }
    
    private string[][] _sortedScenes;
    private List<Vector2Int> _chunksLoaded = new List<Vector2Int>();
    private Vector2Int _playerGridPos;
    private bool[,] _chunksToLoad; 

    private void Start() {
        // ChunksToLoad
        _chunksToLoad = new bool[viewDistance * 2 + 1, viewDistance * 2 + 1];
        for (int x = -viewDistance; x <= viewDistance; x++) {
            for (int y = -viewDistance; y <= viewDistance; y++) {
                if (x * x + y * y <= viewDistance * viewDistance) {
                    _chunksToLoad[x + viewDistance, y + viewDistance] = true;
                }
            }
        }
        
        // SortedScenes
        int length = (int)Mathf.Sqrt(scenes.Length);
        _sortedScenes = new string[length][];
        for (int i = 0; i < length; i++) {
            _sortedScenes[i] = new string[length];
        }

        foreach (var scene in scenes) {
            if (scene.coords.x < 0 || scene.coords.x >= length ||
                scene.coords.y < 0 || scene.coords.y >= length) {
                Debug.LogError($"Scene {scene.sceneName} has invalid coordinates: {scene.coords}");
                continue;
            }

            _sortedScenes[scene.coords.x][scene.coords.y] = scene.sceneName;
        }
        
        // Player and Chunks
        Player = GameObject.FindWithTag("Player").GetComponent<Player>();
        _playerGridPos = GetGridPosition(Player.transform.position);
        UpdateLoadedChunks();
    }
    
    private void Update() {
        Vector3 playerPos = Player.transform.position;
        Vector2Int currentGridPos = GetGridPosition(playerPos);
        if (currentGridPos != gridOffset) {
            Debug.Log($"Player moved from chunk {_playerGridPos} to {currentGridPos}");
            Vector2Int diff = currentGridPos - gridOffset;
            Vector3 worldOffset = new Vector3(diff.x * gridSize.x, 0, diff.y * gridSize.y);

            // Reposition all loaded chunks
            foreach (var coords in _chunksLoaded) {
                Scene loadedScene = SceneManager.GetSceneByName(_sortedScenes[coords.x][coords.y]);
                foreach (GameObject rootObj in loadedScene.GetRootGameObjects()) {
                    rootObj.transform.position -= worldOffset;
                }
            }
            
            // Move player
            playerPos -= worldOffset;
            Player.transform.position = playerPos;

            _playerGridPos += diff;
            UpdateLoadedChunks();
        }
    }
    
    private Vector2Int GetGridPosition(Vector3 worldPosition) {
        return new Vector2Int(
            Mathf.FloorToInt(worldPosition.x / gridSize.x + gridOffset.x),
            Mathf.FloorToInt(worldPosition.z / gridSize.y + gridOffset.y)
        );
    }

    private void UpdateLoadedChunks() {
        List<Vector2Int> chunksToUnload = new List<Vector2Int>();

        // Find chunks outside of ChunksToLoad
        foreach (var coords in _chunksLoaded) {
            int relX = coords.x - _playerGridPos.x;
            int relY = coords.y - _playerGridPos.y;
    
            // Skip if within view distance and in the chunksToLoad pattern
            if (Mathf.Abs(relX) <= viewDistance && Mathf.Abs(relY) <= viewDistance && 
                _chunksToLoad[relX + viewDistance, relY + viewDistance]) {
                continue;
            }
    
            chunksToUnload.Add(coords);
        }

        // Unload chunks outside of ChunksToLoad
        foreach (var coords in chunksToUnload) {
            SceneManager.UnloadSceneAsync(_sortedScenes[coords.x][coords.y]);
            _chunksLoaded.Remove(coords);
        }

        // Load new chunks based on the chunksToLoad pattern
        int gridLength = _sortedScenes.Length;
        for (int x = -viewDistance; x <= viewDistance; x++) {
            int xCoord = _playerGridPos.x + x;
            if (xCoord < 0 || xCoord >= gridLength) {
                continue;
            }

            for (int y = -viewDistance; y <= viewDistance; y++) {
                int arrayX = x + viewDistance;
                int arrayY = y + viewDistance;

                // Pre emptive skips
                if (!_chunksToLoad[arrayX, arrayY]) {
                    continue;
                }
                int yCoord = _playerGridPos.y + y;
                if (yCoord < 0 || yCoord >= gridLength) {
                    continue;
                }
                Vector2Int coords = new Vector2Int(xCoord, yCoord);
                if (_chunksLoaded.Contains(coords)) {
                    continue;
                }

                if (string.IsNullOrEmpty(_sortedScenes[xCoord][yCoord])) {
                    Debug.LogWarning($"No scene defined for coordinates {coords}");
                    continue;
                }

                _chunksLoaded.Add(coords);

                Vector3 chunkPosition = new Vector3(
                    (coords.x - _playerGridPos.x) * gridSize.x,
                    yOffset,
                    (coords.y - _playerGridPos.y) * gridSize.y
                );

                AsyncOperation loadOperation =
                    SceneManager.LoadSceneAsync(_sortedScenes[xCoord][yCoord], LoadSceneMode.Additive);
                loadOperation.completed += operation => {
                    Scene loadedScene = SceneManager.GetSceneByName(_sortedScenes[xCoord][yCoord]);
                    foreach (GameObject rootObj in loadedScene.GetRootGameObjects()) {
                        rootObj.transform.position = chunkPosition;
                    }
                };
            }
        }
    }
}