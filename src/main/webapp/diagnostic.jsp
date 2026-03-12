<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>IntelliRec API Diagnostic</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #0f172a; color: #10b981; padding: 40px; line-height: 1.6; }
        .container { max-width: 900px; margin: 0 auto; background: #1e293b; padding: 30px; border-radius: 12px; border: 1px solid #334155; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); }
        .pass { color: #34d399; font-weight: bold; padding: 10px; background: rgba(52, 211, 153, 0.1); border-radius: 6px; border: 1px solid #34d399; }
        .fail { color: #f87171; font-weight: bold; padding: 10px; background: rgba(248, 113, 113, 0.1); border-radius: 6px; border: 1px solid #f87171; }
        pre { background: #0f172a; padding: 15px; border: 1px solid #334155; border-radius: 8px; overflow-x: auto; white-space: pre-wrap; word-wrap: break-word; color: #94a3b8; font-size: 13px; margin: 15px 0; }
        h1 { color: #f1f5f9; font-size: 24px; margin-bottom: 20px; border-bottom: 1px solid #334155; padding-bottom: 10px; }
        h2 { color: #cbd5e1; font-size: 18px; margin-top: 30px; margin-bottom: 10px; }
        .footer { margin-top: 40px; font-size: 12px; color: #64748b; border-top: 1px solid #334155; padding-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>IntelliRec API Health Check</h1>
        
        <%
            // Configuration
            String diagKey = "e226f4a5f5bace766952aa0d17182959";
            String diagMirror = "https://api.tmdb.org/3/discover/movie?api_key=" + diagKey + "&language=hi-IN&sort_by=popularity.desc&with_watch_providers=8&watch_region=IN";
            
            out.println("<h2>Testing Connectivity to api.tmdb.org</h2>");
            
            HttpURLConnection diagConn = null;
            try {
                // Using java.util.Date instead of System.currentTimeMillis to avoid weird compiler issues
                long diagStart = (new java.util.Date()).getTime();
                
                URL diagUrl = new URL(diagMirror);
                diagConn = (HttpURLConnection) diagUrl.openConnection();
                diagConn.setRequestMethod("GET");
                diagConn.setConnectTimeout(8000);
                diagConn.setReadTimeout(8000);
                
                int diagStatus = diagConn.getResponseCode();
                long diagEnd = (new java.util.Date()).getTime();
                
                if (diagStatus == 200) {
                    out.println("<div class='pass'>✅ SUCCESS: Reached mirror in " + (diagEnd - diagStart) + "ms.</div>");
                    
                    // Read content
                    InputStream diagIs = diagConn.getInputStream();
                    BufferedReader diagReader = new BufferedReader(new InputStreamReader(diagIs, "UTF-8"));
                    StringBuilder diagSb = new StringBuilder();
                    String diagLine;
                    while ((diagLine = diagReader.readLine()) != null) {
                        diagSb.append(diagLine);
                    }
                    diagReader.close();
                    
                    String diagOutput = diagSb.toString();
                    out.println("<h2>Data Sample (First 800 characters)</h2>");
                    out.println("<pre>" + (diagOutput.length() > 800 ? diagOutput.substring(0, 800) + "..." : diagOutput) + "</pre>");
                } else {
                    out.println("<div class='fail'>❌ FAILED: Server returned HTTP " + diagStatus + "</div>");
                    
                    // Try to read error stream
                    InputStream diagEs = diagConn.getErrorStream();
                    if (diagEs != null) {
                        BufferedReader diagErrReader = new BufferedReader(new InputStreamReader(diagEs));
                        out.println("<h2>Error Details from Mirror</h2>");
                        out.println("<pre>" + diagErrReader.readLine() + "</pre>");
                        diagErrReader.close();
                    }
                }
            } catch (Exception diagE) {
                out.println("<div class='fail'>❌ ERROR: Could not establish connection. </div>");
                out.println("<h2>Stacktrace</h2>");
                out.println("<pre>");
                diagE.printStackTrace(new java.io.PrintWriter(out));
                out.println("</pre>");
            } finally {
                if (diagConn != null) diagConn.disconnect();
            }
        %>
        
        <div class="footer">
            Generated on <%= new java.util.Date() %> | IntelliRec Diagnostic v1.2
        </div>
    </div>
</body>
</html>
