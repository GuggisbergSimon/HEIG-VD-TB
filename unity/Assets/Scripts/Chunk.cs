using AmplifyImpostors;
using UnityEngine;

public class Chunk : MonoBehaviour {
    [SerializeField] private LODGroup[] lodGroups;
    [SerializeField] private AmplifyImpostor[] impostors;
    [SerializeField] private Terrain terrain;

    public LODGroup[] LodGroups => lodGroups;
    public AmplifyImpostor[] Impostors => impostors;
    public Terrain Terrain => terrain;

    public void Build()
    {
        if (lodGroups == null || lodGroups.Length == 0)
            lodGroups = GetComponentsInChildren<LODGroup>(true);
            
        if (impostors == null || impostors.Length == 0)
            impostors = GetComponentsInChildren<AmplifyImpostor>(true);
            
        if (terrain == null)
            terrain = GetComponentInChildren<Terrain>();
    }
}