using UnityEngine;

public class Benchmark : MonoBehaviour {
    private enum MovementMode {
        Slow,
        Fast,
        Teleport,
        BackAndForth,
    }

    private enum CameraMode {
        Straight,
        SlowRotate,
        FastRotate,
    }
}
