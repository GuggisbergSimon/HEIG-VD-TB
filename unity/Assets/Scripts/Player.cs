using UnityEngine;
using UnityEngine.InputSystem;

public class Player : MonoBehaviour {
    [Header("Movement Settings")] 
    [SerializeField] private float moveMaxSpeed = 5f;

    [SerializeField] private float moveMaxAcceleration = 5f;
    [SerializeField] private float rotationMaxSpeed = 10;

    public PlayerInput PlayerInput { get; private set; }

    private Rigidbody _rb;
    private InputAction _moveAction;

    private void Start() {
        GameManager.Instance.ChunkManager.Player = this;
        _rb = GetComponent<Rigidbody>();
        PlayerInput = GetComponent<PlayerInput>();
        //TODO read values from shoot input for acceleration
        _moveAction = InputSystem.actions.FindAction("Move");
    }

    private void FixedUpdate() {
        // Calculate movement direction
        Vector2 moveValue = _moveAction.ReadValue<Vector2>();

        //Rotate based on moveValue x
        //TODO angular velocity
        Vector3 rotation = transform.rotation.eulerAngles;
        rotation.y += moveValue.x * rotationMaxSpeed * Time.deltaTime;
        _rb.rotation = Quaternion.Euler(rotation);

        //Accelerate based on moveValue y
        Vector3 desiredVelocity = transform.TransformDirection(0f, 0f, moveValue.y * moveMaxSpeed);
        Vector3 velocity = _rb.linearVelocity;
        float maxSpeedChange = moveMaxAcceleration * Time.deltaTime;
        velocity.x = Mathf.MoveTowards(velocity.x, desiredVelocity.x, maxSpeedChange);
        velocity.z = Mathf.MoveTowards(velocity.z, desiredVelocity.z, maxSpeedChange);
        _rb.linearVelocity = velocity;
    }
    
    public void SetMovementSpeed(float speed, float acceleration) {
        moveMaxSpeed = speed;
        moveMaxAcceleration = acceleration;
    }
    
    private void OnMenu() {
        GameManager.Instance.QuitGame();
    }
}