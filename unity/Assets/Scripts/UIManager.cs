using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class UIManager : MonoBehaviour {
    [Tooltip("The name of the scene to load as a main menu. Must be included in the build settings."), SerializeField]
    private string menuSceneName = "MainMenu";

    [Tooltip("The name of scenes to load as compositing scenes. The expected format is 'name n'"), SerializeField]
    private string compositingSceneName = "Compositing";

    [Tooltip("The panel containing the pause menu"), SerializeField]
    private GameObject pausePanel;

    [Tooltip("The panel containing the main menu"), SerializeField]
    private GameObject menuPanel;

    [Tooltip("The panel containing the loading screen"), SerializeField]
    private GameObject loadingPanel;
    
    [SerializeField] private Toggle loadingChunkToggle;
    [SerializeField] private Toggle recenterWorldToggle;
    [SerializeField] private Toggle lodToggle;
    [SerializeField] private Toggle impostorToggle;
    [SerializeField] private Toggle srpBatcherToggle;

    private bool _isLoading = false;
    private bool _isPaused = false;

    public static void ToggleCursor(bool isUIMode) {
        Cursor.lockState = isUIMode ? CursorLockMode.None : CursorLockMode.Locked;
        Cursor.visible = isUIMode;
    }

    public void LoadScene() {
        ToggleLoadingPanel();
        ToggleMenu();
        GameSettings gameSettings = new GameSettings {
            RecenterChunks = recenterWorldToggle.isOn,
            LoadingChunks = loadingChunkToggle.isOn,
            EnableLOD = lodToggle.isOn, 
            EnableImpostor = lodToggle.isOn && impostorToggle.isOn,
            SRPBatcher = srpBatcherToggle.isOn,
        };
        GameManager.Instance.LoadSettings(gameSettings);
        AsyncOperation operation = SceneManager.LoadSceneAsync(compositingSceneName);
        SceneManager.UnloadSceneAsync(menuSceneName);
        if (operation != null) {
            operation.completed += _ => { ToggleLoadingPanel(); };
        }
    }

    public void ClosePauseAndLoadMenu() {
        TogglePause();
        LoadMenu();
    }

    public void LoadMenu() {
        ToggleLoadingPanel();
        ToggleMenu();
        AsyncOperation operation = SceneManager.LoadSceneAsync(menuSceneName);
        if (operation != null) {
            operation.completed += _ => { ToggleLoadingPanel(); };
        }
    }

    public void TogglePause() {
        if (_isLoading) {
            return;
        }
        _isPaused = !_isPaused;
        ToggleCursor(_isPaused);
        pausePanel.SetActive(_isPaused);
        Time.timeScale = _isPaused ? 0 : 1;
    }

    private void ToggleMenu() {
        ToggleCursor(true);
        menuPanel.SetActive(!menuPanel.activeSelf);
    }

    public void ToggleLoadingPanel() {
        _isLoading = !_isLoading;
        loadingPanel.SetActive(_isLoading);
        Time.timeScale = _isLoading ? 0 : 1;
    }

    public void Quit() {
        GameManager.Instance.QuitGame();
    }
}