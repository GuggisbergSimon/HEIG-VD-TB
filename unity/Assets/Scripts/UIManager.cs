using UnityEngine;

public class UIManager : MonoBehaviour
{
    [SerializeField] private GameObject pausePanel;
    [SerializeField] private GameObject ftbPanel;

    private bool _isPaused = false;
    
    public void TogglePause()
    {
        _isPaused = !_isPaused;
        pausePanel.SetActive(_isPaused);
        Time.timeScale = _isPaused ? 0 : 1;
    }
    
    public void Quit() {
        GameManager.Instance.QuitGame();
    }
}