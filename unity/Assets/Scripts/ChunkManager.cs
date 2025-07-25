﻿/*
 * Author: Simon Guggisberg
 */

using System.Collections;
using System.Collections.Generic;
using AmplifyImpostors;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;
using UnityEngine.SceneManagement;

/*
 * Struct holding ChunkManager settings.
 */
public struct ChunkManagerSettings {
    public bool RecenterChunks;
    public int ViewDistance;
    public bool EnableLOD;
    public bool EnableImpostor;
    public bool SRPBatcher;
    public bool Juice;
    public bool IsInitialized;
}

/*
 * Class managing loading of several chunks based on the player's position.
 */
public class ChunkManager : MonoBehaviour {
    [Tooltip("Whether the chunks shall be recentered to origin of the world when moving to another chunk, or not."),
     SerializeField]
    private bool recenterChunks = true;

    [SerializeField] private bool enableLOD = true;
    [SerializeField] private bool enableImpostor = true;
    [SerializeField, Range(0f, 1f)] private float noImpostorCullingPercentage = 0.05f;
    [SerializeField] private bool srpBatcher = true;

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
    [SerializeField] private ParticleSystem speedParticles;
    [SerializeField] private CinemachineCamera playerCamera;
    [SerializeField] private VolumeProfile volumeProfile;
    
    public ParticleSystem SpeedParticles => speedParticles;

    public HovercraftController Player { get; private set; }

    public Camera Camera { get; private set; }

    private const float FogDistanceMult = 4f / 3f;
    private ChunkManagerSettings _chunkManagerSettings;
    private string[][] _sortedScenes;
    private readonly List<Vector2Int> _chunksLoaded = new List<Vector2Int>();
    private Vector2Int _playerGridPos;
    private bool[,] _viewGrid;

    public void Setup() {
        ChunkManagerSettings settings = new ChunkManagerSettings {
            RecenterChunks = recenterChunks,
            ViewDistance = viewDistance,
            EnableLOD = enableLOD,
            EnableImpostor = enableImpostor,
            SRPBatcher = srpBatcher,
            Juice = true,
        };
        Setup(settings);
    }

    public void Setup(ChunkManagerSettings chunkManagerSettings) {
        viewDistance = chunkManagerSettings.ViewDistance;
        playerCamera.Lens.FarClipPlane = chunkManagerSettings.ViewDistance * gridSize.x;
        volumeProfile.TryGet(out Fog fogSettings);
        fogSettings.maxFogDistance.value = chunkManagerSettings.ViewDistance * gridSize.x * FogDistanceMult;
        
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

        enableLOD = chunkManagerSettings.EnableLOD;
        enableImpostor = chunkManagerSettings.EnableImpostor;
        GraphicsSettings.useScriptableRenderPipelineBatching = chunkManagerSettings.SRPBatcher;
        SpeedParticles.gameObject.SetActive(chunkManagerSettings.Juice);
        recenterChunks = chunkManagerSettings.RecenterChunks;
        _chunkManagerSettings = chunkManagerSettings;
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
        Player.ToggleJuice(_chunkManagerSettings.Juice);
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

    private void DisableImpostor(Chunk chunk) {
        foreach (AmplifyImpostor impostor in chunk.Impostors) {
            if (impostor == null) {
                continue;
            }
            LODGroup lodGroup = impostor.gameObject.GetComponent<LODGroup>();
            Destroy(impostor);
            LOD[] lods = lodGroup.GetLODs();
            if (lods.Length > 1) {
                LOD[] newLods = new LOD[lods.Length - 1];
                System.Array.Copy(lods, newLods, lods.Length - 1);

                if (newLods.Length > 0) {
                    newLods[^1].screenRelativeTransitionHeight = noImpostorCullingPercentage;
                }

                lodGroup.SetLODs(newLods);

                // If impostor was picked, refresh it
                bool wasAtLastLevel = lods[^1].renderers[0].enabled;
                if (wasAtLastLevel) {
                    foreach (var lodRenderer in lods[^1].renderers) {
                        lodRenderer.enabled = false;
                    }
                    lodGroup.ForceLOD(-1);
                }
            }
        }
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
                            Chunk chunk = terrainObj.GetComponent<Chunk>();
                            // Objects/Props
                            if (!enableImpostor) {
                                DisableImpostor(chunk);
                            }

                            foreach (LODGroup lodGroup in chunk.LodGroups) {
                                lodGroup.ForceLOD(0);
                            }

                            // Terrains
                            Terrain terrain = chunk.Terrain;
                            terrain.heightmapPixelError = 1;
                            terrain.detailObjectDistance *= 2;
                        } else if (!enableImpostor) {
                            DisableImpostor(terrainObj.GetComponent<Chunk>());
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