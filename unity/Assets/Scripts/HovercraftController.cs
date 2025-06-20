using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class HovercraftController : MonoBehaviour {
    [Tooltip("The location of the springs located around the hovercraft to push back when meeting ground."),
     SerializeField]
    private List<GameObject> springs;

    [Tooltip("The location of the propulsion engine to push forward."), SerializeField]
    private GameObject propulsion;

    [Tooltip("The location of the center of mass of the engine to replace the Rigidbody one."), SerializeField]
    private GameObject centerOfMass;

    [Tooltip("A multiplier applied to the propulsion force."), SerializeField]
    private float propulsionForceMultiplier = 400f;

    [Tooltip("A multiplier applied to the torque force."), SerializeField]
    private float torqueForceMultiplier = 300f;

    [Tooltip("A multiplier applied to the spring force applied on each spring."), SerializeField] private float springForceMultiplier = 250f;
    [Tooltip("A multiplier applied to the damping force to reduce oscillation."), SerializeField] private float dampingForceMultiplier = 5f;

    private Rigidbody _rb;
    private InputAction _moveAction;

    private void Start() {
        _rb = GetComponent<Rigidbody>();
        _rb.centerOfMass = centerOfMass.transform.localPosition;
        _moveAction = InputSystem.actions.FindAction("Move");
    }

    private void FixedUpdate() {
        // Propulsion and torque
        Vector2 moveValue = _moveAction.ReadValue<Vector2>();
        Vector3 propulsionForce = transform.TransformDirection(Vector3.forward) *
                                  (Time.fixedDeltaTime * moveValue.y * propulsionForceMultiplier);
        _rb.AddForceAtPosition(propulsionForce, propulsion.transform.position);
        Vector3 torqueForce = transform.TransformDirection(Vector3.up) *
                              (Time.fixedDeltaTime * moveValue.x * torqueForceMultiplier);
        _rb.AddTorque(torqueForce);

        foreach (var spring in springs) {
            if (!Physics.Raycast(spring.transform.position, transform.TransformDirection(Vector3.down),
                    out var hit, 3f)) {
                continue;
            }

            Vector3 springForce = transform.TransformDirection(Vector3.up) *
                (Time.fixedDeltaTime * Mathf.Pow(3f - hit.distance, 2)) / 3f * springForceMultiplier;
            _rb.AddForceAtPosition(springForce, spring.transform.position);
        }

        // Damping force
        Vector2 dampingForce = transform.TransformVector(Vector3.right) *
                               (-Time.fixedDeltaTime * transform.InverseTransformVector(_rb.linearVelocity).x *
                                dampingForceMultiplier);
        _rb.AddForce(dampingForce);
    }

    private void OnMenu() {
        GameManager.Instance.UIManager.TogglePause();
    }

    private void OnReset() {
        _rb.rotation = Quaternion.identity;
        _rb.linearVelocity = Vector3.zero;
        _rb.angularVelocity = Vector3.zero;
    }

    public void MoveToPosition(Vector3 position) {
        _rb.position = position;
    }
}