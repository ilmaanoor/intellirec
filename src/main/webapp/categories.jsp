<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Categories - Intellirec AI</title>
    <link rel="stylesheet" href="css/style_v1.css">
</head>
<body>
    <div class="container">
        <header>
            <a href="index.jsp" class="logo">Intelli<span>Rec</span></a>
            <nav class="nav-links">
                <a href="intro.jsp">Back</a>
                <a href="#" id="logout-btn">Logout</a>
            </nav>
        </header>

        <section class="hero" style="padding: 2rem 0;">
            <h1 style="font-size: 3rem;">What are you looking for today?</h1>
            <p>Select a category to get started with AI magic.</p>
        </section>

        <div class="grid">
            <a href="movies.jsp" class="category-card">
                <span class="icon">🎬</span>
                <h3>Movies</h3>
                <p>Blockbusters & hidden gems curated for you.</p>
            </a>
            <a href="songs.jsp" class="category-card">
                <span class="icon">🎵</span>
                <h3>Songs</h3>
                <p>The perfect soundtrack for your mood.</p>
            </a>
            <a href="gifts.jsp" class="category-card">
                <span class="icon">🎁</span>
                <h3>Gifts</h3>
                <p>Find the perfect gift for your loved ones.</p>
            </a>
            <a href="travel.jsp" class="category-card">
                <span class="icon">✈️</span>
                <h3>Travel</h3>
                <p>Discover your next dream destination.</p>
            </a>
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
</body>
</html>
