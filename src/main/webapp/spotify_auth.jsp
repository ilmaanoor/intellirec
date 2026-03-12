<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, java.util.*, java.util.Base64" %>
<%
    // Spotify Auth Proxy - Client Credentials Flow
    
    // IMPORTANT: Replace with your actual credentials from https://developer.spotify.com/dashboard
    String client_id = "YOUR_SPOTIFY_CLIENT_ID"; 
    String client_secret = "YOUR_SPOTIFY_CLIENT_SECRET";
    
    if ("YOUR_SPOTIFY_CLIENT_ID".equals(client_id)) {
        out.print("{\"error\": \"Spotify Credentials missing in spotify_auth.jsp\"}");
        return;
    }

    String auth = client_id + ":" + client_secret;
    String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes("UTF-8"));

    HttpURLConnection conn = null;
    try {
        URL url = new URL("https://accounts.spotify.com/api/token");
        conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        String data = "grant_type=client_credentials";
        OutputStream os = conn.getOutputStream();
        os.write(data.getBytes("UTF-8"));
        os.flush();
        os.close();

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            out.print(content.toString());
        } else {
            out.print("{\"error\": \"Spotify Auth failed with code " + responseCode + "\"}");
        }
    } catch (Exception e) {
        out.print("{\"error\": \"Exception: " + e.getMessage() + "\"}");
    } finally {
        if (conn != null) conn.disconnect();
    }
%>
