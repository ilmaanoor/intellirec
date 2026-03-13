<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - IntelliRec AI</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/global.css">
</head>
<body>
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
            <img id="user-avatar" src="https://ui-avatars.com/api/?background=F9A825&color=white&name=User" alt="Avatar">
            <a href="#" id="logout-btn" class="btn-logout-nav" title="Sign Out">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            </a>
        </div>
    </nav>

    <div class="page-header">
        <h1>What are you looking for today?</h1>
        <p>Select a category to get started with our real-time discovery engine.</p>
    </div>

    <div class="hero-grid-global" style="margin-top: 40px;">
        <a href="movies.jsp" class="hero-card">
            <div class="hero-card-icon">🎬</div>
            <h3>Movies</h3>
            <p>Blockbusters & hidden gems curated for you.</p>
        </a>
        <a href="songs.jsp" class="hero-card">
            <div class="hero-card-icon">🎵</div>
            <h3>Songs</h3>
            <p>The perfect soundtrack for your mood.</p>
        </a>
        <a href="gifts.jsp" class="hero-card">
            <div class="hero-card-icon">🎁</div>
            <h3>Gifts</h3>
            <p>Real-time scraper picks from top stores.</p>
        </a>
        <a href="travel.jsp" class="hero-card">
            <div class="hero-card-icon">✈️</div>
            <h3>Travel</h3>
            <p>Discover your next dream destination.</p>
        </a>
    </div>

    <footer class="footer-site" style="margin-top: 80px;">
        Powered by IntelliRec AI • Connected via Real-Time API
    </footer>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script>
        firebase.auth().onAuthStateChanged((user) => {
            if (user) {
                const name = user.displayName || user.email.split('@')[0];
                document.getElementById('user-avatar').src = `https://ui-avatars.com/api/?background=F9A825&color=white&bold=true&name=\${name}`;
            }
        });
    </script>
</body>
</html>
