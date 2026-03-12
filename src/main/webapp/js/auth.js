// Firebase Auth handling for Intellirec AI
document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    const logoutBtn = document.getElementById('logout-btn');

    function showError(msg) {
        const errorMsg = document.getElementById('auth-error');
        if (errorMsg) {
            errorMsg.innerText = msg;
            errorMsg.style.display = 'block';
        } else {
            alert(msg);
        }
    }

    function hideError() {
        const errorMsg = document.getElementById('auth-error');
        if (errorMsg) {
            errorMsg.style.display = 'none';
            errorMsg.innerText = '';
        }
    }

    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            hideError();
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            firebase.auth().signInWithEmailAndPassword(email, password)
                .then(() => { window.location.href = 'intro.jsp'; })
                .catch(err => {
                    if (err.code === 'auth/user-not-found') {
                        showError("User is not registered. Please sign up first.");
                    } else if (err.code === 'auth/wrong-password') {
                        showError("Incorrect password. Please try again.");
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
            const email = document.getElementById('reg-email').value;
            const password = document.getElementById('reg-password').value;
            firebase.auth().createUserWithEmailAndPassword(email, password)
                .then(() => { window.location.href = 'intro.jsp'; })
                .catch(err => {
                    if (err.code === 'auth/email-already-in-use') {
                        showError("This email is already in use. Please log in.");
                    } else if (err.code === 'auth/weak-password') {
                        showError("Password should be at least 6 characters.");
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
