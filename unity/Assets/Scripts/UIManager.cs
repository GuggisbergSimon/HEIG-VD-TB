using UnityEngine;
using UnityEngine.SceneManagement;

public class UIManager : MonoBehaviour {
    [SerializeField] private string menuSceneName = "MainMenu";
    [SerializeField] private GameObject pausePanel;
    [SerializeField] private GameObject menuPanel;
    [SerializeField] private GameObject loadingPanel;

    private bool _isLoading = false;
    private bool _isPaused = false;

    public void LoadGame(int number) {
        ToggleLoadingPanel();
        ToggleMenu();
        SceneManager.UnloadSceneAsync("MainMenu");
        AsyncOperation operation = SceneManager.LoadSceneAsync("Compositing " + number);
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
        //TODO unload all loaded scenes
        Debug.Log(SceneManager.GetActiveScene().name);
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
        pausePanel.SetActive(_isPaused);
        Time.timeScale = _isPaused ? 0 : 1;
    }

    public void ToggleMenu() {
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