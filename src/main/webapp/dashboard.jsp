<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Dashboard - IntelliRec</title>
            <link rel="stylesheet" href="css/style.css">
        </head>

        <body>
            <div class="container">
                <header>
                    <div class="logo">IntelliRec</div>
                    <nav class="nav-links">
                        <a href="dashboard.jsp">Dashboard</a>
                        <a href="#" id="logout-btn">Logout</a>
                    </nav>
                </header>

                <div class="glass-panel">
                    <h2>Your Preferences</h2>
                    <p>What are you looking for today?</p>

                    <div class="grid">
                        <!-- Movie Preferences -->
                        <div class="card">
                            <h3>Explore Movies</h3>
                            <form action="getRecommendations" method="GET">
                                <input type="hidden" name="type" value="movie">
                                <div class="form-group">
                                    <select name="interest" class="form-control">
                                        <option value="Action">Action</option>
                                        <option value="Sci-Fi">Sci-Fi</option>
                                        <option value="Drama">Drama</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Get Movie Recs</button>
                            </form>
                        </div>

                        <!-- Song Preferences -->
                        <div class="card">
                            <h3>Listen to Music</h3>
                            <form action="getRecommendations" method="GET">
                                <input type="hidden" name="type" value="song">
                                <div class="form-group">
                                    <select name="interest" class="form-control">
                                        <option value="Happy">Happy</option>
                                        <option value="Sad">Sad</option>
                                        <option value="Chill">Chill</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Get Song Recs</button>
                            </form>
                        </div>

                        <!-- Gift Preferences -->
                        <div class="card">
                            <h3>Find a Gift</h3>
                            <form action="getRecommendations" method="GET">
                                <input type="hidden" name="type" value="gift">
                                <div class="form-group">
                                    <select name="interest" class="form-control">
                                        <option value="500-1000">₹500 - ₹1000</option>
                                        <option value="1000-2000">₹1000 - ₹2000</option>
                                        <option value="2000-5000">₹2000 - ₹5000</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Get Gift Recs</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <script src="js/firebase-app-compat.js"></script>
            <script src="js/firebase-auth-compat.js"></script>
            <script src="js/firebase-config.js"></script>
            <script>
                auth.onAuthStateChanged((user) => {
                    if (!user) {
                        window.location.href = "login.jsp";
                    }
                });

                document.getElementById('logout-btn').addEventListener('click', () => {
                    auth.signOut().then(() => {
                        window.location.href = "index.jsp";
                    });
                });
            </script>
        </body>

        </html>