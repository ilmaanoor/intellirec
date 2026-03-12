<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Intellirec AI - Discover Your World</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600&family=Inter:wght@400;700&family=Outfit:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #FFD700;
            --primary-dark: #FFA500;
            --glass: rgba(255, 215, 0, 0.7);
            --glass-nav: rgba(255, 215, 0, 0.95);
            --text-dark: #1A1A1A;
            --text-muted: #7F8C8D;
            --header-h: 70px;
            --nav-h: 50px;
            --footer-h: 50px;
            --transition: all 0.5s cubic-bezier(0.25, 1, 0.5, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--text-dark);
            color: white;
            overflow: hidden;
            height: 100vh;
        }

        /* --- 1. HEADER SECTION --- */
        .header {
            position: fixed;
            top: 0; left: 0; width: 100%;
            height: var(--header-h);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
            background: var(--glass);
            backdrop-filter: blur(10px);
            z-index: 1000;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .user-identity {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            border: 2px solid white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .user-name {
            font-weight: 700;
            color: white;
            font-family: 'Outfit', sans-serif;
        }

        .btn-signout {
            background: var(--primary);
            color: var(--text-dark);
            padding: 8px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9rem;
            transition: var(--transition);
            box-shadow: 0 0 0px rgba(255, 215, 0, 0);
        }

        .btn-signout:hover {
            transform: scale(1.05);
            box-shadow: 0 0 20px rgba(255, 215, 0, 0.6);
            background: white;
        }

        /* --- 2. NAVIGATION BAR --- */
        .navbar {
            position: fixed;
            top: var(--header-h);
            left: 0; width: 100%;
            height: var(--nav-h);
            background: var(--glass-nav);
            backdrop-filter: blur(10px);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 999;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        .nav-items {
            display: flex;
            gap: 40px;
            list-style: none;
        }

        .nav-items a {
            text-decoration: none;
            color: var(--text-dark);
            font-weight: 600;
            font-size: 0.95rem;
            position: relative;
            transition: var(--transition);
        }

        .nav-items a:hover {
            transform: scale(1.1);
        }

        .nav-items a.active::after {
            content: '';
            position: absolute;
            bottom: -5px; left: 0; width: 100%; height: 2px;
            background: var(--text-dark);
        }

        /* --- 3. HERO CANVAS --- */
        .hero-canvas {
            position: relative;
            top: calc(var(--header-h) + var(--nav-h));
            width: 100%;
            height: calc(100vh - var(--header-h) - var(--nav-h) - var(--footer-h));
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #FFD700, #FFA500, #FFCC00);
            background-size: 400% 400%;
            animation: gradientAnim 8s infinite alternate;
        }

        @keyframes gradientAnim {
            0% { background-position: 0% 50%; }
            100% { background-position: 100% 50%; }
        }

        /* Parallax Layer */
        .parallax-bg {
            position: absolute;
            top: -10%; left: -10%; width: 120%; height: 120%;
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 1fr 1fr;
            gap: 20px;
            opacity: 0.15;
            z-index: 1;
            pointer-events: none;
            transition: transform 0.1s ease-out;
        }

        .parallax-bg img {
            width: 100%; height: 100%; object-fit: cover;
            border-radius: 20px;
        }

        /* Particles */
        .particle {
            position: absolute;
            width: 8px; height: 8px;
            background: var(--primary);
            border-radius: 50%;
            pointer-events: none;
            z-index: 2;
            animation: floatParticle 12s infinite;
        }

        @keyframes floatParticle {
            0% { transform: translateY(0) translateX(0); opacity: 0; }
            50% { opacity: 0.8; }
            100% { transform: translateY(-100vh) translateX(50px); opacity: 0; }
        }

        /* Center Content Container */
        .content-stack {
            position: relative;
            z-index: 10;
            text-align: center;
            max-width: 900px;
            padding: 0 20px;
        }

        .headline {
            font-family: 'Playfair Display', serif;
            font-size: 72px;
            line-height: 1.1;
            margin-bottom: 40px;
            color: var(--text-dark);
            opacity: 0;
            transform: translateY(30px);
            animation: slideUp 0.7s forwards 0.3s;
        }

        .cta-button {
            display: inline-flex;
            width: 320px;
            height: 90px;
            background: var(--text-dark);
            color: var(--primary);
            justify-content: center;
            align-items: center;
            font-size: 1.5rem;
            font-weight: 800;
            text-decoration: none;
            border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
            margin-bottom: 30px;
            border: 4px solid var(--text-dark);
            transition: var(--transition);
            opacity: 0;
            transform: rotate(-10deg) scale(0.5);
            animation: materialize 1s forwards 1s, breatheCTA 3s infinite 2s;
        }

        .cta-button:hover {
            transform: scale(1.1) rotate(0deg);
            background: white;
            color: var(--text-dark);
            border-radius: 50%;
        }

        .tagline {
            font-size: 22px;
            color: rgba(0,0,0,0.7);
            opacity: 0;
            animation: fadeIn 0.5s forwards 1.2s;
        }

        @keyframes slideUp { to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeIn { to { opacity: 1; } }
        @keyframes materialize { to { opacity: 1; transform: rotate(0deg) scale(1); } }
        @keyframes breatheCTA {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        /* Orbiting Icons */
        .orbit-container {
            position: absolute;
            width: 600px;
            height: 600px;
            border-radius: 50%;
            z-index: 5;
            animation: rotateOrbit 20s linear infinite;
        }

        .orbit-icon {
            position: absolute;
            width: 72px;
            height: 72px;
            background: white;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: var(--transition);
            cursor: pointer;
            animation: counterRotate 20s linear infinite;
            opacity: 0;
        }

        .orbit-icon:hover {
            transform: scale(1.3);
            z-index: 100;
            box-shadow: 0 15px 40px rgba(255, 215, 0, 0.4);
        }

        .orbit-icon .tooltip {
            position: absolute;
            bottom: -40px;
            background: var(--text-dark);
            color: white;
            padding: 5px 12px;
            border-radius: 5px;
            font-size: 0.8rem;
            opacity: 0;
            white-space: nowrap;
            transition: 0.3s;
        }

        .orbit-icon:hover .tooltip { opacity: 1; bottom: -50px; }

        .icon-1 { top: -36px; left: 50%; transform: translateX(-50%); animation-delay: 1.5s !important; } /* 10 o'clock relative to center? specification says positions. */
        /* Exact placement based on 600px circle */
        .icon-1 { top: 15%; left: 15%; } /* Film Reel */
        .icon-2 { top: 15%; right: 15%; } /* Headphones */
        .icon-3 { bottom: 15%; right: 15%; } /* Luxury Gift Box */
        .icon-4 { bottom: 15%; left: 15%; } /* World Globe */

        @keyframes rotateOrbit { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
        @keyframes counterRotate { from { transform: rotate(0deg); } to { transform: rotate(-360deg); } }

        /* --- 4. FOOTER --- */
        .footer {
            position: fixed;
            bottom: 0; left: 0; width: 100%;
            height: var(--footer-h);
            display: flex;
            justify-content: center;
            align-items: center;
            background: var(--text-dark);
            color: #AAA;
            font-size: 0.9rem;
            z-index: 1000;
        }

        /* --- STAGGERED CASCADE --- */
        .cascade-in {
            animation: slideUp 0.5s forwards;
            opacity: 0;
        }

        /* --- RESPONSIVE --- */
        @media (max-width: 768px) {
            .headline { font-size: 42px; }
            .cta-button { width: 95vw; }
            .nav-items { display: none; }
            .orbit-container { display: none; }
            .mobile-icons {
                display: flex;
                gap: 20px;
                margin-top: 20px;
                overflow-x: auto;
                padding-bottom: 10px;
            }
        }
    </style>
</head>
<body>

    <div class="header">
        <div class="user-identity">
            <img id="user-avatar" class="avatar" src="https://ui-avatars.com/api/?background=random&name=User" alt="Avatar">
            <span id="user-display-name" class="user-name">Welcome back, User</span>
        </div>
        <a href="#" id="logout-btn" class="btn-signout">Sign Out</a>
    </div>

    <nav class="navbar">
        <ul class="nav-items">
            <li><a href="#" class="active">Home</a></li>
            <li><a href="movies.jsp">Movies</a></li>
            <li><a href="songs.jsp">Songs</a></li>
            <li><a href="gifts.jsp">Gifts</a></li>
            <li><a href="travel.jsp">Travel</a></li>
            <li><a href="profile.jsp">Profile</a></li>
        </ul>
    </nav>

    <div class="hero-canvas" id="canvas">
        <!-- Parallax Layer -->
        <div class="parallax-bg" id="parallax">
            <img src="https://images.unsplash.com/photo-1485099046331-7481016d97a9?w=800&q=80" alt="Movies">
            <img src="https://images.unsplash.com/photo-1514525253361-b83f8a9027c0?w=800&q=80" alt="Music">
            <img src="https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=800&q=80" alt="Gifts">
            <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80" alt="Travel">
        </div>

        <!-- Orbiting Icons -->
        <div class="orbit-container">
            <div class="orbit-icon icon-1" style="animation-delay: 1.5s; opacity: 1;">
                🎬
                <div class="tooltip">Film Reel</div>
            </div>
            <div class="orbit-icon icon-2" style="animation-delay: 1.7s; opacity: 1;">
                🎧
                <div class="tooltip">Headphones</div>
            </div>
            <div class="orbit-icon icon-3" style="animation-delay: 1.9s; opacity: 1;">
                🎁
                <div class="tooltip">Luxury Gift Box</div>
            </div>
            <div class="orbit-icon icon-4" style="animation-delay: 2.1s; opacity: 1;">
                🌍
                <div class="tooltip">World Globe</div>
            </div>
        </div>

        <!-- Center Content -->
        <div class="content-stack">
            <h1 class="headline">Intelligent Recommendations<br>For Everything You Love</h1>
            <a href="categories.jsp" class="cta-button">Discover Your Matches</a>
            <p class="tagline">Curated from Netflix • Spotify • Amazon • Global Travel</p>
        </div>

        <!-- Particles Container (Javascript will populate) -->
        <div id="particles"></div>
    </div>

    <div class="footer">
        Powered by Intellirec AI
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script>
        // --- 1. FIREBASE AUTH & USER NAME ---
        firebase.auth().onAuthStateChanged((user) => {
            if (!user) {
                window.location.href = 'login.jsp';
            } else {
                const name = user.displayName || user.email.split('@')[0];
                document.getElementById('user-display-name').innerText = "Welcome back, " + name;
                document.getElementById('user-avatar').src = "https://ui-avatars.com/api/?background=FFD700&color=1A1A1A&bold=true&name=" + name;
            }
        });

        // --- 2. PARALLAX EFFECT ---
        const canvas = document.getElementById('canvas');
        const parallax = document.getElementById('parallax');
        
        canvas.addEventListener('mousemove', (e) => {
            const x = (e.clientX - window.innerWidth / 2) / 50;
            const y = (e.clientY - window.innerHeight / 2) / 50;
            parallax.style.transform = `translate(${x}px, ${y}px) rotateX(${y * 0.1}deg) rotateY(${-x * 0.1}deg)`;
        });

        // --- 3. PARTICLES GENERATION ---
        const particlesContainer = document.getElementById('particles');
        for (let i = 0; i < 15; i++) {
            const p = document.createElement('div');
            p.className = 'particle';
            p.style.left = Math.random() * 100 + '%';
            p.style.top = Math.random() * 100 + 100 + '%';
            p.style.animationDelay = Math.random() * 10 + 's';
            p.style.opacity = Math.random();
            particlesContainer.appendChild(p);
        }

        // --- 4. LOAD SEQUENCE ANIMATION STAGGERING ---
        // Most are handled in CSS, but icons need explicit opacity toggle if they use cascade
        document.querySelectorAll('.orbit-icon').forEach((icon, index) => {
            icon.style.animation = `slideUp 0.5s forwards ${1.5 + index * 0.2}s, counterRotate 20s linear infinite`;
        });
    </script>
</body>
</html>
