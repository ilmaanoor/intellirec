<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%
    // IntelliRec Movie API Proxy
    // Bypasses browser-side "Failed to fetch" errors by making requests from the server.
    
    String apiURL = "https://api.themoviedb.org/3/discover/movie";
    String queryString = request.getQueryString();
    
    if (queryString != null) {
        apiURL += "?" + queryString;
    }

    HttpURLConnection connection = null;
    try {
        URL url = new URL(apiURL);
        connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(5000);
        connection.setReadTimeout(5000);
        
        int responseCode = connection.getResponseCode();
        
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            out.print(content.toString());
        } else {
            response.setStatus(responseCode);
            out.print("{\"error\": \"Source API returned " + responseCode + "\"}");
        }
    } catch (Exception e) {
        response.setStatus(500);
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        String fullError = e.getClass().getName() + ": " + e.getMessage();
        out.print("{\"error\": \"Proxy failed: " + fullError.replace("\"", "\\\"") + "\"}");
    } finally {
        if (connection != null) {
            connection.disconnect();
        }
    }
%>
