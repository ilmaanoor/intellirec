<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Authentication - Intellirec AI</title>
    <link rel="stylesheet" href="css/style_v1.css">
    <style>
        .auth-container {
            max-width: 450px;
            margin: 4rem auto;
            background: var(--bg-white);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
            border: 1px solid rgba(255, 215, 0, 0.2);
        }
        .auth-toggle {
            display: flex;
            margin-bottom: 2rem;
            border-bottom: 2px solid #EEE;
        }
        .auth-toggle button {
            flex: 1;
            padding: 1rem;
            background: transparent;
            border: none;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-muted);
            cursor: pointer;
            transition: var(--transition);
            position: relative;
        }
        .auth-toggle button.active {
            color: var(--primary-dark);
        }
        .auth-toggle button.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 3px;
            background: var(--primary-dark);
        }
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
            </nav>
        </header>

        <div class="auth-container">
            <h2 style="text-align: center; font-size: 2rem; margin-bottom: 1.5rem;">Join Intellirec</h2>
            
            <div class="auth-toggle">
                <button id="toggle-login" class="active">Login</button>
                <button id="toggle-register">Register</button>
            </div>

            <div id="auth-error" class="error-message"></div>

            <!-- Login Form -->
            <form id="login-form">
                <div class="form-group">
                    <label for="login-email">Email Address</label>
                    <input type="email" id="login-email" class="form-control" placeholder="name@example.com" required>
                </div>
                <div class="form-group">
                    <label for="login-password">Password</label>
                    <input type="password" id="login-password" class="form-control" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Login Now</button>
            </form>

            <!-- Register Form -->
            <form id="register-form" style="display: none;">
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
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script>
        // UI Toggle Logic
        const toggleLogin = document.getElementById('toggle-login');
        const toggleRegister = document.getElementById('toggle-register');
        const loginForm = document.getElementById('login-form');
        const registerForm = document.getElementById('register-form');
        const errorMsg = document.getElementById('auth-error');

        function hideError() {
            errorMsg.style.display = 'none';
            errorMsg.innerText = '';
        }

        function showError(msg) {
            errorMsg.innerText = msg;
            errorMsg.style.display = 'block';
        }

        function switchToLogin() {
            toggleLogin.classList.add('active');
            toggleRegister.classList.remove('active');
            loginForm.style.display = 'block';
            registerForm.style.display = 'none';
            hideError();
        }

        function switchToRegister() {
            toggleRegister.classList.add('active');
            toggleLogin.classList.remove('active');
            registerForm.style.display = 'block';
            loginForm.style.display = 'none';
            hideError();
        }

        toggleLogin.addEventListener('click', switchToLogin);
        toggleRegister.addEventListener('click', switchToRegister);

        // Check for mode in URL
        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('mode') === 'register') {
                switchToRegister();
            }
        });

        // Validation Helpers
        function validateEmail(email) {
            return String(email)
                .toLowerCase()
                .match(
                    /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
                );
        }

        // Firebase Logic
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            hideError();
            
            const email = document.getElementById('login-email').value.trim();
            const password = document.getElementById('login-password').value;

            // Client-side validation
            if (!email) {
                showError("Please enter your email address.");
                return;
            }
            if (!validateEmail(email)) {
                showError("Please enter a valid email address.");
                return;
            }
            if (!password) {
                showError("Please enter your password.");
                return;
            }

            firebase.auth().signInWithEmailAndPassword(email, password)
                .then(() => { window.location.href = 'intro.jsp'; })
                .catch(err => { 
                    if (err.code === 'auth/user-not-found' || err.code === 'auth/invalid-credential') {
                        showError("User not found or incorrect password. Please try again.");
                    } else if (err.code === 'auth/wrong-password') {
                        showError("Incorrect password. Please try again.");
                    } else if (err.code === 'auth/invalid-email') {
                        showError("The email address is badly formatted.");
                    } else {
                        showError(err.message); 
                    }
                });
        });

        registerForm.addEventListener('submit', (e) => {
            e.preventDefault();
            hideError();
            
            const email = document.getElementById('reg-email').value.trim();
            const password = document.getElementById('reg-password').value;

            // Client-side validation
            if (!email) {
                showError("Email address is required.");
                return;
            }
            if (!validateEmail(email)) {
                showError("Please enter a valid email address.");
                return;
            }
            if (!password) {
                showError("Password is required.");
                return;
            }
            if (password.length < 6) {
                showError("Password must be at least 6 characters long.");
                return;
            }

            firebase.auth().createUserWithEmailAndPassword(email, password)
                .then(() => { window.location.href = 'intro.jsp'; })
                .catch(err => {
                    if (err.code === 'auth/email-already-in-use') {
                        showError("This email is already in use. Please log in.");
                    } else if (err.code === 'auth/weak-password') {
                        showError("Password should be at least 6 characters.");
                    } else if (err.code === 'auth/invalid-email') {
                        showError("Please provide a valid email address.");
                    } else {
                        showError(err.message);
                    }
                });
        });
    </script>
</body>
</html>