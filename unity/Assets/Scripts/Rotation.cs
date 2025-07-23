/*
 * Author: Simon Guggisberg
 */

using UnityEngine;

/*
 * Class rotating the GameObject it is attached to.
 */
public class Rotation : MonoBehaviour {
    [SerializeField] private Vector3 rotationSpeed = new Vector3(0f, 0f, 50f);
    [SerializeField] private bool isTimeScaleIndependent = false;

    void Update() {
        transform.Rotate(rotationSpeed * (isTimeScaleIndependent ? Time.unscaledDeltaTime : Time.deltaTime),
            Space.Self);
    }
}