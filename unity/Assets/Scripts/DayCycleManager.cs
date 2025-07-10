using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;
using UnityEngine.Serialization;

public class DayCycleManager : MonoBehaviour {
    [SerializeField, Range(0f, 24f)] private float currentTime;
    [SerializeField] private float timeSpeed = 1f;
    [SerializeField] private float startDay = 6f;
    [SerializeField] private float endDay = 18f;

    [Header("Sun")] [SerializeField] private Light sunLight;
    [SerializeField] private HDAdditionalLightData sunLightData;
    [SerializeField] private float sunPosition;
    [SerializeField] private float sunIntensity = 1f;
    [SerializeField] private float sunTemperature = 10000f;
    [SerializeField] private AnimationCurve sunIntensityMultiplier;
    [SerializeField] private AnimationCurve sunTemperatureCurve;

    [Header("Moon ")] [SerializeField] private Light moonLight;
    [SerializeField] private HDAdditionalLightData moonLightData;
    [SerializeField] private float moonIntensity = 1f;
    [SerializeField] private float moonTemperature = 20000f;
    [SerializeField] private AnimationCurve moonIntensityMultiplier;
    [SerializeField] private AnimationCurve moonTemperatureCurve;
    
    [Header("Stars")]
    [SerializeField] private VolumeProfile volumeProfile;
    [SerializeField] private float starsIntensity = 1f;
    [SerializeField] private AnimationCurve starsCurve;
    
    private PhysicallyBasedSky _skySettings;
    

    private bool _isDay = true;

    private void Start() {
        volumeProfile.TryGet(out _skySettings);
        CheckShadowStatus();
        SkyStar();
    }

    private void Update() {
        currentTime += Time.deltaTime * timeSpeed;
        currentTime %= 24;
        UpdateLight();
        CheckShadowStatus();
        SkyStar();
    }

    private void OnValidate() {
        if (_skySettings == null) {
            volumeProfile.TryGet(out _skySettings);
        }
        UpdateLight();
        CheckShadowStatus();
        SkyStar();
    }

    private void UpdateLight() {
        float sunRotation = currentTime / 24f * 360f;
        sunLight.transform.rotation = Quaternion.Euler(sunRotation - 90f, sunPosition, 0f);
        moonLight.transform.rotation = Quaternion.Euler(sunRotation + 90f, sunPosition, 0f);

        UpdateDirectionalLight(sunLight, sunIntensityMultiplier, sunTemperatureCurve, sunIntensity, sunTemperature);
        UpdateDirectionalLight(moonLight, moonIntensityMultiplier, moonTemperatureCurve, moonIntensity,
            moonTemperature);
    }

    private void UpdateDirectionalLight(Light directionalLight, AnimationCurve intensityMultiplier,
        AnimationCurve temperatureCurve, float intensity, float temperature) {
        float normalizedTime = currentTime / 24f;
        float intensityCurve = intensityMultiplier.Evaluate(normalizedTime);
        directionalLight.intensity = intensityCurve * intensity;
        float temperatureMultiplier = temperatureCurve.Evaluate(normalizedTime);
        directionalLight.colorTemperature = temperatureMultiplier * temperature;
    }

    private void ToggleShadows(bool isDay) {
        sunLightData.EnableShadows(isDay);
        moonLightData.EnableShadows(!isDay);
        _isDay = isDay;
    }
    
    private void CheckShadowStatus() {
        if (currentTime >= startDay && currentTime <= endDay) {
            ToggleShadows(true);
        } else {
            ToggleShadows(false);
        }
    }

    private void SkyStar() {
        _skySettings.spaceEmissionMultiplier.value = starsCurve.Evaluate(currentTime / 24f) * starsIntensity;
    }
}