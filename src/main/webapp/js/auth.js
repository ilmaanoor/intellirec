// Firebase Auth handling for Intellirec AI
document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    const logoutBtn = document.getElementById('logout-btn');
    const errorMsg = document.getElementById('auth-error');

    function showError(msg) {
        if (errorMsg) {
            errorMsg.innerText = msg;
            errorMsg.style.display = 'block';
        } else {
            alert(msg);
        }
    }

    function hideError() {
        if (errorMsg) {
            errorMsg.style.display = 'none';
            errorMsg.innerText = '';
        }
    }

    function validateEmail(email) {
        return String(email)
            .toLowerCase()
            .match(
                /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            );
    }

    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            hideError();
            
            // Get values using the IDs present in login.jsp
            const emailField = document.getElementById('login-email') || document.getElementById('email');
            const passwordField = document.getElementById('login-password') || document.getElementById('password');
            
            const email = emailField.value.trim();
            const password = passwordField.value;

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
    }

    if (registerForm) {
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
    }

    if (logoutBtn) {
        logoutBtn.addEventListener('click', (e) => {
            e.preventDefault();
            firebase.auth().signOut().then(() => {
                window.location.href = 'login.jsp';
            });
        });
    }
});
