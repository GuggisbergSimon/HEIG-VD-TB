using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class ImpostorRunTime : MonoBehaviour {
    [SerializeField] private GameObject fullModel;
    [SerializeField] private GameObject imposterModel;
    [SerializeField] private float angleToRefresh = 5f;
    [SerializeField] private float distanceFromCamera = 50f;
    [SerializeField] private Vector2Int impostorResolution = new Vector2Int(256, 256);
    [SerializeField] private int impostorLayer = 31; // (typically unused)
    [SerializeField] private Renderer impostorRenderer;
    
    private bool _isEnabled = false;
    private float _lastAngleRefreshed;
    private RenderTexture _renderTexture;

    private void Awake() {
        // Create render texture with the specified resolution
        _renderTexture = new RenderTexture(impostorResolution.x, impostorResolution.y, 24);
    }
    
    private void OnDestroy() {
        if (_renderTexture != null) {
            _renderTexture.Release();
            Destroy(_renderTexture);
        }
    }
    
    private void SetLayersRecursively(GameObject obj, int layer, Dictionary<GameObject, int> originalLayers) {
        originalLayers[obj] = obj.layer;
        obj.layer = layer;
    
        foreach (Transform child in obj.transform) {
            SetLayersRecursively(child.gameObject, layer, originalLayers);
        }
    }

    private void RestoreLayersRecursively(Dictionary<GameObject, int> originalLayers) {
        foreach (var kvp in originalLayers) {
            if (kvp.Key != null) { // Check if object still exists
                kvp.Key.layer = kvp.Value;
            }
        }
    }
    
    private void ToggleImpostor(bool isEnabled) {
        fullModel.SetActive(!isEnabled);
        imposterModel.SetActive(isEnabled);
        _isEnabled = isEnabled;
    }

    private void RefreshImpostor(Camera cam) {
        Vector3 dirToCamera = (transform.position - cam.transform.position).normalized;
        imposterModel.transform.rotation = Quaternion.LookRotation(dirToCamera);
    
        //TODO fix impostor displaying something else than impostor
        GameManager.Instance.ChunkManager.ImpostorCamera.CopyFrom(cam);
        bool wasImpostorActive = imposterModel.activeSelf;
        imposterModel.SetActive(false);
        fullModel.SetActive(true);
        int tempLayer = impostorLayer; 
        Dictionary<GameObject, int> originalLayers = new Dictionary<GameObject, int>();
        SetLayersRecursively(fullModel, tempLayer, originalLayers);
        GameManager.Instance.ChunkManager.ImpostorCamera.cullingMask = 1 << tempLayer;
        GameManager.Instance.ChunkManager.ImpostorCamera.targetTexture = _renderTexture;
        GameManager.Instance.ChunkManager.ImpostorCamera.Render();
        RestoreLayersRecursively(originalLayers);
        imposterModel.SetActive(wasImpostorActive);
        fullModel.SetActive(!wasImpostorActive);
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