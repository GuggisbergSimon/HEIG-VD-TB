using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {
    public static GameManager Instance;

    public GameObject Player;
    public ChunkManager ChunkManager;

    private void Awake() {
        if (Instance == null) {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else {
            Destroy(gameObject);
            return;
        }

        Player = GameObject.FindGameObjectWithTag("Player");
        if (Player == null) {
            Debug.LogError("No player found with tag 'Player'");
            return;
        }

        ChunkManager = GetComponent<ChunkManager>();
    }

    public void QuitGame() {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
}