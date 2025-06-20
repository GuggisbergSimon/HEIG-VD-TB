using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {
    [Tooltip("The UI Manager located as a child of the Game Manager."), SerializeField] private UIManager uIManager;
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

        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void Start() {
        if (ChunkManager == null) {
            UIManager.LoadMenu();
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
            UIManager.ToggleCursor(false);
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