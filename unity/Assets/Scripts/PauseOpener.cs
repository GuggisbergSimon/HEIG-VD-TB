using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(PlayerInput))]
public class PauseOpener : MonoBehaviour
{
    private void OnMenu() {
        GameManager.Instance.UIManager.TogglePause();
    }
}
