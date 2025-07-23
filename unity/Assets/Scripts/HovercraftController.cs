/*
 * Author: Simon Guggisberg
 */

using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

/*
 * Class controlling a hovercraft physically-based using a magnetic model simulation.
 */
[RequireComponent(typeof(Rigidbody)), RequireComponent(typeof(PlayerInput))]
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

    [Tooltip("A multiplier applied to the spring force applied on each spring."), SerializeField]
    private float springForceMultiplier = 250f;

    [Tooltip("A multiplier applied to the damping force to reduce oscillation."), SerializeField]
    private float dampingForceMultiplier = 5f;

    [SerializeField] private float maxSpeedParticles = 100f;
    [SerializeField] private float minSpeedParticles = 50f;
    [SerializeField] private float minSpeedRateOverTime = 0f;
    [SerializeField] private float maxSpeedRateOverTime = 100f;

    private bool _isRepositioning;
    private bool _isJuiceEnabled = true;
    private Rigidbody _rb;
    private InputAction _moveAction;

    private readonly Dictionary<GameObject, TrailRenderer> _trails = new Dictionary<GameObject, TrailRenderer>();

    private void Start() {
        _rb = GetComponent<Rigidbody>();
        _rb.centerOfMass = centerOfMass.transform.localPosition;
        _moveAction = InputSystem.actions.FindAction("Move");

        foreach (GameObject spring in springs) {
            TrailRenderer trail = spring.GetComponentInChildren<TrailRenderer>();
            if (_isJuiceEnabled) {
                _trails.Add(spring, trail);
            } else {
                trail.emitting = false;
            }
        }
    }

    private void FixedUpdate() {
        if (_isRepositioning) {
            return;
        }
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
                if (_isJuiceEnabled) {
                    _trails[spring].emitting = false;
                }
                continue;
            }

            if (_isJuiceEnabled) {
                _trails[spring].emitting = true;
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

        if (_isJuiceEnabled) {
            float currentSpeed = _rb.linearVelocity.magnitude;
            float normalizedSpeed =
                Mathf.Clamp01((currentSpeed - minSpeedParticles) / (maxSpeedParticles - minSpeedParticles));
            var emission = GameManager.Instance.ChunkManager.SpeedParticles.emission;
            emission.rateOverTime = new ParticleSystem.MinMaxCurve(
                Mathf.Lerp(minSpeedRateOverTime, maxSpeedRateOverTime, normalizedSpeed)
            );
        }
    }

    private void OnReset() {
        _rb.rotation = Quaternion.identity;
        _rb.linearVelocity = Vector3.zero;
        _rb.angularVelocity = Vector3.zero;
    }

    public void ToggleJuice(bool value) {
        _isJuiceEnabled = value;
    }

    public void MoveToPosition(Vector3 position) {
        Vector3 lastVelocity = _rb.linearVelocity;
        Vector3 lastAngularVelocity = _rb.angularVelocity;
        _isRepositioning = true;
        _rb.position = position;
        _rb.linearVelocity = lastVelocity;
        _rb.angularVelocity = lastAngularVelocity;
        StartCoroutine(ClearRepositioningFlag());
    }

    private System.Collections.IEnumerator ClearRepositioningFlag() {
        yield return new WaitForFixedUpdate();
        _isRepositioning = false;
    }
}