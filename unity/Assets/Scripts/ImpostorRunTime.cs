using UnityEngine;

public class ImpostorRunTime : MonoBehaviour {
    [SerializeField] private GameObject fullModel;
    [SerializeField] private GameObject imposterModel;
    [SerializeField] private float angleToRefresh = 5f;
    [SerializeField] private float distanceFromCamera = 50f;
    [SerializeField] private Vector2Int impostorResolution = new Vector2Int(256, 256);
    [SerializeField] private int impostorLayer = 6;
    [SerializeField] private Renderer impostorRenderer;
    [SerializeField] private float sizeFactor = 1.5f;
    [SerializeField] private float orthographicFactor = 0.5f;
    [SerializeField] private float fieldOfViewFactor = 2.0f;
    
    private RenderTexture _renderTexture;
    private Bounds _bounds;
    private bool _isEnabled = false;
    private float _lastAngleRefreshed;

    private void Awake() {
        _renderTexture = new RenderTexture(impostorResolution.x, impostorResolution.y, 24) {
            format = RenderTextureFormat.ARGB32 // Ensure alpha channel support
        };
        _bounds = GetModelBounds(fullModel);
    }

    private void OnDestroy() {
        if (_renderTexture != null) {
            _renderTexture.Release();
            Destroy(_renderTexture);
        }
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
        Camera impostorCamera = GameManager.Instance.ChunkManager.ImpostorCamera;
        impostorCamera.CopyFrom(cam);
    
        // Setup camera for impostor rendering
        impostorCamera.clearFlags = CameraClearFlags.SolidColor;
        impostorCamera.backgroundColor = Color.clear; // RGBA = (0,0,0,0)
    
        // Position the camera to frame the model properly
        float objectSize = _bounds.size.magnitude;
        float distance = objectSize * sizeFactor;
    
        // Position camera looking at the center of the model
        impostorCamera.transform.position = transform.position - dirToCamera * distance;
        impostorCamera.transform.LookAt(transform.position);
    
        // Set field of view to frame the object properly
        if (impostorCamera.orthographic) {
            impostorCamera.orthographicSize = objectSize * orthographicFactor;
        } else {
            impostorCamera.fieldOfView = fieldOfViewFactor * Mathf.Atan(objectSize / (fieldOfViewFactor * distance)) * Mathf.Rad2Deg;
        }
    
        // — render only the full-model layer into the RT —
        bool wasImpostorActive = imposterModel.activeSelf;
        imposterModel.SetActive(false);
        fullModel.SetActive(true);

        impostorCamera.cullingMask = 1 << impostorLayer;
        impostorCamera.targetTexture = _renderTexture;
        impostorCamera.Render();

        // — restore everything —
        imposterModel.SetActive(wasImpostorActive);
        fullModel.SetActive(!wasImpostorActive);

        // — apply to your impostor quad/material —
        impostorRenderer.material.mainTexture = _renderTexture;
    }
    
    private Bounds GetModelBounds(GameObject model) {
        Bounds bounds = new Bounds(model.transform.position, Vector3.zero);
        Renderer[] renderers = model.GetComponentsInChildren<Renderer>();
        
        foreach (Renderer fullRenderer in renderers) {
            bounds.Encapsulate(fullRenderer.bounds);
        }
            
        return bounds;
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