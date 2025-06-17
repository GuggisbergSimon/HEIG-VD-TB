using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class HovercraftController : MonoBehaviour {
    [SerializeField] private List<GameObject> springs;
    [SerializeField] private GameObject propulsion;
    [SerializeField] private GameObject centerOfMass;
    [SerializeField] private float propulsionForceMultiplier = 400f;
    [SerializeField] private float torqueForceMultiplier = 300f;
    [SerializeField] private float springForceMultiplier = 250f;
    [SerializeField] private float dampingForceMultiplier = 5f;

    private Rigidbody _rb;
    private InputAction _moveAction;

    // Debug visualization
    private Vector3 _propulsionForce;
    private Vector3 _torqueForce;
    private List<Vector3> _springForces = new List<Vector3>();
    private List<Vector3> _springPositions = new List<Vector3>();
    private Vector3 _dampingForce;

    private void Start() {
        _rb = GetComponent<Rigidbody>();
        _rb.centerOfMass = centerOfMass.transform.localPosition;
        _moveAction = InputSystem.actions.FindAction("Move");
    }

    private void FixedUpdate() {
        // Clear previous forces
        _springForces.Clear();
        _springPositions.Clear();

        Vector2 moveValue = _moveAction.ReadValue<Vector2>();

        // Propulsion force
        _propulsionForce = transform.TransformDirection(Vector3.forward) *
                           (Time.fixedDeltaTime * moveValue.y * propulsionForceMultiplier);
        _rb.AddForceAtPosition(_propulsionForce, propulsion.transform.position);

        // Torque force
        _torqueForce = transform.TransformDirection(Vector3.up) *
                       (Time.fixedDeltaTime * moveValue.x * torqueForceMultiplier);
        _rb.AddTorque(_torqueForce);

        // Spring forces
        foreach (var spring in springs) {
            if (!Physics.Raycast(spring.transform.position, transform.TransformDirection(Vector3.down),
                    out var hit, 3f)) {
                continue;
            }

            Vector3 springForce = transform.TransformDirection(Vector3.up) *
                (Time.fixedDeltaTime * Mathf.Pow(3f - hit.distance, 2)) / 3f * springForceMultiplier;
            _springForces.Add(springForce);
            _springPositions.Add(spring.transform.position);

            _rb.AddForceAtPosition(springForce, spring.transform.position);
        }

        // Damping force
        _dampingForce = transform.TransformVector(Vector3.right) *
                        (-Time.fixedDeltaTime * transform.InverseTransformVector(_rb.linearVelocity).x *
                         dampingForceMultiplier);
        _rb.AddForce(_dampingForce);
    }

    private void OnMenu() {
        GameManager.Instance.UIManager.TogglePause();
    }

    private void OnDrawGizmos() {
        // Draw key points
        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(propulsion.transform.position, 0.2f);

        Gizmos.color = Color.green;
        foreach (var spring in springs) {
            Gizmos.DrawWireSphere(spring.transform.position, 0.2f);
        }

        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(centerOfMass.transform.position, 0.3f);

        if (!Application.isPlaying || _rb == null) return;

        // Draw propulsion force
        Gizmos.color = Color.blue;
        Gizmos.DrawRay(propulsion.transform.position, _propulsionForce.normalized * 2f);

        // Draw torque
        Gizmos.color = Color.yellow;
        Gizmos.DrawRay(transform.position, _torqueForce.normalized * 2f);

        // Draw spring forces
        Gizmos.color = Color.green;
        for (int i = 0; i < _springForces.Count; i++) {
            Gizmos.DrawRay(_springPositions[i], _springForces[i].normalized * 2f);
        }

        // Draw damping force
        Gizmos.color = Color.red;
        Gizmos.DrawRay(transform.position, _dampingForce.normalized * 2f);
    }
}