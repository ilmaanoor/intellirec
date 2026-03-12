// Firebase Auth handling for Intellirec AI
document.addEventListener('DOMContentLoaded', () => {
    // --- 1. UI ELEMENTS ---
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    const toggleLogin = document.getElementById('toggle-login');
    const toggleRegister = document.getElementById('toggle-register');
    const errorMsg = document.getElementById('auth-error');
    const logoutBtn = document.getElementById('logout-btn');

    console.log("Auth System Initialized", {
        hasLogin: !!loginForm,
        hasRegister: !!registerForm,
        hasToggle: !!toggleLogin
    });

    // --- 2. UI HELPERS ---
    function showError(msg) {
        console.error("Auth Error:", msg);
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
        }
    }

    function setBtnState(formId, isLoading) {
        const btn = document.querySelector(`#${formId} .btn-submit`);
        if (btn) {
            if (isLoading) {
                btn.disabled = true;
                btn.dataset.original = btn.innerText;
                btn.innerText = formId === 'login-form' ? 'Signing In...' : 'Registering...';
            } else {
                btn.disabled = false;
                btn.innerText = btn.dataset.original || (formId === 'login-form' ? 'Sign In' : 'Sign Up');
            }
        }
    }

    // --- 3. TOGGLE LOGIC ---
    function switchToLogin() {
        if (!loginForm || !registerForm) return;
        toggleLogin.classList.add('active');
        toggleRegister.classList.remove('active');
        loginForm.style.display = 'block';
        registerForm.style.display = 'none';
        hideError();
    }

    function switchToRegister() {
        if (!loginForm || !registerForm) return;
        toggleRegister.classList.add('active');
        toggleLogin.classList.remove('active');
        registerForm.style.display = 'block';
        loginForm.style.display = 'none';
        hideError();
    }

    if (toggleLogin) toggleLogin.addEventListener('click', switchToLogin);
    if (toggleRegister) toggleRegister.addEventListener('click', switchToRegister);

    // Initial check for URL mode
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('mode') === 'register') {
        switchToRegister();
    }

    // --- 4. AUTH LOGIC ---
    function validateEmail(email) {
        return /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email);
    }

    // Handle Login
    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            hideError();

            const emailField = document.getElementById('email');
            const passwordField = document.getElementById('password');

            if (!emailField || !passwordField) {
                showError("Critical Error: Form fields not found.");
                return;
            }

            const email = emailField.value.trim();
            const password = passwordField.value;

            if (!email || !validateEmail(email)) {
                showError("Please enter a valid email address.");
                return;
            }
            if (!password) {
                showError("Please enter your password.");
                return;
            }

            setBtnState('login-form', true);
            console.log("Attempting Sign In...");

            firebase.auth().signInWithEmailAndPassword(email, password)
                .then(() => {
                    console.log("Sign In Success!");
                    window.location.href = 'intro.jsp';
                })
                .catch(err => {
                    setBtnState('login-form', false);
                    console.error("Firebase Error:", err.code, err.message);
                    if (err.code === 'auth/user-not-found' || err.code === 'auth/wrong-password' || err.code === 'auth/invalid-credential') {
                        showError("Incorrect email or password.");
                    } else {
                        showError(err.message);
                    }
                });
        });
    }

    // Handle Register
    if (registerForm) {
        registerForm.addEventListener('submit', (e) => {
            e.preventDefault();
            hideError();

            const emailField = document.getElementById('reg-email');
            const passwordField = document.getElementById('reg-password');

            if (!emailField || !passwordField) {
                showError("Critical Error: Registration fields not found.");
                return;
            }

            const email = emailField.value.trim();
            const password = passwordField.value;

            if (!email || !validateEmail(email)) {
                showError("Please enter a valid email address.");
                return;
            }
            if (password.length < 6) {
                showError("Search password must be at least 6 characters.");
                return;
            }

            setBtnState('register-form', true);
            console.log("Attempting Registration...");

            firebase.auth().createUserWithEmailAndPassword(email, password)
                .then(() => {
                    console.log("Registration Success!");
                    window.location.href = 'intro.jsp';
                })
                .catch(err => {
                    setBtnState('register-form', false);
                    console.error("Firebase Error:", err.code, err.message);
                    if (err.code === 'auth/email-already-in-use') {
                        showError("This email is already registered.");
                    } else {
                        showError(err.message);
                    }
                });
        });
    }

    // Handle Logout
    if (logoutBtn) {
        logoutBtn.addEventListener('click', (e) => {
            e.preventDefault();
            firebase.auth().signOut().then(() => {
                window.location.href = 'login.jsp';
            });
        });
    }
});
