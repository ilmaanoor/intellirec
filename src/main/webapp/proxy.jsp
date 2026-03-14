<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%
    // IntelliRec Movie API Proxy v2.0
    // Simplified, unique variable names to avoid JSP collisions.
    
    // IntelliRec Universal API Proxy v3.0
    // Can proxy any URL to avoid CORS and bypass network restrictions.
    
    String targetUrl = request.getParameter("targetUrl");
    String proxy_apiURL;
    
    if (targetUrl != null && !targetUrl.isEmpty()) {
        proxy_apiURL = targetUrl;
        // Append existing query string if not already part of targetUrl
        String proxy_qs = request.getQueryString();
        if (proxy_qs != null && !proxy_qs.contains("targetUrl=")) {
            // This logic might be tricky if targetUrl itself has params. 
            // Better to assume targetUrl is fully qualified or handle carefully.
        }
    } else {
        // Default to TMDB Discover for backwards compatibility
        proxy_apiURL = "https://api.tmdb.org/3/discover/movie";
        String proxy_qs = request.getQueryString();
        if (proxy_qs != null) {
            proxy_apiURL += "?" + proxy_qs;
        }
    }

    // CORS and OPTIONS handling
    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, X-RapidAPI-Key, X-RapidAPI-Host, Authorization");
        response.setStatus(HttpServletResponse.SC_OK);
        return;
    }

    HttpURLConnection proxy_conn = null;
    try {
        System.out.println("[Proxy] Fetching: " + proxy_apiURL);
        URL proxy_url = new URL(proxy_apiURL);
        proxy_conn = (HttpURLConnection) proxy_url.openConnection();
        proxy_conn.setRequestMethod("GET");
        proxy_conn.setConnectTimeout(15000);
        proxy_conn.setReadTimeout(15000);
        proxy_conn.setRequestProperty("User-Agent", "Mozilla/5.0");
        
        // Forward headers
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String name = headerNames.nextElement();
            if (name.equalsIgnoreCase("X-RapidAPI-Key") || name.equalsIgnoreCase("X-RapidAPI-Host") || name.equalsIgnoreCase("Authorization")) {
                proxy_conn.setRequestProperty(name, request.getHeader(name));
                System.out.println("[Proxy] Forwarding Header: " + name);
            }
        }
        
        int proxy_code = proxy_conn.getResponseCode();
        System.out.println("[Proxy] Response: " + proxy_code);

        
        if (proxy_code == HttpURLConnection.HTTP_OK || proxy_code == HttpURLConnection.HTTP_CREATED) {
            BufferedReader proxy_reader = new BufferedReader(new InputStreamReader(proxy_conn.getInputStream(), "UTF-8"));
            String proxy_line;
            StringBuilder proxy_content = new StringBuilder();
            while ((proxy_line = proxy_reader.readLine()) != null) {
                proxy_content.append(proxy_line);
            }
            proxy_reader.close();
            out.print(proxy_content.toString());
        } else {
            out.print("{\"error\": \"Source API returned " + proxy_code + "\", \"url\": \"" + proxy_apiURL + "\"}");
        }
    } catch (Exception proxy_e) {
        String proxy_err = proxy_e.getClass().getName() + ": " + proxy_e.getMessage();
        out.print("{\"error\": \"Proxy exception: " + proxy_err.replace("\"", "\\\"") + "\"}");
    } finally {
        if (proxy_conn != null) {
            proxy_conn.disconnect();
        }
    }
%>
