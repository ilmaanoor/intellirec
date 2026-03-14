<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - IntelliRec AI</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;800&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="admin-body">

    <!-- Global Nav -->
    <nav class="navbar-global">
        <a href="index.jsp" class="nav-brand">Intelli<span>Rec AI</span></a>
        <ul class="nav-links-global">
            <li><a href="intro.jsp">Home</a></li>
            <li><a href="movies.jsp">Movies</a></li>
            <li><a href="songs.jsp">Songs</a></li>
            <li><a href="gifts.jsp">Gifts</a></li>
            <li><a href="travel.jsp">Travel</a></li>
        </ul>
        <div class="nav-user">
            <img id="user-avatar" src="https://ui-avatars.com/api/?background=F9A825&color=white&name=Admin" alt="Avatar">
            <a href="#" id="logout-btn" class="btn-logout-nav" title="Sign Out">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            </a>
        </div>
    </nav>

    <div class="admin-container">
        <div class="admin-header">
            <div>
                <h1>Control Center</h1>
                <p>Monitor system health, discovery metrics, and platform performance.</p>
            </div>
            <button id="run-diagnostics" class="btn-primary-site">
                <i class="fa-solid fa-bolt-lightning"></i> Run System Check
            </button>
        </div>

        <div class="admin-grid">
            
            <!-- System Health Card -->
            <div class="admin-card glass-card">
                <div class="card-header">
                    <h3><i class="fa-solid fa-heart-pulse"></i> System Health</h3>
                    <span id="overall-status" class="status-badge status-good">Operational</span>
                </div>
                <ul class="health-list">
                    <li id="status-tmdb">
                        <span>TMDB API</span>
                        <span class="dot dot-unknown"></span>
                    </li>
                    <li id="status-otm">
                        <span>OpenTripMap</span>
                        <span class="dot dot-unknown"></span>
                    </li>
                    <li id="status-servlets">
                        <span>Backend Servlets</span>
                        <span class="dot dot-unknown"></span>
                    </li>
                    <li id="status-scrapers">
                        <span>Scraper Engine</span>
                        <span class="dot dot-unknown"></span>
                    </li>
                </ul>
            </div>

            <!-- Discovery Metrics Card -->
            <div class="admin-card glass-card">
                <div class="card-header">
                    <h3><i class="fa-solid fa-chart-line"></i> Discovery Metrics</h3>
                </div>
                <div class="metrics-grid">
                    <div class="metric-item">
                        <span class="metric-label">Travel Searches</span>
                        <span id="metric-travel-count" class="metric-value">0</span>
                    </div>
                    <div class="metric-item">
                        <span class="metric-label">API Budget Used</span>
                        <span id="metric-budget-percent" class="metric-value">0%</span>
                    </div>
                    <div class="metric-item">
                        <span class="metric-label">Active Sessions</span>
                        <span class="metric-value">1</span>
                    </div>
                </div>
            </div>

            <!-- Diagnostic Console -->
            <div class="admin-card glass-card console-card">
                <div class="card-header">
                    <h3><i class="fa-solid fa-terminal"></i> Live Diagnostic Console</h3>
                    <button class="text-btn" onclick="clearConsole()">Clear</button>
                </div>
                <div id="admin-console" class="admin-console">
                    <div class="log-entry log-info">[System] Initializing admin dashboard...</div>
                    <div class="log-entry log-info">[Auth] Verifying administrator session...</div>
                </div>
            </div>

        </div>
    </div>

    <footer class="footer-site">
        IntelliRec Admin v1.0 • Built with Intelligence
    </footer>

    <!-- Scripts -->
    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js"></script>
    <script src="js/admin.js"></script>

</body>
</html>
