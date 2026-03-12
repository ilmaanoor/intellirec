<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Intellirec AI - Universal Recommendation Platform</title>
    <link rel="stylesheet" href="css/style_v1.css">
</head>
<body>
    <div class="container">
        <header>
            <a href="index.jsp" class="logo">Intelli<span>Rec</span></a>
            <nav class="nav-links">
                <a href="login.jsp" id="auth-link">Login</a>
                <a href="login.jsp?mode=register" class="btn-primary" style="padding: 0.5rem 1.5rem; border-radius: 10px;">Sign Up</a>
            </nav>
        </header>

        <section class="hero">
            <h1>Personalized AI <br> Recommendations For <span>Everything</span>.</h1>
            <p>Movies, Songs, Gifts and more - all in one place. Experience discovery like never before.</p>
            <div style="margin-top: 3rem;">
                <a href="login.jsp?mode=register" class="btn btn-primary">Get Started Now</a>
            </div>
        </section>

        <div class="grid">
            <div class="category-card" style="cursor: default;">
                <span class="icon">🎬</span>
                <h3>Movies</h3>
                <p>Top hits based on your favorite genres.</p>
            </div>
            <div class="category-card" style="cursor: default;">
                <span class="icon">🎵</span>
                <h3>Songs</h3>
                <p>Personalized playlists for your mood.</p>
            </div>
            <div class="category-card" style="cursor: default;">
                <span class="icon">🎁</span>
                <h3>Gifts</h3>
                <p>The perfect gift for every occasion.</p>
            </div>
            <div class="category-card" style="cursor: default;">
                <span class="icon">✈️</span>
                <h3>Travel</h3>
                <p>Discover your next dream destination.</p>
            </div>
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script>
        firebase.auth().onAuthStateChanged((user) => {
            if (user) {
                window.location.href = 'intro.jsp';
            }
        });
    </script>
</body>
</html>