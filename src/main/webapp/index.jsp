<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>IntelliRec - AI Recommendations</title>
        <link rel="stylesheet" href="css/style.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    </head>

    <body>
        <div class="container">
            <header>
                <div class="logo">IntelliRec</div>
                <nav class="nav-links">
                    <a href="index.jsp">Home</a>
                    <a href="login.jsp" id="auth-link">Login</a>
                    <a href="#" id="logout-btn" style="display:none;">Logout</a>
                </nav>
            </header>

            <section class="hero">
                <h1>Personalized AI Recommendations <br> For Everything.</h1>
                <p>Movies, Songs, Gifts and more - all in one place.</p>
                <div style="margin-top: 2rem;">
                    <a href="register.jsp" class="btn btn-primary">Get Started</a>
                </div>
            </section>

            <div class="grid">
                <div class="card">
                    <h3>🎬 Movies</h3>
                    <p>Top hits based on your favorite genres.</p>
                </div>
                <div class="card">
                    <h3>🎵 Songs</h3>
                    <p>Personalized playlists for your every mood.</p>
                </div>
                <div class="card">
                    <h3>🎁 Gifts</h3>
                    <p>The perfect gift for every occasion and budget.</p>
                </div>
            </div>
        </div>

        <!-- Local Firebase SDKs -->
        <script src="js/firebase-app-compat.js"></script>
        <script src="js/firebase-auth-compat.js"></script>
        <script src="js/firebase-config.js"></script>
        <script src="js/auth.js"></script>
    </body>

    </html>