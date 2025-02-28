using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;

public class Player : MonoBehaviour {
    [FormerlySerializedAs("moveSpeed")]
    [Header("Movement Settings")]
    [SerializeField] private float moveMaxSpeed = 5f;
    [SerializeField] private float moveAcceleration = 5f;
    [SerializeField] private float rotationMaxSpeed = 10;
    
    [Header("Ground Check")]
    [SerializeField] private LayerMask groundLayer;
    [SerializeField] private float groundCheckDistance = 0.2f;
    
    private Rigidbody _rigidbody;
    InputAction _moveAction;
    private bool _jumpRequested;
    
    private void Awake() {
        _rigidbody = GetComponent<Rigidbody>();
        _moveAction = InputSystem.actions.FindAction("Move");
    }
    
    private void FixedUpdate() {
        // Calculate movement direction
        Vector2 moveValue = _moveAction.ReadValue<Vector2>();
        Vector3 moveDirection = new Vector3(moveValue.x, 0, moveValue.y);
        
        if (moveDirection != Vector3.zero) {
            // Rotation
            Quaternion targetRotation = Quaternion.LookRotation(moveDirection, Vector3.up);
            _rigidbody.rotation = Quaternion.RotateTowards(_rigidbody.rotation, targetRotation, rotationMaxSpeed);
            
            // Movement
            Vector3 horizontalVelocity = new Vector3(_rigidbody.linearVelocity.x, 0, _rigidbody.linearVelocity.z);
            Vector3 movement = horizontalVelocity + moveDirection.normalized * moveAcceleration;
            movement = Vector3.ClampMagnitude(movement, moveMaxSpeed);
            _rigidbody.linearVelocity = new Vector3(movement.x, _rigidbody.linearVelocity.y, movement.z);
        } else {
            // Stop horizontal movement when no input
            _rigidbody.linearVelocity = new Vector3(0, _rigidbody.linearVelocity.y, 0);
        }
    }
}