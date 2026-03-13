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
 * TravelScraperEngine v3.0 — Wikipedia-Powered Destination Discovery
 *
 * Strategy:
 *  1. Wikipedia OpenSearch API  → get top matching article titles
 *  2. Wikipedia REST Summary    → get real description + thumbnail per title
 *  3. Filter to travel-relevant articles only (skip bios, companies, etc.)
 *  4. Fallback: Unsplash keyword images when Wikipedia has no thumbnail
 */
public class TravelScraperEngine {

    private static final String OPENSEARCH_URL =
        "https://en.wikipedia.org/w/api.php?action=opensearch&format=json&limit=20&search=";
    private static final String SUMMARY_URL =
        "https://en.wikipedia.org/api/rest_v1/page/summary/";
    private static final String WIKI_BASE =
        "https://en.wikipedia.org/wiki/";

    // Keywords that indicate an article IS a travel/place/food destination
    private static final String[] TRAVEL_KEYWORDS = {
        "city", "town", "village", "island", "beach", "mountain", "river", "lake",
        "valley", "forest", "park", "heritage", "temple", "palace", "castle", "fort",
        "museum", "ruins", "falls", "waterfall", "resort", "bay", "cape", "coast",
        "nation", "country", "province", "region", "district", "destination", "landmark",
        "attraction", "historical", "ancient", "national park", "cuisine", "food",
        "market", "restaurant", "plateau", "volcano", "archipelago", "peninsula",
        "sea", "ocean", "delta", "canyon", "glacier", "safari", "reserve"
    };

    // Descriptions / categories to SKIP (not travel-relevant)
    private static final String[] SKIP_KEYWORDS = {
        "disambiguation", "actor", "politician", "footballer", "cricketer",
        "singer", "rapper", "novelist", "philosopher", "mathematician",
        "corporation", "company", "software", "film", "album", "television",
        "record", "season", "episode", "series", "biography", "politician",
        "person born", "born in", "comedian", "director", "producer", "band",
        "songwriter", "musician born", "agreement", "treaty", "protocol",
        "mythology", "politics of", "economy of", "history of", "timeline of",
        "métro", "subway", "railway", "station", "airport", "team", "club",
        "university", "school", "college", "academy", "institute", "faculty",
        "olympics", "winter olympics", "summer olympics", "paralympics",
        "championship", "tournament", "cup", "games"
    };

    /**
     * Main entry point: searches Wikipedia for real travel destinations.
     * @param query   The user's search term or purpose keyword
     * @param purpose Travel purpose (Vacation, Adventure, Culture, Food)
     * @return List of up to 8 TravelDestination objects with real data
     */
    public List<TravelDestination> search(String query, String purpose) {
        List<TravelDestination> results = new ArrayList<>();

        // Step 1: Get top Wikipedia article titles via OpenSearch
        List<String> titles = openSearch(query);
        System.out.println("[TravelScraper] OpenSearch for \"" + query + "\" returned " + titles.size() + " titles");

        // Step 2: For each title, fetch full summary and filter by relevance
        for (String title : titles) {
            if (results.size() >= 8) break;
            try {
                TravelDestination dest = fetchSummary(title, purpose);
                if (dest != null) {
                    results.add(dest);
                    System.out.println("[TravelScraper] ✓ Added: " + title);
                } else {
                    System.out.println("[TravelScraper] ✗ Skipped (not travel): " + title);
                }
            } catch (Exception e) {
                System.err.println("[TravelScraper] Error fetching summary for '" + title + "': " + e.getMessage());
            }
        }

        // Step 3: If still not enough results, try a broader secondary search
        if (results.size() < 4) {
            System.out.println("[TravelScraper] Not enough results (" + results.size() + "), trying secondary search...");
            String fallbackQuery = buildFallbackQuery(query, purpose);
            List<String> moreTitles = openSearch(fallbackQuery);
            for (String title : moreTitles) {
                if (results.size() >= 8) break;
                try {
                    TravelDestination dest = fetchSummary(title, purpose);
                    if (dest != null && results.stream().noneMatch(r -> r.getName().equalsIgnoreCase(dest.getName()))) {
                        results.add(dest);
                        System.out.println("[TravelScraper] ✓ Added (secondary): " + title);
                    }
                } catch (Exception e) { /* skip */ }
            }
        }

        System.out.println("[TravelScraper] Final result count: " + results.size());
        return results;
    }

    /**
     * Calls Wikipedia OpenSearch and returns a list of matching article titles.
     */
    private List<String> openSearch(String query) {
        List<String> titles = new ArrayList<>();
        try {
            String encodedQuery = URLEncoder.encode(query, "UTF-8");
            String urlStr = OPENSEARCH_URL + encodedQuery;
            String response = httpGet(urlStr);

            // OpenSearch returns: [query, [titles], [descriptions], [urls]]
            JSONArray root = new JSONArray(response);
            JSONArray titleArray = root.getJSONArray(1);
            for (int i = 0; i < titleArray.length(); i++) {
                titles.add(titleArray.getString(i));
            }
        } catch (Exception e) {
            System.err.println("[TravelScraper] OpenSearch error: " + e.getMessage());
        }
        return titles;
    }

    /**
     * Fetches a Wikipedia REST summary for a given title.
     * Returns null if the article is not travel-relevant.
     */
    private TravelDestination fetchSummary(String title, String purpose) throws Exception {
        String encodedTitle = URLEncoder.encode(title.replace(" ", "_"), "UTF-8");
        String urlStr = SUMMARY_URL + encodedTitle;
        String response = httpGet(urlStr);

        JSONObject json = new JSONObject(response);

        // Check for API errors
        if (json.has("type") && json.getString("type").equals("https://mediawiki.org/wiki/HyperSwitch/errors/not_found")) {
            return null;
        }

        String description = json.optString("description", "");
        String extract = json.optString("extract", "");

        // Skip if this doesn't look like a place/destination
        if (!isTravelRelevant(title, description, extract)) {
            return null;
        }

        // Get the best available description (short extract preferred)
        String displayDescription = extract.length() > 250
            ? extract.substring(0, 250).trim() + "..."
            : extract;

        if (displayDescription.isEmpty()) {
            displayDescription = description.isEmpty()
                ? "A remarkable destination worth exploring."
                : description;
        }

        // Get image
        String imgUrl = "";
        if (json.has("thumbnail")) {
            JSONObject thumb = json.getJSONObject("thumbnail");
            imgUrl = thumb.optString("source", "");
        }
        if (imgUrl.isEmpty() || imgUrl.length() < 10) {
            // Fallback: Unsplash keyword image
            imgUrl = buildUnsplashUrl(title);
        }

        // Classify type based on description
        String type = classifyType(description, extract, purpose);

        // Generate rating
        String rating = String.format("%.1f", 4.0 + Math.random() * 1.0);

        // Wikipedia article link
        String wikiLink = WIKI_BASE + encodedTitle;
        // Also link to TripAdvisor for "Explore" button
        String exploreLink = "https://www.tripadvisor.com/Search?q=" + URLEncoder.encode(title, "UTF-8");

        return new TravelDestination(
            UUID.randomUUID().toString(),
            title,
            displayDescription,
            type,
            rating,
            imgUrl,
            exploreLink
        );
    }

    /**
     * Checks if a Wikipedia article is relevant to travel/destinations.
     */
    private boolean isTravelRelevant(String title, String description, String extract) {
        String combined = (title + " " + description + " " + extract).toLowerCase();

        // 1. Check title and description against explicitly blocked keywords
        for (String skip : SKIP_KEYWORDS) {
            if (combined.contains(skip)) {
                System.out.println("[TravelScraper] ! Blocked by skip keyword '" + skip + "': " + title);
                return false;
            }
        }

        // 2. Extra restriction: Title should not contain blocked keywords (case-insensitive)
        String lowerTitle = title.toLowerCase();
        String[] titleBlocks = {"agreement", "treaty", "protocol", "conference", "commune", "métro", "university", "department of", "ministry of", "politics of", "economy of", "history of"};
        for (String block : titleBlocks) {
            if (lowerTitle.contains(block)) {
                System.out.println("[TravelScraper] !! Blocked by title-keyword '" + block + "': " + title);
                return false;
            }
        }

        // 3. Then check if it hits any TRAVEL keyword
        for (String kw : TRAVEL_KEYWORDS) {
            if (combined.contains(kw)) return true;
        }

        // 4. Default skip
        return false;
    }

    /**
     * Classifies the destination type for display.
     */
    private String classifyType(String description, String extract, String purpose) {
        String combined = (description + " " + extract).toLowerCase();

        // 1. Broadest categories first (City/Country)
        if (combined.contains("officially the") && (combined.contains("country") || combined.contains("republic") || combined.contains("nation") || combined.contains("sovereign state")))
            return "COUNTRY DESTINATION";
        if (combined.contains("capital") || combined.contains("largest city") || combined.contains("metropolitan") || combined.contains("municipality"))
            return "CITY DESTINATION";
        
        // 2. Cultural/Historical
        if (combined.contains("temple") || combined.contains("palace") || combined.contains("heritage") || combined.contains("historical") || combined.contains("ancient"))
            return "HERITAGE SITE";

        // 3. Natural Landscapes
        if (combined.contains("mountain") || combined.contains("volcano") || combined.contains("trekking") || combined.contains("climbing"))
            return "MOUNTAIN & NATURE";
        if (combined.contains("waterfall") || combined.contains("lake") || combined.contains("river") || combined.contains("canyon") || combined.contains("glacier"))
            return "NATURAL WONDER";
        if (combined.contains("beach") || combined.contains("island") || combined.contains("resort"))
            return "BEACH & ISLAND";
        if (combined.contains("park") || combined.contains("forest") || combined.contains("wildlife") || combined.contains("safari") || combined.contains("reserve"))
            return "NATIONAL PARK";

        // 4. Activity based
        if (combined.contains("food") || combined.contains("cuisine") || combined.contains("market") || combined.contains("restaurant") || combined.contains("culinary"))
            return "FOOD & CULTURE";

        if (combined.contains("city") || combined.contains("town") || combined.contains("village"))
             return "CITY DESTINATION";

        // Fallback based on purpose
        switch (purpose) {
            case "Adventure": return "ADVENTURE SPOT";
            case "Culture": return "CULTURAL DESTINATION";
            case "Food": return "FOOD DESTINATION";
            default: return "TOP DESTINATION";
        }
    }

    /**
     * Builds a more specific secondary search query when primary returns few results.
     */
    private String buildFallbackQuery(String originalQuery, String purpose) {
        switch (purpose) {
            case "Adventure": return originalQuery + " national park trekking";
            case "Culture": return originalQuery + " historical heritage UNESCO";
            case "Food": return originalQuery + " cuisine food market";
            default: return originalQuery + " tourist attraction";
        }
    }

    /**
     * Builds an Unsplash URL using the location name as a keyword.
     */
    private String buildUnsplashUrl(String locationName) {
        String keyword = locationName.replace(" ", "-").toLowerCase();
        return "https://source.unsplash.com/800x600/?" + keyword + ",travel,destination";
    }

    /**
     * Performs a simple HTTP GET and returns the response body as a String.
     */
    private String httpGet(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        // Wikipedia requires a proper User-Agent
        conn.setRequestProperty("User-Agent", "IntelliRec-TravelBot/3.0 (educational project; contact@intellirec.app)");
        conn.setRequestProperty("Accept", "application/json");
        conn.setConnectTimeout(8000);
        conn.setReadTimeout(8000);

        int status = conn.getResponseCode();
        if (status != 200) {
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
