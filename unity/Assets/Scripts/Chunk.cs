using AmplifyImpostors;
using UnityEngine;

public class Chunk : MonoBehaviour {
    [SerializeField] private LODGroup[] lodGroups;
    [SerializeField] private AmplifyImpostor[] impostors;
    [SerializeField] private Terrain terrain;

    public LODGroup[] LodGroups => lodGroups;

    public AmplifyImpostor[] Impostors => impostors;

    public Terrain Terrain => terrain;

    public void Build() {
        lodGroups = GetComponentsInChildren<LODGroup>(true);
        impostors = GetComponentsInChildren<AmplifyImpostor>(true);
        terrain = GetComponentInChildren<Terrain>();
    }
}