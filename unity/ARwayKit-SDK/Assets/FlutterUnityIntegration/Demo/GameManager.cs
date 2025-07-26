using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ARWAY;

public class GameManager : MonoBehaviour
{
    public void LoadMap(string mapId)
    {
        Debug.Log("Received Map ID from Flutter: " + mapId);
        
        // Find the ArwaySDK object in your scene
        ArwaySDK sdk = FindObjectOfType<ArwaySDK>();
        
        if (sdk != null)
        {
            // Load the map using the provided mapId
            sdk.LoadMap(int.Parse(mapId));
        }
        else
        {
            Debug.LogError("ArwaySDK object not found in the scene.");
        }
    }
}
