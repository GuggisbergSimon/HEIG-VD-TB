#if UNITY_EDITOR
using System.Collections;
using Unity.Cinemachine;
using Unity.PerformanceTesting;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Tests {
    public static class Utils {
        private const int WarmUpCount = 30;
        private const int MeasurementCount = 100;
        private const int MoveDistance = 1;
        private const int MoveFastDistance = 5;
        private const int TeleportDistance = 500;
        private const float HorizontalPanSpeed = 2f;
        private const float FastHorizontalPanSpeed = 45.0f;

        public static void OneTimeSetup() {
            SceneManager.LoadScene("Boot");
        }

        public static void Setup() {
            SceneManager.LoadScene("Compositing");
        }

        public static void TearDown() {
            SceneManager.LoadScene("MainMenu");
        }

        public static void LoadSettings(bool recenterChunks, bool loadingChunks, bool enableLOD, bool enableImpostor, bool srpBatcher) {
            GameManager.Instance.LoadSettings(new GameSettings {
                RecenterChunks = recenterChunks,
                LoadingChunks = loadingChunks,
                EnableLOD = enableLOD,
                EnableImpostor = enableImpostor,
                SRPBatcher = srpBatcher,
            });
        }

        private static IEnumerator WaitForSceneLoad() {
            while (!SceneManager.GetActiveScene().isLoaded) {
                yield return null;
            }
        }

        private static CinemachinePanTilt GetPanTilt() {
            var playerCamera = GameObject.Find("PlayerCamera");
            if (playerCamera != null) {
                return playerCamera.GetComponent<CinemachinePanTilt>();
            }

            return null;
        }

        private static IEnumerator RunPerformanceTest(System.Action<int> movementAction) {
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

        public static IEnumerator MoveForward() {
            return RunPerformanceTest(i =>
                GameManager.Instance.ChunkManager.Player.transform.position += Vector3.forward * MoveDistance);
        }

        public static IEnumerator MoveFast() {
            return RunPerformanceTest(
                i => {
                    // Generate deterministic teleport positions in a square spiral pattern
                    float angle = i * 0.25f * Mathf.PI; // 90 degree increments
                    int layer = 1 + i / 4;
                    Vector3 direction = new Vector3(
                        Mathf.RoundToInt(Mathf.Cos(angle)) * layer,
                        0,
                        Mathf.RoundToInt(Mathf.Sin(angle)) * layer
                    );
                    GameManager.Instance.ChunkManager.Player.transform.position = direction * TeleportDistance;
                }
            );
        }

        public static IEnumerator Teleport() {
            return RunPerformanceTest(i =>
                GameManager.Instance.ChunkManager.Player.transform.position += Random.onUnitSphere * TeleportDistance);
        }

        public static IEnumerator BackAndForth() {
            return RunPerformanceTest(i => {
                if (i % 2 == 0) {
                    GameManager.Instance.ChunkManager.Player.transform.position += new Vector3(1, 0, 1) * TeleportDistance;
                } else {
                    GameManager.Instance.ChunkManager.Player.transform.position -= new Vector3(1, 0, 1) * TeleportDistance;
                }
            });
        }

        public static IEnumerator HorizontalPan() {
            var panTilt = GetPanTilt();
            if (panTilt == null) {
                return null;
            }

            return RunPerformanceTest(i => { panTilt.PanAxis.Value += HorizontalPanSpeed; });
        }

        public static IEnumerator FastHorizontalPan() {
            var panTilt = GetPanTilt();
            if (panTilt == null) {
                return null;
            }

            return RunPerformanceTest(i => { panTilt.PanAxis.Value += FastHorizontalPanSpeed; });
        }
    }
}
#endif