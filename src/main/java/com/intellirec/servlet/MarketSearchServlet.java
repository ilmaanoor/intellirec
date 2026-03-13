package com.intellirec.servlet;

import com.intellirec.model.ScrapedProduct;
import com.intellirec.scraper.ScraperEngine;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/market-search")
public class MarketSearchServlet extends HttpServlet {
    private final ScraperEngine engine = new ScraperEngine();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (query == null || query.trim().isEmpty()) {
            out.print("{\"error\": \"Empty query\"}");
            return;
        }

        try {
            Map<String, List<ScrapedProduct>> results = engine.scrapeMarketByPlatform(query);
            JSONObject root = new JSONObject();
            
            for (Map.Entry<String, List<ScrapedProduct>> entry : results.entrySet()) {
                JSONArray list = new JSONArray();
                for (ScrapedProduct p : entry.getValue()) {
                    JSONObject item = new JSONObject();
                    item.put("title", p.getTitle());
                    item.put("price", p.getPrice());
                    item.put("mrp", p.getMrp());
                    item.put("source", p.getSource());
                    item.put("url", p.getProductUrl());
                    item.put("img", p.getImg());
                    list.put(item);
                }
                root.put(entry.getKey(), list);
            }
            out.print(root.toString());
        } catch (Exception e) {
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
