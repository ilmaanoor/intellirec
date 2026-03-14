<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%
    // IntelliRec Universal API Proxy v4.0 (Robust)
    String proxy_targetUrl = request.getParameter("targetUrl");
    if (proxy_targetUrl == null || proxy_targetUrl.isEmpty()) {
        proxy_targetUrl = "https://api.tmdb.org/3/discover/movie?" + request.getQueryString();
    }

    // CORS preflight
    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, X-RapidAPI-Key, X-RapidAPI-Host, Authorization");
        response.setStatus(HttpServletResponse.SC_OK);
        return;
    }

    HttpURLConnection proxy_conn = null;
    try {
        URL proxy_url = new URL(proxy_targetUrl);
        proxy_conn = (HttpURLConnection) proxy_url.openConnection();
        proxy_conn.setRequestMethod("GET");
        proxy_conn.setConnectTimeout(10000);
        proxy_conn.setReadTimeout(10000);
        proxy_conn.setRequestProperty("User-Agent", "Mozilla/5.0");
        
        // Forward critical headers
        String[] proxy_headers = {"X-RapidAPI-Key", "X-RapidAPI-Host", "Authorization"};
        for (String h : proxy_headers) {
            String val = request.getHeader(h);
            if (val != null) {
                proxy_conn.setRequestProperty(h, val);
            }
        }
        
        int proxy_status = proxy_conn.getResponseCode();
        if (proxy_status < 400) {
            BufferedReader proxy_in = new BufferedReader(new InputStreamReader(proxy_conn.getInputStream(), "UTF-8"));
            String proxy_inputLine;
            StringBuilder proxy_responseBody = new StringBuilder();
            while ((proxy_inputLine = proxy_inputLine = proxy_in.readLine()) != null) {
                proxy_responseBody.append(proxy_inputLine);
            }
            proxy_in.close();
            response.setStatus(proxy_status);
            out.print(proxy_responseBody.toString());
        } else {
            response.setStatus(proxy_status);
            out.print("{\"error\": \"Proxy target returned " + proxy_status + "\"}");
        }
    } catch (Exception proxy_err) {
        response.setStatus(500);
        out.print("{\"error\": \"Proxy technical failure: " + proxy_err.getMessage() + "\"}");
    } finally {
        if (proxy_conn != null) proxy_conn.disconnect();
    }
%>
