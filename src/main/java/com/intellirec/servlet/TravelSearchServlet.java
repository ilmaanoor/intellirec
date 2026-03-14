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

    // Maps "purpose" dropdown value → smart Wikipedia search term
    private static String purposeToQuery(String purpose) {
        if (purpose == null) return "famous travel destinations";
        switch (purpose.trim()) {
            case "Adventure":
            case "Adventure & Sports":  return "adventure travel destinations";
            case "Culture":
            case "Cultural Discovery":  return "world heritage sites";
            case "Food":
            case "Food & Nightlife":    return "culinary tourism destinations";
            case "Vacation":
            case "Relaxing Vacation":   return "popular travel destinations";
            default:                    return "popular travel destinations";
        }
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
