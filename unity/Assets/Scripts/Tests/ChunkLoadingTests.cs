/*
 * Author: Simon Guggisberg
 */

#if UNITY_EDITOR
using System.Collections;
using NUnit.Framework;
using Unity.PerformanceTesting;
using UnityEngine.TestTools;

namespace Tests {
    /*
     * Test Class for testing chunk loading.
     */
    [TestFixture]
    public class ChunkLoadingTests {
        [OneTimeSetUp]
        public void OneTimeSetup() {
            Utils.OneTimeSetup();
        }

        [SetUp]
        public void Setup() {
            Utils.LoadSettings(false, 3, false, false, false);
            Utils.Setup();
        }

        [TearDown]
        public void TearDown() {
            Utils.TearDown();
        }

        [UnityTest, Performance]
        public IEnumerator MoveForward() {
            return Utils.MoveForward();
        }

        [UnityTest, Performance]
        public IEnumerator MoveFast() {
            return Utils.MoveFast();
        }

        [UnityTest, Performance]
        public IEnumerator Teleport() {
            return Utils.Teleport();
        }

        [UnityTest, Performance]
        public IEnumerator BackAndForth() {
            return Utils.BackAndForth();
        }

        [UnityTest, Performance]
        public IEnumerator HorizontalPan() {
            return Utils.HorizontalPan();
        }

        [UnityTest, Performance]
        public IEnumerator FastHorizontalPan() {
            return Utils.FastHorizontalPan();
        }
    }
}
#endif