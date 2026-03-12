<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Intellirec AI</title>
    <link rel="stylesheet" href="css/style_v1.css">
    <style>
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            font-weight: 600;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <a href="index.jsp" class="logo">Intelli<span>Rec</span></a>
            <nav class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="login.jsp">Login</a>
            </nav>
        </header>

        <div class="glass-panel">
            <h2 style="text-align: center; font-size: 2.5rem; margin-bottom: 2rem;">Join Us</h2>
            <div id="auth-error" class="error-message"></div>
            <form id="register-form">
                <div class="form-group">
                    <label for="reg-email">Email Address</label>
                    <input type="email" id="reg-email" class="form-control" placeholder="name@example.com" required>
                </div>
                <div class="form-group">
                    <label for="reg-password">Create Password</label>
                    <input type="password" id="reg-password" class="form-control" placeholder="Min 6 characters" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Create Account</button>
            </form>
            <p style="text-align: center; margin-top: 2rem; color: var(--text-muted);">
                Already have an account? <a href="login.jsp" style="color: var(--primary-dark); font-weight: 600;">Login here</a>
            </p>
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
</body>
</html>