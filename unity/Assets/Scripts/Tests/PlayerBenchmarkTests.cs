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
        private const int WarmUpCount = 30;
        private const int MeasurementCount = 200;
        private const int MoveDistance = 1;
        private const int MoveFastDistance = 5;
        private const int TeleportDistance = 700;
        private const float HorizontalPanSpeed = 2f;
        private const float FastHorizontalPanSpeed = 45.0f;

        [OneTimeSetUp]
        public void OneTimeSetup() {
            SceneManager.LoadScene("Boot");
        }

        [SetUp]
        public void Setup() {
            LoadSettings(true, true, true);
            SceneManager.LoadScene("Compositing");
        }

        [TearDown]
        public void TearDown() {
            SceneManager.LoadScene("MainMenu");
        }

        private void LoadSettings(bool recenterChunks, bool loadingChunks, bool enableLOD) {
            GameManager.Instance.LoadSettings(new GameSettings {
                RecenterChunks = recenterChunks,
                LoadingChunks = loadingChunks,
                EnableLOD = enableLOD
            });
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
                       .WarmupCount(WarmUpCount)
                       .MeasurementCount(MeasurementCount)
                       .Scope()) {
                for (int i = 0; i < MeasurementCount; i++) {
                    movementAction(i);
                    yield return null;
                }
            }

            yield return null;
        }

        [UnityTest, Performance]
        public IEnumerator MoveForward_PerformanceTest() {
            return RunPerformanceTest(i =>
                GameManager.Instance.ChunkManager.Player.transform.position += Vector3.forward * MoveDistance);
        }

        [UnityTest, Performance]
        public IEnumerator MoveFast_PerformanceTest() {
            return RunPerformanceTest(
                i => GameManager.Instance.ChunkManager.Player.transform.position += Vector3.forward * MoveFastDistance
            );
        }

        [UnityTest, Performance]
        public IEnumerator Teleport_PerformanceTest() {
            return RunPerformanceTest(i =>
                GameManager.Instance.ChunkManager.Player.transform.position += Random.onUnitSphere * TeleportDistance);
        }

        [UnityTest, Performance]
        public IEnumerator BackAndForth_PerformanceTest() {
            return RunPerformanceTest(i => {
                if (i % 2 == 0) {
                    GameManager.Instance.ChunkManager.Player.transform.position += Vector3.up * TeleportDistance;
                }
                else {
                    GameManager.Instance.ChunkManager.Player.transform.position -= Vector3.up * TeleportDistance;
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

            return RunPerformanceTest(i => { panTilt.PanAxis.Value += HorizontalPanSpeed; });
        }

        [UnityTest, Performance]
        public IEnumerator FastHorizontalPan() {
            var panTilt = GetPanTilt();
            if (panTilt == null) {
                return null;
            }

            return RunPerformanceTest(i => { panTilt.PanAxis.Value += FastHorizontalPanSpeed; });
        }
    }
}
#endif