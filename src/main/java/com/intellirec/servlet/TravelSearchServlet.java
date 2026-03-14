package com.intellirec.servlet;

import com.intellirec.model.TravelDestination;
import com.intellirec.scraper.TravelScraperEngine;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/travel-search")
public class TravelSearchServlet extends HttpServlet {

    private final TravelScraperEngine scraperEngine = new TravelScraperEngine();

    private static final java.util.Map<String, String[]> PURPOSE_CITY_MAP = new java.util.HashMap<>();
    static {
        PURPOSE_CITY_MAP.put("Relaxing Vacation", new String[]{"Maldives", "Bora Bora", "Seychelles", "Fiji", "Mykonos", "Maui"});
        PURPOSE_CITY_MAP.put("Adventure & Sports", new String[]{"Queenstown", "Chamonix", "Banff", "Patagonia", "Zermatt", "Moab"});
        PURPOSE_CITY_MAP.put("Cultural Discovery", new String[]{"Rome", "Kyoto", "Athens", "Cairo", "Petra", "Istanbul"});
        PURPOSE_CITY_MAP.put("Food & Nightlife", new String[]{"Tokyo", "Bangkok", "Osaka", "New Orleans", "Barcelona", "Mumbai"});
    }

    private static String purposeToQuery(String purpose) {
        if (purpose == null) return "famous travel destinations";
        String trimmed = purpose.trim();
        String[] cities = PURPOSE_CITY_MAP.get(trimmed);
        
        // Handle legacy or unknown categories
        if (cities == null) {
            if (trimmed.equals("Adventure")) cities = PURPOSE_CITY_MAP.get("Adventure & Sports");
            else if (trimmed.equals("Culture")) cities = PURPOSE_CITY_MAP.get("Cultural Discovery");
            else if (trimmed.equals("Food")) cities = PURPOSE_CITY_MAP.get("Food & Nightlife");
            else if (trimmed.equals("Vacation")) cities = PURPOSE_CITY_MAP.get("Relaxing Vacation");
        }

        if (cities != null && cities.length > 0) {
            return cities[new java.util.Random().nextInt(cities.length)];
        }
        return "popular travel destinations";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Allow CORS for local dev
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String query   = request.getParameter("query");
        String purpose = request.getParameter("purpose");

        // Build effective search term
        String effectiveQuery;
        if (query != null && !query.trim().isEmpty() && !query.trim().equalsIgnoreCase(purpose)) {
            // User typed something specific — use it directly
            effectiveQuery = query.trim();
        } else {
            // Only a purpose filter was provided — build a smart query from it
            effectiveQuery = purposeToQuery(purpose);
        }

        System.out.println("[TravelServlet] PURPOSE=" + purpose + " | EFFECTIVE QUERY=" + effectiveQuery);

        List<TravelDestination> destinations = scraperEngine.search(effectiveQuery, purpose != null ? purpose : "Vacation");

        PrintWriter out = response.getWriter();
        JSONArray jsonArray = new JSONArray();

        for (TravelDestination dest : destinations) {
            JSONObject json = new JSONObject();
            json.put("id",            dest.getId());
            json.put("place",         dest.getName());
            json.put("description",   dest.getDescription());
            json.put("type",          dest.getType());
            json.put("rating",        dest.getRating());
            json.put("img",           dest.getImg());
            json.put("tripadvisorUrl", dest.getTripadvisorUrl());
            jsonArray.put(json);
        }

        out.print(jsonArray.toString());
        out.flush();
    }
}
