package com.intellirec.scraper;

import com.intellirec.model.TravelDestination;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * TravelScraperEngine v6.0 — OpenTripMap API
 * Uses a 2-step process (Geoname -> Radius) filtered by `kinds`.
 */
public class TravelScraperEngine {

    private static final String OTM_HOST = "opentripmap-places-v1.p.rapidapi.com";
    private static final String OTM_GEONAME_URL = "https://opentripmap-places-v1.p.rapidapi.com/en/places/geoname";
    private static final String OTM_RADIUS_URL = "https://opentripmap-places-v1.p.rapidapi.com/en/places/radius";
    
    // Using the user-provided API key directly to ensure it works properly locally
    private static final String RAPIDAPI_KEY = "2c69522dbemsha9318c53260b796p168040jsn31c8f1944d9b";

    public List<TravelDestination> search(String query, String purpose) {
        List<TravelDestination> results = new ArrayList<>();

        try {
            // STEP 1: Geoname resolution (Name -> Lat/Lon)
            String encodedQuery = URLEncoder.encode(query, "UTF-8");
            String geonameUrlStr = OTM_GEONAME_URL + "?name=" + encodedQuery;
            
            System.out.println("[TravelScraper] OpenTripMap Step 1 (Geoname) for query: " + query);
            String geonameResponse = httpGetWithHeaders(geonameUrlStr, RAPIDAPI_KEY, OTM_HOST);
            JSONObject locationObj = new JSONObject(geonameResponse);
            
            if (!locationObj.has("lat") || !locationObj.has("lon")) {
                System.out.println("[TravelScraper] OpenTripMap could not resolve coordinates for '" + query + "'");
                return results;
            }
            
            double lat = locationObj.getDouble("lat");
            double lon = locationObj.getDouble("lon");
            String country = locationObj.optString("country", "");
            String baseName = locationObj.optString("name", query);
            
            System.out.println("[TravelScraper] Resolved " + baseName + ", " + country + " [Lat: " + lat + ", Lon: " + lon + "]");
            
            // Map User's Purpose Dropdown to OpenTripMap 'kinds'
            String kinds = getKindsFromPurpose(purpose);
            System.out.println("[TravelScraper] Mapped purpose '" + purpose + "' to kinds: " + kinds);

            // STEP 2: Radius Search (Lat/Lon + Category -> Attractions)
            // Hardcoded to 10km radius (10000m) and limiting to 12 results
            String radiusUrlStr = OTM_RADIUS_URL + 
                "?radius=10000" + 
                "&lon=" + lon + 
                "&lat=" + lat + 
                "&kinds=" + kinds + 
                "&format=json" + 
                "&limit=12";
                
            System.out.println("[TravelScraper] OpenTripMap Step 2 (Radius Search)");
            String radiusResponse = httpGetWithHeaders(radiusUrlStr, RAPIDAPI_KEY, OTM_HOST);
            
            JSONArray placesArray;
            try {
                placesArray = new JSONArray(radiusResponse);
            } catch (Exception e) {
                // If it isn't an array format, return empty
                System.err.println("[TravelScraper] Invalid JSON response from OpenTripMap Step 2");
                return results;
            }
            
            System.out.println("[TravelScraper] OpenTripMap returned " + placesArray.length() + " places nearby.");
            
            for (int i = 0; i < placesArray.length(); i++) {
                try {
                    JSONObject place = placesArray.getJSONObject(i);
                    
                    String placeName = place.optString("name", "");
                    if (placeName == null || placeName.trim().isEmpty()) {
                        continue;
                    }
                    
                    // Dist is in meters
                    int dist = place.optInt("dist", 0);
                    int rate = place.optInt("rate", 4);
                    String placeKinds = place.optString("kinds", "interesting_places").replace("_", " ");
                    
                    // Create a description out of the basic data provided
                    String description = "Located " + dist + " meters from the heart of " + baseName + " (" + country + "). " +
                                         "Classification: " + placeKinds + ".";
                                         
                    String ratingStr = String.valueOf(rate) + ".0"; // OTM rating 0-7, treat as base
                    
                    // OpenTripMap doesn't immediately return a photo URL without a separate XID lookup.
                    // For UI robustness, use an Unsplash visual explicitly based on the destination.
                    String image = "https://source.unsplash.com/800x600/?" + URLEncoder.encode(placeName + " " + query + " travel", "UTF-8");
                    
                    // URL link to an explore page
                    String exploreUrl = "https://www.google.com/search?q=" + URLEncoder.encode(placeName + " " + country, "UTF-8");

                    TravelDestination dest = new TravelDestination(
                        UUID.randomUUID().toString(),
                        placeName + " (" + baseName + ")",
                        description,
                        "ATTRACTION",
                        ratingStr,
                        image,
                        exploreUrl
                    );
                    
                    results.add(dest);
                    System.out.println("[TravelScraper] ✓ Found Attraction: " + placeName);
                    
                } catch (Exception e) {
                    System.err.println("[TravelScraper] Error indexing place " + i + ": " + e.getMessage());
                }
            }
            
        } catch (Exception e) {
            System.err.println("[TravelScraper] OpenTripMap API Exception: " + e.getMessage());
            e.printStackTrace();
        }

        return results;
    }
    
    /**
     * Maps the IntelliRec frontend categories to the exact OpenTripMap kinds
     */
    private String getKindsFromPurpose(String purpose) {
        if (purpose == null) return "interesting_places";
        
        switch (purpose) {
            case "Vacation":
            case "Relaxing Vacation":
                return "beaches,natural";
            case "Adventure":
            case "Adventure & Sports":
                return "sport,natural";
            case "Culture":
            case "Cultural Discovery":
                return "historic,museums,architecture";
            case "Food":
            case "Food & Nightlife":
                return "foods,amusements";
            default:
                return "interesting_places";
        }
    }

    private String httpGetWithHeaders(String urlStr, String apiKey, String apiHost) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("X-RapidAPI-Key", apiKey);
        conn.setRequestProperty("X-RapidAPI-Host", apiHost);
        conn.setConnectTimeout(8000);
        conn.setReadTimeout(10000);

        int status = conn.getResponseCode();
        if (status != 200) {
            System.err.println("[TravelScraper HTTP GET ERROR] Status=" + status + " URL=" + urlStr);
            BufferedReader errReader = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
            String errLine;
            while ((errLine = errReader.readLine()) != null) {
                System.err.println(errLine);
            }
            errReader.close();
            throw new Exception("HTTP " + status + " for: " + urlStr);
        }

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        reader.close();
        conn.disconnect();
        return sb.toString();
    }
}
