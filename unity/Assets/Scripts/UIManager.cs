using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class UIManager : MonoBehaviour {
    [Tooltip("The name of the scene to load as a main menu. Must be included in the build settings."), SerializeField]
    private string menuSceneName = "MainMenu";

    [Tooltip("The name of the compositing scene"), SerializeField]
    private string compositingSceneName = "Compositing";

    [Tooltip("The name of the demo scene"), SerializeField]
    private string demoSceneName = "Demo";

    [Tooltip("The panel containing the pause menu"), SerializeField]
    private GameObject pausePanel;

    [Tooltip("The panel containing the main menu"), SerializeField]
    private GameObject menuPanel;

    [Tooltip("The panel containing the loading screen"), SerializeField]
    private GameObject loadingPanel;

    [SerializeField] private Slider viewDistanceSlider;
    [SerializeField] private TextMeshProUGUI viewDistanceText;
    [SerializeField] private Toggle recenterWorldToggle;
    [SerializeField] private Toggle lodToggle;
    [SerializeField] private Toggle impostorToggle;
    [SerializeField] private Toggle srpBatcherToggle;
    [SerializeField] private Toggle juiceToggle;

    private bool _isLoading = false;
    private bool _isPaused = false;

    public void UpdateViewDistanceText() {
        viewDistanceText.text = $"{viewDistanceSlider.value}";
    }

    public static void ToggleCursor(bool isUIMode) {
        Cursor.lockState = isUIMode ? CursorLockMode.None : CursorLockMode.Locked;
        Cursor.visible = isUIMode;
    }

    public void LoadScene() {
        ToggleLoadingPanel();
        ToggleMenu();
        ChunkManagerSettings chunkManagerSettings = new ChunkManagerSettings {
            RecenterChunks = recenterWorldToggle.isOn,
            ViewDistance = (int)viewDistanceSlider.value,
            EnableLOD = lodToggle.isOn,
            EnableImpostor = lodToggle.isOn && impostorToggle.isOn,
            SRPBatcher = srpBatcherToggle.isOn,
            Juice = juiceToggle.isOn
        };
        GameManager.Instance.LoadSettings(chunkManagerSettings);
        AsyncOperation operation = SceneManager.LoadSceneAsync(compositingSceneName);
        SceneManager.UnloadSceneAsync(menuSceneName);
        if (operation != null) {
            operation.completed += _ => { ToggleLoadingPanel(); };
        }
    }

    public void LoadDemo() {
        ToggleLoadingPanel();
        ToggleMenu();
        AsyncOperation operation = SceneManager.LoadSceneAsync(demoSceneName);
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
        UpdateViewDistanceText();
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