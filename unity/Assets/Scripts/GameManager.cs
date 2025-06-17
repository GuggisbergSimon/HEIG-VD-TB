using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {
    [SerializeField] private string firstSceneName = "MainMenu";
    [SerializeField] private bool startsWithMenu = true;
    [SerializeField] private UIManager uIManager;
    public static GameManager Instance;

    public ChunkManager ChunkManager { get; private set; }

    public UIManager UIManager => uIManager;

    private void Awake() {
        if (Instance == null) {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else {
            Destroy(gameObject);
            return;
        }

        FindChunkManager();
        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void Start() {
        UIManager.ToggleLoadingPanel();
        if (startsWithMenu) {
            UIManager.ToggleMenu();
        }
        AsyncOperation operation = SceneManager.LoadSceneAsync(firstSceneName);
        if (operation != null) {
            operation.completed += _ => { UIManager.ToggleLoadingPanel(); };
        }
    }

    private void OnDestroy() {
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode) {
        FindChunkManager();
    }

    private void FindChunkManager() {
        ChunkManager chunkManager = GameObject.Find("ChunkManager")?.GetComponent<ChunkManager>();
        if (chunkManager != null) {
            ChunkManager = chunkManager;
        }
    }

    public void QuitGame() {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
}