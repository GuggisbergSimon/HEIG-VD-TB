using UnityEngine;
using UnityEngine.SceneManagement;

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

    private bool _isLoading = false;
    private bool _isPaused = false;

    public static void ToggleCursor(bool isUIMode) {
        Cursor.lockState = isUIMode ? CursorLockMode.None : CursorLockMode.Locked;
        Cursor.visible = isUIMode;
    }

    public void LoadScene(int number) {
        ToggleLoadingPanel();
        ToggleMenu();
        SceneManager.UnloadSceneAsync(menuSceneName);
        AsyncOperation operation = SceneManager.LoadSceneAsync(compositingSceneName + " " + number);
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