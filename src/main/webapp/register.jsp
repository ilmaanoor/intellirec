<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Register - IntelliRec</title>
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body>
        <div class="container" style="max-width: 500px; margin-top: 100px;">
            <div class="glass-panel">
                <h2 style="text-align: center;">Join IntelliRec</h2>
                <form id="register-form">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" id="name" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" id="email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" id="password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%;">Create Account</button>
                </form>
                <p style="text-align: center; margin-top: 1rem;">
                    Already have an account? <a href="login.jsp" style="color: #667eea;">Login</a>
                </p>
            </div>
        </div>

        <script src="js/firebase-app-compat.js"></script>
        <script src="js/firebase-auth-compat.js"></script>
        <script src="js/firebase-config.js"></script>
        <script>
            document.getElementById('register-form').addEventListener('submit', (e) => {
                e.preventDefault();
                const email = document.getElementById('email').value;
                const password = document.getElementById('password').value;

                auth.createUserWithEmailAndPassword(email, password)
                    .then((userCredential) => {
                        alert("Registration Successful!");
                        window.location.href = "dashboard.jsp";
                    })
                    .catch((error) => {
                        alert(error.message);
                    });
            });
        </script>
    </body>

    </html>