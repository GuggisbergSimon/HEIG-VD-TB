using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ChunkManager : MonoBehaviour {
    [Tooltip("Whether the chunks shall be recentered to origin of the world when moving to another chunk, or not."),
     SerializeField]
    private bool recenterChunks = true;

    [SerializeField] private bool enableLOD = true;

    [Tooltip("Unsorted list of scenes to load as chunks. The expected format is Terrain_x_y_id.unity"), SerializeField]
    private TerrainScriptableObject[] scenes;

    [Tooltip("Dimensions of one chunk"), SerializeField]
    private Vector2 gridSize = Vector2.one * 500f;

    [Tooltip("Grid offset for original instantiation of the player. Must be positive values."), SerializeField]
    private Vector2Int gridOffset = Vector2Int.one * 8;

    [Tooltip("It represents the radius of a circular pattern centered on the player's chunk. " +
             "A distance of 1 means only the chunk where the player is will be loaded. "), SerializeField, Min(1)]
    private int viewDistance = 3;

    [Tooltip("Offset to load chunks at proper height."), SerializeField]
    private float yOffset = 0f;

    public HovercraftController Player { get; private set; }

    public Camera Camera { get; private set; }

    private string[][] _sortedScenes;
    private readonly List<Vector2Int> _chunksLoaded = new List<Vector2Int>();
    private Vector2Int _playerGridPos;
    private bool[,] _viewGrid;

    public void Setup() {
        GameSettings settings = new GameSettings {
            RecenterChunks = recenterChunks,
            LoadingChunks = true,
            EnableLOD = enableLOD
        };
        Setup(settings);
    }

    public void Setup(GameSettings gameSettings) {
        if (!gameSettings.LoadingChunks) {
            viewDistance = 50;
        }
        // ChunksToLoad, circular pattern with viewDistance as radius
        _viewGrid = new bool[viewDistance * 2 + 1, viewDistance * 2 + 1];
        for (int x = -viewDistance; x <= viewDistance; x++) {
            for (int y = -viewDistance; y <= viewDistance; y++) {
                if (x * x + y * y <= viewDistance * viewDistance) {
                    _viewGrid[x + viewDistance, y + viewDistance] = true;
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

        enableLOD = gameSettings.EnableLOD;
        recenterChunks = gameSettings.RecenterChunks;
        StartCoroutine(LoadInitialChunk());
    }

    private void OnDestroy() {
        //Unload all scenes
        foreach (var coords in _chunksLoaded) {
            SceneManager.UnloadSceneAsync(_sortedScenes[coords.x][coords.y]);
        }
    }

    private IEnumerator LoadInitialChunk() {
        Player = GameObject.FindWithTag("Player").GetComponent<HovercraftController>();
        Camera = GameObject.FindWithTag("MainCamera").GetComponent<Camera>();
        _playerGridPos = GetGridPosition(Player.transform.position);
        GameManager.Instance.UIManager.ToggleLoadingPanel();
        yield return LoadChunks(FindChunksToLoad());
        GameManager.Instance.UIManager.ToggleLoadingPanel();
    }

    private void FixedUpdate() {
        Vector3 playerPos = Player.transform.position;
        Vector2Int currentGridPos = GetGridPosition(playerPos);
        if (recenterChunks && currentGridPos != gridOffset) {
            Vector2Int diff = currentGridPos - gridOffset;
            Vector3 worldOffset = new Vector3(diff.x * gridSize.x, 0, diff.y * gridSize.y);

            // Reposition all loaded chunks
            foreach (var coords in _chunksLoaded) {
                Scene loadedScene = SceneManager.GetSceneByName(_sortedScenes[coords.x][coords.y]);
                foreach (var rootObj in loadedScene.GetRootGameObjects()) {
                    rootObj.transform.position -= worldOffset;
                }
            }

            // Move player
            playerPos -= worldOffset;
            Player.MoveToPosition(playerPos);
            _playerGridPos += diff;
            UpdateLoadedChunks();
        } else if (!recenterChunks && currentGridPos != _playerGridPos) {
            _playerGridPos = currentGridPos;
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
        UnloadNonRequiredChunks();
        StartCoroutine(LoadChunks(FindChunksToLoad()));
    }

    private List<Vector2Int> FindChunksToUnload() {
        List<Vector2Int> chunksToUnload = new List<Vector2Int>();
        foreach (var coords in _chunksLoaded) {
            int relX = coords.x - _playerGridPos.x;
            int relY = coords.y - _playerGridPos.y;

            // Skip if within view distance and in the chunksToLoad pattern
            if (Mathf.Abs(relX) <= viewDistance && Mathf.Abs(relY) <= viewDistance &&
                _viewGrid[relX + viewDistance, relY + viewDistance]) {
                continue;
            }

            chunksToUnload.Add(coords);
        }

        return chunksToUnload;
    }

    private void UnloadNonRequiredChunks() {
        List<Vector2Int> chunksToUnload = FindChunksToUnload();
        
        // Unload chunks outside ChunksToLoad
        foreach (var coords in chunksToUnload) {
            AsyncOperation unloadOperation =
                SceneManager.UnloadSceneAsync(_sortedScenes[coords.x][coords.y]);
            if (unloadOperation != null) {
                unloadOperation.completed += _ => { _chunksLoaded.Remove(coords); };
            }
        }
    }

    private List<Vector2Int> FindChunksToLoad() {
        int gridLength = _sortedScenes.Length;
        List<Vector2Int> chunksToLoad = new List<Vector2Int>();

        for (int x = -viewDistance; x <= viewDistance; x++) {
            int xCoord = _playerGridPos.x + x;
            if (xCoord < 0 || xCoord >= gridLength) {
                continue;
            }

            for (int y = -viewDistance; y <= viewDistance; y++) {
                int arrayX = x + viewDistance;
                int arrayY = y + viewDistance;

                // Pre emptive skips
                if (!_viewGrid[arrayX, arrayY]) {
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
                    //Debug.LogWarning($"No scene defined for coordinates {coords}");
                    continue;
                }

                chunksToLoad.Add(coords);
            }
        }

        return chunksToLoad;
    }

    private IEnumerator LoadChunks(List<Vector2Int> chunksToLoad) {
        List<AsyncOperation> loadOperations = new List<AsyncOperation>();

        foreach (var coords in chunksToLoad) {
            AsyncOperation loadOperation =
                SceneManager.LoadSceneAsync(_sortedScenes[coords.x][coords.y], LoadSceneMode.Additive);
            if (loadOperation != null) {
                loadOperation.completed += _ => {
                    Scene loadedScene = SceneManager.GetSceneByName(_sortedScenes[coords.x][coords.y]);
                    Vector3 chunkPosition = new Vector3(
                        (coords.x - (recenterChunks ? _playerGridPos.x : gridOffset.x)) * gridSize.x,
                        yOffset,
                        (coords.y - (recenterChunks ? _playerGridPos.y : gridOffset.y)) * gridSize.y
                    );
                    foreach (var terrainObj in loadedScene.GetRootGameObjects()) {
                        terrainObj.transform.position = chunkPosition;

                        if (!enableLOD) {
                            // Objects/Props
                            foreach (LODGroup lodGroup in terrainObj.GetComponentsInChildren<LODGroup>(true)) {
                                lodGroup.ForceLOD(0);
                            }

                            // Terrains
                            Terrain terrain = terrainObj.GetComponent<Terrain>();
                            terrain.heightmapPixelError = 1;
                            terrain.detailObjectDistance *= 2;
                        }
                    }

                    _chunksLoaded.Add(coords);
                };
                loadOperations.Add(loadOperation);
            }
        }

        foreach (var operation in loadOperations) {
            yield return operation;
        }
    }
}