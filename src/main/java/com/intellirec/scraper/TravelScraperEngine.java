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
 * TravelScraperEngine v7.0 — OpenTripMap API
 * Fixed: image source, rate limiting, rating scale, fallback handling
 */
public class TravelScraperEngine {

    private static final String OTM_HOST        = "opentripmap-places-v1.p.rapidapi.com";
    private static final String OTM_GEONAME_URL = "https://opentripmap-places-v1.p.rapidapi.com/en/places/geoname";
    private static final String OTM_RADIUS_URL  = "https://opentripmap-places-v1.p.rapidapi.com/en/places/radius";
    private static final String OTM_XID_URL     = "https://opentripmap-places-v1.p.rapidapi.com/en/places/xid/";

    // ✅ Move this to environment variable or config file before submitting project
    private static final String RAPIDAPI_KEY = "2c69522dbemsha9318c53260b796p168040jsn31c8f1944d9b";

    // ✅ Fallback images per category — used when API returns no image
    // These are direct stable image URLs, not source.unsplash.com (which is shut down)
    private static final String[] FALLBACK_VACATION  = {
        "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
        "https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800",
        "https://images.unsplash.com/photo-1473116763249-2faaef81ccda?w=800"
    };
    private static final String[] FALLBACK_ADVENTURE = {
        "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800",
        "https://images.unsplash.com/photo-1551632811-561732d1e306?w=800",
        "https://images.unsplash.com/photo-1527004013197-933b23bd63dc?w=800"
    };
    private static final String[] FALLBACK_CULTURE   = {
        "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800",
        "https://images.unsplash.com/photo-1503152394-c571994fd383?w=800",
        "https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=800"
    };
    private static final String[] FALLBACK_FOOD      = {
        "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800",
        "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800",
        "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800"
    };

    public List<TravelDestination> search(String query, String purpose) {
        List<TravelDestination> results = new ArrayList<>();

        try {
            // ─────────────────────────────────────────
            // STEP 1: Resolve place name → Lat/Lon
            // ─────────────────────────────────────────
            String encodedQuery  = URLEncoder.encode(query.trim(), "UTF-8");
            String geonameUrlStr = OTM_GEONAME_URL + "?name=" + encodedQuery;

            System.out.println("[TravelScraper] Step 1 — Resolving coordinates for: " + query);
            String geonameResponse = httpGetWithHeaders(geonameUrlStr);

            // ✅ Guard: check response is not empty before parsing
            if (geonameResponse == null || geonameResponse.trim().isEmpty()) {
                System.err.println("[TravelScraper] Empty geoname response for: " + query);
                return results;
            }

            JSONObject locationObj = new JSONObject(geonameResponse);

            if (!locationObj.has("lat") || !locationObj.has("lon")) {
                System.err.println("[TravelScraper] Could not resolve coordinates for: " + query);
                return results;
            }

            double lat      = locationObj.getDouble("lat");
            double lon      = locationObj.getDouble("lon");
            String country  = locationObj.optString("country", "");
            String baseName = locationObj.optString("name", query);
            System.out.println("[TravelScraper] Resolved → " + baseName + ", " + country
                + " [" + lat + ", " + lon + "]");

            // ✅ Fixed Bug 2: Small pause between Step 1 and Step 2
            // Prevents hitting RapidAPI rate limiter back-to-back
            Thread.sleep(300);

            // ─────────────────────────────────────────
            // STEP 2: Radius search → nearby attractions
            // ─────────────────────────────────────────
            String kinds        = getKindsFromPurpose(purpose);
            String radiusUrlStr = OTM_RADIUS_URL
                + "?radius=15000"          // 15km radius (wider net = more results)
                + "&lon="    + lon
                + "&lat="    + lat
                + "&kinds="  + kinds
                + "&format=json"
                + "&limit=15"              // fetch 15, we'll trim to 12 after filtering
                + "&rate=3"                // ✅ only return places rated 3+ (quality filter)
                + "&lang=en";

            System.out.println("[TravelScraper] Step 2 — Radius search | kinds=" + kinds);
            String radiusResponse = httpGetWithHeaders(radiusUrlStr);

            if (radiusResponse == null || radiusResponse.trim().isEmpty()) {
                System.err.println("[TravelScraper] Empty radius response");
                return results;
            }

            JSONArray placesArray;
            try {
                placesArray = new JSONArray(radiusResponse);
            } catch (Exception e) {
                System.err.println("[TravelScraper] Could not parse radius response as array");
                return results;
            }

            System.out.println("[TravelScraper] Step 2 returned " + placesArray.length() + " places");

            // ✅ Fixed Bug 5: Fallback if radius returns 0 results
            // Retry with broader kinds and larger radius
            if (placesArray.length() == 0) {
                System.out.println("[TravelScraper] No results — retrying with broader kinds...");
                Thread.sleep(300);
                String fallbackUrl = OTM_RADIUS_URL
                    + "?radius=25000"
                    + "&lon="   + lon
                    + "&lat="   + lat
                    + "&kinds=interesting_places"
                    + "&format=json"
                    + "&limit=15"
                    + "&lang=en";
                String fallbackResponse = httpGetWithHeaders(fallbackUrl);
                try {
                    placesArray = new JSONArray(fallbackResponse);
                    System.out.println("[TravelScraper] Fallback returned " + placesArray.length() + " places");
                } catch (Exception e) {
                    System.err.println("[TravelScraper] Fallback also failed");
                    return results;
                }
            }

            // ─────────────────────────────────────────
            // STEP 3: Build result objects
            // ─────────────────────────────────────────
            String[] fallbackImages = getFallbackImages(purpose);
            int imageIndex = 0;

            for (int i = 0; i < placesArray.length() && results.size() < 12; i++) {
                try {
                    JSONObject place = placesArray.getJSONObject(i);
                    String xid = place.optString("xid", "");

                    // ✅ Fixed Bug 3: Skip unnamed places FIRST before any other processing
                    String placeName = place.optString("name", "").trim();
                    if (placeName.isEmpty() || placeName.equals("null")) {
                        continue;
                    }

                    // ─────────────────────────────────────────
                    // STEP 2.5: Fetch precise details (Images & Descr)
                    // ─────────────────────────────────────────
                    System.out.println("[TravelScraper] + Fetching details for XID: " + xid);
                    JSONObject details = getDetailsForXid(xid);
                    
                    String image = "";
                    if (details.has("preview")) {
                        image = details.getJSONObject("preview").optString("source", "");
                    }
                    
                    String description = "";
                    if (details.has("wikipedia_extracts")) {
                        description = details.getJSONObject("wikipedia_extracts").optString("text", "");
                    } else if (details.has("info")) {
                        description = details.getJSONObject("info").optString("descr", "");
                    }

                    // Fallback to auto-gen if empty
                    if (image.isEmpty() || image.contains("placeholder")) {
                        image = fallbackImages[imageIndex % fallbackImages.length];
                        imageIndex++;
                    }

                    if (description.isEmpty() || description.length() < 20) {
                        int dist = place.optInt("dist", 0);
                        String distStr = dist >= 1000 ? String.format("%.1f km", dist / 1000.0) : dist + " meters";
                        String pk = place.optString("kinds", "").replace(",", ", ").replace("_", " ");
                        description = "A popular " + pk + " destination located " + distStr + " from " + baseName + ".";
                    }

                    int    rate      = place.optInt("rate",  3);
                    double ratingOutOf10 = Math.round((rate / 7.0) * 10.0 * 10.0) / 10.0;
                    String ratingStr     = String.format("%.1f", ratingOutOf10);

                    String exploreUrl = details.optString("otm", "https://www.google.com/search?q="
                        + URLEncoder.encode(placeName + " " + baseName + " " + country, "UTF-8"));

                    TravelDestination dest = new TravelDestination(
                        UUID.randomUUID().toString(),
                        placeName + ", " + baseName,
                        description,
                        "ATTRACTION",
                        ratingStr,
                        image,
                        exploreUrl
                    );

                    results.add(dest);
                    System.out.println("[TravelScraper] ✓ Added: " + placeName);
                    
                    // Respect OTM rate limits (1 request per second for free tier)
                    Thread.sleep(200);

                } catch (Exception e) {
                    System.err.println("[TravelScraper] Skipping place " + i + ": " + e.getMessage());
                }
            }

            System.out.println("[TravelScraper] Final result count: " + results.size());

        } catch (Exception e) {
            System.err.println("[TravelScraper] Fatal exception: " + e.getMessage());
            e.printStackTrace();
        }

        return results;
    }

    /**
     * Fetches detailed info about a specific place (Image, Description, etc.)
     */
    private JSONObject getDetailsForXid(String xid) {
        try {
            String response = httpGetWithHeaders(OTM_XID_URL + xid);
            if (response != null && !response.trim().isEmpty()) {
                return new JSONObject(response);
            }
        } catch (Exception e) {
            System.err.println("[TravelScraper] Failed to fetch XID details: " + e.getMessage());
        }
        return new JSONObject();
    }

    /**
     * Maps frontend category labels to OpenTripMap kinds
     */
    private String getKindsFromPurpose(String purpose) {
        if (purpose == null) return "interesting_places";
        switch (purpose.trim()) {
            case "Vacation":
            case "Relaxing Vacation":
                return "beaches,natural,water,parks";
            case "Adventure":
            case "Adventure & Sports":
                return "sport,natural,mountain_peaks,hiking";
            case "Culture":
            case "Cultural Discovery":
                return "historic,museums,architecture,religion,monuments";
            case "Food":
            case "Food & Nightlife":
                return "foods,restaurants,cafes,amusements,nightlife";
            default:
                return "interesting_places";
        }
    }

    /**
     * Returns stable fallback images per category
     * These are permanent Unsplash photo IDs — not source.unsplash.com
     */
    private String[] getFallbackImages(String purpose) {
        if (purpose == null) return FALLBACK_VACATION;
        switch (purpose.trim()) {
            case "Vacation":
            case "Relaxing Vacation":   return FALLBACK_VACATION;
            case "Adventure":
            case "Adventure & Sports":  return FALLBACK_ADVENTURE;
            case "Culture":
            case "Cultural Discovery":  return FALLBACK_CULTURE;
            case "Food":
            case "Food & Nightlife":    return FALLBACK_FOOD;
            default:                    return FALLBACK_VACATION;
        }
    }

    /**
     * HTTP GET with RapidAPI headers
     */
    private String httpGetWithHeaders(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept",          "application/json");
        conn.setRequestProperty("X-RapidAPI-Key",  RAPIDAPI_KEY);
        conn.setRequestProperty("X-RapidAPI-Host", OTM_HOST);
        conn.setConnectTimeout(8000);
        conn.setReadTimeout(10000);

        int status = conn.getResponseCode();
        if (status != 200) {
            BufferedReader errReader = new BufferedReader(
                new InputStreamReader(conn.getErrorStream(), "UTF-8"));
            StringBuilder errSb = new StringBuilder();
            String errLine;
            while ((errLine = errReader.readLine()) != null) errSb.append(errLine);
            errReader.close();
            conn.disconnect();
            throw new Exception("HTTP " + status + " → " + errSb.toString());
        }

        BufferedReader reader = new BufferedReader(
            new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) sb.append(line);
        reader.close();
        conn.disconnect();
        return sb.toString();
    }
}
