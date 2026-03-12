<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IntelliRec AI - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #FFFDF2; /* Soft cream/yellow background */
            --primary: #F9A825; /* Warm orange/yellow */
            --text-dark: #4E342E; /* Dark brownish for text */
            --text-muted: #8D6E63;
            --input-bg: #F5F5F5;
            --card-shadow: 0 10px 40px rgba(0,0,0,0.05);
            --transition: all 0.3s ease;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg-color);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--text-dark);
        }

        .auth-card {
            background: white;
            width: 100%;
            max-width: 420px;
            padding: 40px;
            border-radius: 24px;
            box-shadow: var(--card-shadow);
            text-align: center;
            position: relative;
        }

        /* Top Icon */
        .brand-icon {
            width: 64px;
            height: 64px;
            background: var(--primary);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 20px;
            box-shadow: 0 4px 15px rgba(249, 168, 37, 0.3);
        }

        .brand-icon svg {
            width: 32px;
            height: 32px;
            fill: white;
        }

        .brand-name {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            color: var(--primary);
        }

        .brand-tagline {
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 30px;
        }

        /* Toggle System */
        .auth-toggle-container {
            background: #F0F0F0;
            padding: 5px;
            border-radius: 12px;
            display: flex;
            margin-bottom: 30px;
        }

        .auth-toggle-container button {
            flex: 1;
            padding: 10px;
            border: none;
            background: transparent;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            border-radius: 8px;
            transition: var(--transition);
            color: var(--text-muted);
        }

        .auth-toggle-container button.active {
            background: white;
            color: var(--primary);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        /* Form Styling */
        .form-group {
            text-align: left;
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-dark);
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            background: var(--input-bg);
            border: 1px solid transparent;
            border-radius: 10px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            transition: var(--transition);
        }

        .form-control:focus {
            outline: none;
            background: white;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(249, 168, 37, 0.1);
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(249, 168, 37, 0.4);
            filter: brightness(1.05);
        }

        .error-message {
            background: #FFEBEE;
            color: #C62828;
            padding: 10px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 20px;
            display: none;
        }

        /* Back to Home */
        .back-home {
            position: absolute;
            top: 20px;
            left: 20px;
            text-decoration: none;
            color: var(--text-muted);
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .back-home:hover { color: var(--primary); }

    </style>
</head>
<body>

    <a href="index.jsp" class="back-home">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        Home
    </a>

    <div class="auth-card">
        <div class="brand-icon">
            <svg viewBox="0 0 24 24">
                <path d="M12 2L14.5 9H22L16 14L18.5 21L12 17L5.5 21L8 14L2 9H9.5L12 2Z" />
            </svg>
        </div>

        <h1 class="brand-name">IntelliRec AI</h1>
        <p class="brand-tagline">Personalized recommendations for everything</p>

        <div class="auth-toggle-container">
            <button id="toggle-login" class="active">Login</button>
            <button id="toggle-register">Register</button>
        </div>

        <div id="auth-error" class="error-message"></div>

        <!-- Login Form -->
        <form id="login-form">
            <div class="form-group">
                <label for="login-email">Email</label>
                <input type="email" id="login-email" class="form-control" placeholder="Enter your email" required>
            </div>
            <div class="form-group">
                <label for="login-password">Password</label>
                <input type="password" id="login-password" class="form-control" placeholder="Enter your password" required>
            </div>
            <button type="submit" id="btn-login" class="btn-submit">Sign In</button>
        </form>

        <!-- Register Form -->
        <form id="register-form" style="display: none;">
            <div class="form-group">
                <label for="reg-email">Email</label>
                <input type="email" id="reg-email" class="form-control" placeholder="Enter your email" required>
            </div>
            <div class="form-group">
                <label for="reg-password">Password</label>
                <input type="password" id="reg-password" class="form-control" placeholder="Min 6 characters" required>
            </div>
            <button type="submit" id="btn-register" class="btn-submit">Sign Up</button>
        </form>
    </div>

    <!-- Firebase & Auth Dependencies -->
    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script>
        const toggleLogin = document.getElementById('toggle-login');
        const toggleRegister = document.getElementById('toggle-register');
        const loginForm = document.getElementById('login-form');
        const registerForm = document.getElementById('register-form');

        function switchToLogin() {
            toggleLogin.classList.add('active');
            toggleRegister.classList.remove('active');
            loginForm.style.display = 'block';
            registerForm.style.display = 'none';
        }

        function switchToRegister() {
            toggleRegister.classList.add('active');
            toggleLogin.classList.remove('active');
            registerForm.style.display = 'block';
            loginForm.style.display = 'none';
        }

        toggleLogin.addEventListener('click', switchToLogin);
        toggleRegister.addEventListener('click', switchToRegister);

        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('mode') === 'register') {
                switchToRegister();
            }
        });
    </script>
    <script src="js/auth.js"></script>
</body>
</html>