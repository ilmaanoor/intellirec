<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Recommendations - IntelliRec</title>
            <link rel="stylesheet" href="css/style.css">
        </head>

        <body>
            <div class="container">
                <header>
                    <div class="logo">IntelliRec</div>
                    <nav class="nav-links">
                        <a href="dashboard.jsp">Back to Dashboard</a>
                    </nav>
                </header>

                <h2>Top ${type} Recommendations for You</h2>

                <div class="grid">
                    <c:forEach var="item" items="${recommendations}">
                        <div class="card">
                            <!-- Dynamic rendering based on type -->
                            <c:choose>
                                <c:when test="${type == 'movie'}">
                                    <h3>${item.title}</h3>
                                    <p>Genre: ${item.genre}</p>
                                    <p class="rating">⭐ ${item.rating}</p>
                                </c:when>
                                <c:when test="${type == 'song'}">
                                    <h3>${item.title}</h3>
                                    <p>Artist: ${item.artist}</p>
                                    <p>Mood: ${item.mood}</p>
                                </c:when>
                                <c:when test="${type == 'gift'}">
                                    <h3>${item.name}</h3>
                                    <p>Category: ${item.category}</p>
                                    <p>Age Group: ${item.ageGroup}</p>
                                    <span class="btn btn-primary" style="font-size:0.8rem;">${item.priceRange}</span>
                                </c:when>
                            </c:choose>
                        </div>
                    </c:forEach>
                    <c:if test="${empty recommendations}">
                        <p>No recommendations found for this preference. Try another!</p>
                    </c:if>
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
            </script>
        </body>

        </html>