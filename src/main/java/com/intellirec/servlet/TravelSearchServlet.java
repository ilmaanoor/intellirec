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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        String purpose = request.getParameter("purpose");

        // Construct search term based on purpose if query is empty
        if (query == null || query.trim().isEmpty()) {
            query = (purpose != null) ? purpose : "Travel Destinations";
        }

        System.out.println("[TravelServlet] Searching for: " + query);

        List<TravelDestination> destinations = scraperEngine.searchTripAdvisor(query);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        JSONArray jsonArray = new JSONArray();

        for (TravelDestination dest : destinations) {
            JSONObject json = new JSONObject();
            json.put("id", dest.getId());
            json.put("place", dest.getName());
            json.put("description", dest.getDescription());
            json.put("type", dest.getType());
            json.put("rating", dest.getRating());
            json.put("img", dest.getImg());
            json.put("tripadvisorUrl", dest.getTripadvisorUrl());
            jsonArray.put(json);
        }

        out.print(jsonArray.toString());
        out.flush();
    }
}
