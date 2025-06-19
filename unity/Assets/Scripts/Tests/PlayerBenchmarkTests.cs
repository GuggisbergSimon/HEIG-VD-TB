#if UNITY_EDITOR
using System.Collections;
using NUnit.Framework;
using Unity.Cinemachine;
using Unity.PerformanceTesting;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.TestTools;

namespace Tests {
    [TestFixture]
    public class PlayerBenchmarkTests {
        private int _warmUpCount = 30;
        private int _measurementCount = 200;
        private int _moveDistance = 1;
        private int _moveFastDistance = 5;
        private int _teleportDistance = 700;
        private float _horizontalPanSpeed = 2f;
        private float _fastHorizontalPanSpeed = 45.0f;

        [OneTimeSetUp]
        public void OneTimeSetup() {
            SceneManager.LoadScene("Compositing 2");
        }

        private IEnumerator WaitForSceneLoad() {
            while (!SceneManager.GetActiveScene().isLoaded) {
                yield return null;
            }
        }

        private IEnumerator RunPerformanceTest(System.Action<int> movementAction) {
            yield return WaitForSceneLoad();
            // Reset player
            GameManager.Instance.ChunkManager.Player.transform.position = Vector3.zero;
            var panTilt = GetPanTilt();
            if (panTilt == null) {
                yield return null;
            }

            panTilt.PanAxis.Value = 0;

            using (Measure.Frames()
                       .WarmupCount(_warmUpCount)
                       .MeasurementCount(_measurementCount)
                       .Scope()) {
                for (int i = 0; i < _measurementCount; i++) {
                    movementAction(i);
                    yield return null;
                }
            }

            yield return null;
        }

        [UnityTest, Performance]
        public IEnumerator MoveForward_PerformanceTest() {
            return RunPerformanceTest(i =>
                GameManager.Instance.ChunkManager.Player.transform.position += Vector3.forward * _moveDistance);
        }

        [UnityTest, Performance]
        public IEnumerator MoveFast_PerformanceTest() {
            return RunPerformanceTest(
                i => GameManager.Instance.ChunkManager.Player.transform.position += Vector3.forward * _moveFastDistance
            );
        }

        [UnityTest, Performance]
        public IEnumerator Teleport_PerformanceTest() {
            return RunPerformanceTest(i =>
                GameManager.Instance.ChunkManager.Player.transform.position += Random.onUnitSphere * _teleportDistance);
        }

        [UnityTest, Performance]
        public IEnumerator BackAndForth_PerformanceTest() {
            return RunPerformanceTest(i => {
                if (i % 2 == 0) {
                    GameManager.Instance.ChunkManager.Player.transform.position += Vector3.up * _teleportDistance;
                }
                else {
                    GameManager.Instance.ChunkManager.Player.transform.position -= Vector3.up * _teleportDistance;
                }
            });
        }

        private CinemachinePanTilt GetPanTilt() {
            var playerCamera = GameObject.Find("PlayerCamera");
            if (playerCamera != null) {
                return playerCamera.GetComponent<CinemachinePanTilt>();
            }

            return null;
        }

        [UnityTest, Performance]
        public IEnumerator HorizontalPan() {
            var panTilt = GetPanTilt();
            if (panTilt == null) {
                return null;
            }

            return RunPerformanceTest(i => { panTilt.PanAxis.Value += _horizontalPanSpeed; });
        }

        [UnityTest, Performance]
        public IEnumerator FastHorizontalPan() {
            var panTilt = GetPanTilt();
            if (panTilt == null) {
                return null;
            }

            return RunPerformanceTest(i => { panTilt.PanAxis.Value += _fastHorizontalPanSpeed; });
        }
    }
}
#endif