using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

public class ImpostorRunTime : MonoBehaviour {
    [SerializeField] private GameObject fullModel;
    [SerializeField] private GameObject imposterModel;
    [SerializeField] private float angleToRefresh = 5f;
    [SerializeField] private float distanceFromCamera = 50f;
    [SerializeField] private Vector2Int impostorResolution = new Vector2Int(256, 256);
    [SerializeField] private int impostorLayer = 6;
    [SerializeField] private Renderer impostorRenderer;
    [SerializeField] private RenderTexture _renderTexture;


    private bool _isEnabled = false;
    private float _lastAngleRefreshed;

    private void Awake() {
        /*_renderTexture = new RenderTexture(impostorResolution.x, impostorResolution.y, 24) {
            format = RenderTextureFormat.ARGB32 // Ensure alpha channel support
        };*/
    }

    private void OnDestroy() {
        /*if (_renderTexture != null) {
            _renderTexture.Release();
            Destroy(_renderTexture);
        }*/
    }

    private void ToggleImpostor(bool isEnabled) {
        fullModel.SetActive(!isEnabled);
        imposterModel.SetActive(isEnabled);
        _isEnabled = isEnabled;
    }

    private void RefreshImpostor(Camera cam) {
        // — orient billboard —
        Vector3 dirToCamera = (cam.transform.position - transform.position).normalized;
        imposterModel.transform.rotation = Quaternion.LookRotation(-dirToCamera);

        // — grab your shared impostor camera —
        GameManager.Instance.ChunkManager.ImpostorCamera.CopyFrom(cam);

        // 1) Clear to transparent black
        GameManager.Instance.ChunkManager.ImpostorCamera.clearFlags = CameraClearFlags.SolidColor;
        GameManager.Instance.ChunkManager.ImpostorCamera.backgroundColor = Color.clear; // RGBA = (0,0,0,0)

        // — render only the full-model layer into the RT —
        bool wasImpostorActive = imposterModel.activeSelf;
        imposterModel.SetActive(false);
        fullModel.SetActive(true);

        GameManager.Instance.ChunkManager.ImpostorCamera.cullingMask = 1 << impostorLayer;
        GameManager.Instance.ChunkManager.ImpostorCamera.targetTexture = _renderTexture;
        GameManager.Instance.ChunkManager.ImpostorCamera.Render();

        // — restore everything —
        imposterModel.SetActive(wasImpostorActive);
        fullModel.SetActive(!wasImpostorActive);

        // — apply to your impostor quad/material —
        impostorRenderer.material.mainTexture = _renderTexture;
    }

    private void FixedUpdate() {
        Camera cam = GameManager.Instance.ChunkManager.Camera;
        if (Vector3.Distance(cam.transform.position, transform.position) > distanceFromCamera) {
            Vector3 direction = (cam.transform.position - transform.position).normalized;
            float angle = Vector3.Angle(transform.forward, direction);
            if (!_isEnabled || Mathf.Abs(angle - _lastAngleRefreshed) > angleToRefresh) {
                _lastAngleRefreshed = angle;
                ToggleImpostor(true);
                RefreshImpostor(cam);
            }
        } else if (_isEnabled) {
            ToggleImpostor(false);
        }
    }
}