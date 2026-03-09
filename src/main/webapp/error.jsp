<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Error - IntelliRec</title>
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body>
        <div class="container" style="text-align: center; margin-top: 100px;">
            <div class="glass-panel">
                <h1>Oops! Something went wrong.</h1>
                <p>We encountered a server error. Please try again later.</p>
                <p style="color: #ff4d4d;">${exception}</p>
                <a href="dashboard.jsp" class="btn btn-primary">Back to Dashboard</a>
            </div>
        </div>
    </body>

    </html>