<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Login - IntelliRec</title>
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body>
        <div class="container" style="max-width: 500px; margin-top: 100px;">
            <div class="glass-panel">
                <h2 style="text-align: center;">Welcome Back</h2>
                <form id="login-form">
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" id="email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" id="password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%;">Login</button>
                </form>
                <p style="text-align: center; margin-top: 1rem;">
                    Don't have an account? <a href="register.jsp" style="color: #667eea;">Register</a>
                </p>
            </div>
        </div>

        <script src="js/firebase-app-compat.js"></script>
        <script src="js/firebase-auth-compat.js"></script>
        <script src="js/firebase-config.js"></script>
        <script>
            document.getElementById('login-form').addEventListener('submit', (e) => {
                e.preventDefault();
                const email = document.getElementById('email').value;
                const password = document.getElementById('password').value;

                auth.signInWithEmailAndPassword(email, password)
                    .then((userCredential) => {
                        window.location.href = "dashboard.jsp";
                    })
                    .catch((error) => {
                        alert(error.message);
                    });
            });
        </script>
    </body>

    </html>