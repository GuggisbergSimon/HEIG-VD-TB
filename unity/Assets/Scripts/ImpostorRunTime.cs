using UnityEngine;

public class ImpostorRunTime : MonoBehaviour {
    [SerializeField] private GameObject fullModel;
    [SerializeField] private GameObject imposterModel;
    [SerializeField] private float angleToRefresh = 5f;
    [SerializeField] private float distanceFromCamera = 50f;
    [SerializeField] private Vector2Int impostorResolution = new Vector2Int(256, 256);
    [SerializeField] private int impostorLayer = 6;
    [SerializeField] private Renderer impostorRenderer;
    [SerializeField] private Camera mainCamera;
    
    private RenderTexture _renderTexture;
    private Camera _camera;
    private Bounds _bounds;
    private bool _isEnabled = false;
    private float _lastAngleRefreshed;

    private void Awake() {
        _renderTexture = new RenderTexture(impostorResolution.x, impostorResolution.y, 24) {
            format = RenderTextureFormat.ARGBHalf
        };
        _bounds = GetModelBounds(fullModel);
        _camera = new GameObject("ImpostorCamera").AddComponent<Camera>();
        _camera.transform.parent = transform;
        _camera.enabled = false;
        _camera.clearFlags = CameraClearFlags.SolidColor;
        _camera.backgroundColor = new Color(0, 0, 0, 0);
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
        // Orient billboard
        Vector3 dirToCamera = (cam.transform.position - transform.position).normalized;
        imposterModel.transform.rotation = Quaternion.LookRotation(-dirToCamera);
        
        // Setup camera for impostor rendering
        _camera.CopyFrom(cam);
        _camera.clearFlags = CameraClearFlags.SolidColor;
        _camera.backgroundColor = Color.clear;
        _camera.cullingMask = 1 << impostorLayer;
        _camera.targetTexture = _renderTexture;
    
        // Orient the camera
        Vector3 boundsCenter = _bounds.center;
        _camera.transform.LookAt(boundsCenter);

        // Change fov/position of camera to fit the model bounds
        _camera.transform.position = boundsCenter + dirToCamera * _bounds.size.magnitude;
        float distance = Vector3.Distance(_camera.transform.position, boundsCenter);
        float requiredFOV = 2.0f * Mathf.Atan(_bounds.extents.magnitude / distance) * Mathf.Rad2Deg;
        _camera.fieldOfView = requiredFOV * 1.2f; // Add 20% margin to ensure model fits
    
        // Render only the full-model layer into the RenderTexture
        bool wasImpostorActive = imposterModel.activeSelf;
        imposterModel.SetActive(false);
        fullModel.SetActive(true);
        _camera.Render();

        // Restore everything
        imposterModel.SetActive(wasImpostorActive);
        fullModel.SetActive(!wasImpostorActive);

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
        if (Vector3.Distance(mainCamera.transform.position, transform.position) > distanceFromCamera) {
            Vector3 direction = (mainCamera.transform.position - transform.position).normalized;
            float angle = Vector3.Angle(transform.forward, direction);
            if (!_isEnabled || Mathf.Abs(angle - _lastAngleRefreshed) > angleToRefresh) {
                _lastAngleRefreshed = angle;
                ToggleImpostor(true);
                RefreshImpostor(mainCamera);
            }
        } else if (_isEnabled) {
            ToggleImpostor(false);
        }
    }
}