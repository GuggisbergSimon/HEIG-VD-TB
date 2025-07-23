/*
 * Author: Simon Guggisberg
 */

using UnityEngine;
using UnityEngine.InputSystem;

/*
 * Class handling pause action input.
 */
[RequireComponent(typeof(PlayerInput))]
public class PauseActionInteractor : MonoBehaviour
{
    private void OnMenu() {
        GameManager.Instance.UIManager.TogglePause();
    }
}
