using UnityEngine;
using UnityEngine.InputSystem;

public class CarController : MonoBehaviour
{

    [SerializeField] private float motorForce, breakForce, maxSteerAngle;

    [SerializeField] private WheelCollider frontLeftWheelCollider, frontRightWheelCollider;
    [SerializeField] private WheelCollider backLeftWheelCollider;
    [SerializeField] private WheelCollider backRightWheelCollider;

    
    private InputAction _resetAction;
    private Rigidbody _rigidbody;
    private bool _isBreaking = false;

    private void Awake() {
        _rigidbody = GetComponent<Rigidbody>();
    }

    private void OnMove(InputValue value) {
        Vector2 moveValue = value.Get<Vector2>();
        float motorTorqueValue = moveValue.y * motorForce;
        ApplyOnWheels(wheel => wheel.motorTorque = motorTorqueValue);
        float currentSteerAngle = maxSteerAngle * moveValue.x;
        frontLeftWheelCollider.steerAngle = currentSteerAngle;
        frontRightWheelCollider.steerAngle = currentSteerAngle;
    }

    private void OnJump() {
            float force = _isBreaking ? 0f : breakForce;
        _isBreaking = !_isBreaking;
        ApplyOnWheels(wheel => wheel.brakeTorque = force);
    }

    private void OnReset() {
        _rigidbody.rotation = Quaternion.identity;
        _rigidbody.linearVelocity = Vector3.zero;
        _rigidbody.angularVelocity = Vector3.zero;
    }
    
    private void OnMenu() {
        Application.Quit();
    }

    private void ApplyOnWheels(System.Action<WheelCollider> action) {
        action?.Invoke(frontLeftWheelCollider);
        action?.Invoke(frontRightWheelCollider);
        action?.Invoke(backLeftWheelCollider);
        action?.Invoke(backRightWheelCollider);
    }
}