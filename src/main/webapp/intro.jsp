<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IntelliRec AI - Discover Everything</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;800&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/global.css">
    <style>
        body { overflow: hidden; height: 100vh; }

        /* --- Refined Hero Section --- */
        .hero {
            position: relative;
            top: 0;
            width: 100%;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: var(--bg-cream);
            overflow: hidden;
        }

        .hero-bg-accent {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 150%;
            height: 150%;
            background: radial-gradient(circle, rgba(249, 168, 37, 0.1) 0%, transparent 70%);
            transform: translate(-50%, -50%);
            z-index: 1;
        }

        /* Particles */
        .particle {
            position: absolute;
            width: 6px; height: 6px;
            background: var(--primary);
            border-radius: 50%;
            pointer-events: none;
            z-index: 2;
            opacity: 0.3;
        }

        /* Parallax Image Grid (Subtle) */
        .parallax-container {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 40px;
            padding: 80px;
            opacity: 0.05;
            z-index: 1;
            pointer-events: none;
            transition: transform 0.2s ease-out;
        }

        .parallax-container img {
            width: 100%; aspect-ratio: 4/5; object-fit: cover;
            border-radius: 20px;
        }

        /* Center Content */
        .hero-content {
            position: relative;
            z-index: 100;
            text-align: center;
            max-width: 800px;
        }

        .hero-headline {
            font-size: clamp(2.5rem, 5vw, 4.5rem);
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 24px;
            color: var(--text-dark);
            opacity: 0;
            transform: translateY(30px);
            animation: slideUpFade 0.8s forwards 0.4s;
        }

        .hero-tagline {
            font-size: 1.25rem;
            color: var(--text-muted);
            margin-bottom: 40px;
            opacity: 0;
            animation: slideUpFade 0.8s forwards 0.6s;
        }

        .cta-group {
            opacity: 0;
            animation: slideUpFade 0.8s forwards 0.8s;
        }

        @keyframes slideUpFade {
            to { opacity: 1; transform: translateY(0); }
        }

        /* Refining Orbiting Icons */
        .orbit-system {
            position: absolute;
            width: 550px;
            height: 550px;
            z-index: 50;
            animation: rotateOrbit 30s linear infinite;
        }

        .orbit-item {
            position: absolute;
            width: 80px;
            height: 80px;
            background: var(--white);
            border-radius: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            border: 1px solid rgba(249, 168, 37, 0.1);
            animation: counterRotate 30s linear infinite;
            cursor: pointer;
            transition: var(--transition-smooth);
        }

        .orbit-item:hover {
            transform: scale(1.1) translateY(-10px);
            box-shadow: 0 15px 35px rgba(249, 168, 37, 0.2);
            border-color: var(--primary);
        }

        .orbit-item svg {
            width: 32px;
            height: 32px;
            fill: var(--primary);
        }

        /* Exact placement on 550px circle */
        .pos-1 { top: 0; left: 50%; transform: translate(-50%, -50%); }
        .pos-2 { top: 50%; right: 0; transform: translate(50%, -50%); }
        .pos-3 { bottom: 0; left: 50%; transform: translate(-50%, 50%); }
        .pos-4 { top: 50%; left: 0; transform: translate(-50%, -50%); }

        @keyframes rotateOrbit { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
        @keyframes counterRotate { from { transform: rotate(0deg); } to { transform: rotate(-360deg); } }

    </style>
</head>
<body>

    <nav class="navbar-global">
        <a href="index.jsp" class="nav-brand">Intelli<span>Rec AI</span></a>
        
        <ul class="nav-links-global">
            <li><a href="#" class="active">Home</a></li>
            <li><a href="movies.jsp">Movies</a></li>
            <li><a href="songs.jsp">Songs</a></li>
            <li><a href="gifts.jsp">Gifts</a></li>
            <li><a href="travel.jsp">Travel</a></li>
        </ul>

        <div class="nav-user">
            <img id="user-avatar" src="https://ui-avatars.com/api/?background=F9A825&color=white&name=User" alt="Avatar">
            <a href="#" id="logout-btn" class="btn-logout-nav" title="Sign Out">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            </a>
        </div>
    </nav>

    <div class="hero" id="hero-main">
        <div class="hero-bg-accent"></div>
        <div id="particles-container"></div>

        <div class="parallax-container" id="parallax-grid">
            <img src="https://images.unsplash.com/photo-1485099046331-7481016d97a9?w=600&q=80" alt="Movies">
            <img src="https://images.unsplash.com/photo-1514525253361-b83f8a9027c0?w=600&q=80" alt="Songs">
            <img src="https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=600&q=80" alt="Gifts">
            <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&q=80" alt="Travel">
        </div>

        <div class="orbit-system">
            <a href="movies.jsp" class="orbit-item pos-1" title="Movies">
                <svg viewBox="0 0 24 24"><path d="M18,3H6C4.9,3,4,3.9,4,5v14c0,1.1,0.9,2,2,2h12c1.1,0,2-0.9,2-2V5C20,3.9,19.1,3,18,3z M18,11h-2V9h2V11z M14,11h-2V9h2V11z M10,11H8V9h2V11z M18,7h-2V5h2V7z M14,7h-2V5h2V7z M10,7H8V5h2V7z M18,15h-2v-2h2V15z M14,15h-2v-2h2V15z M10,15H8v-2h2V15z M18,19h-2v-2h2V19z M14,19h-2v-2h2V19z M10,19H8v-2h2V19z"/></svg>
            </a>
            <a href="songs.jsp" class="orbit-item pos-2" title="Music">
                <svg viewBox="0 0 24 24"><path d="M12,3v10.55c-0.59-0.34-1.27-0.55-2-0.55c-2.21,0-4,1.79-4,4s1.79,4,4,4s4-1.79,4-4V7h4V3H12z"/></svg>
            </a>
            <a href="gifts.jsp" class="orbit-item pos-3" title="Gifts">
                <svg viewBox="0 0 24 24"><path d="M20,6h-2.18c0.11-0.31,0.18-0.65,0.18-1c0-1.66-1.34-3-3-3c-1.05,0-1.96,0.54-2.5,1.35C11.96,2.54,11.05,2,10,2C8.34,2,7,3.34,7,5c0,0.35,0.07,0.69,0.18,1H5C3.34,6,2,7.34,2,9v11c0,1.66,1.34,3,3,3h14c1.66,0,3-1.34,3-3V9C22,7.34,20.66,6,20,6z M15,4c0.55,0,1,0.45,1,1s-0.45,1-1,1s-1-0.45-1-1S14.45,4,15,4z M10,4c0.55,0,1,0.45,1,1s-0.45,1-1,1s-1-0.45-1-1S9.45,4,10,4z M20,20c0,0.55-0.45,1-1,1H5c-0.55,0-1-0.45-1-1V9c0-0.55,0.45-1,1-1h14c0.55,0,1,0.45,1,1V20z"/></svg>
            </a>
            <a href="travel.jsp" class="orbit-item pos-4" title="Travel">
                <svg viewBox="0 0 24 24"><path d="M12,2L4.5,20.29L5.21,21L12,18L18.79,21L19.5,20.29L12,2Z"/></svg>
            </a>
        </div>

        <div class="hero-content">
            <h1 class="hero-headline">Perfect Discovery<br>Powered by Intelligence</h1>
            <p class="hero-tagline">Curated recommendations for everything you love, tailored to your personality.</p>
            <div class="cta-group">
                <a href="categories.jsp" class="btn-primary-site">Start Your Journey</a>
            </div>
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script>
        // --- 1. USER PERSONALIZATION ---
        firebase.auth().onAuthStateChanged((user) => {
            if (!user) {
                window.location.href = 'login.jsp';
            } else {
                const name = user.displayName || user.email.split('@')[0];
                document.getElementById('user-avatar').src = "https://ui-avatars.com/api/?background=F9A825&color=white&bold=true&name=" + name;
                console.log("Welcome,", name);
            }
        });

        // --- 2. SUBTLE PARALLAX ---
        const hero = document.getElementById('hero-main');
        const grid = document.getElementById('parallax-grid');
        hero.addEventListener('mousemove', (e) => {
            const x = (e.clientX - window.innerWidth / 2) / 40;
            const y = (e.clientY - window.innerHeight / 2) / 40;
            grid.style.transform = `translate(${x}px, ${y}px)`;
        });

        // --- 3. DYNAMIC PARTICLES ---
        const container = document.getElementById('particles-container');
        for(let i=0; i<20; i++) {
            const p = document.createElement('div');
            p.className = 'particle';
            p.style.left = Math.random() * 100 + '%';
            p.style.top = Math.random() * 100 + '%';
            p.style.animation = `float ${Math.random() * 5 + 5}s infinite ease-in-out`;
            p.style.animationDelay = Math.random() * 5 + 's';
            container.appendChild(p);
        }

        const style = document.createElement('style');
        style.innerHTML = `@keyframes float {
            0%, 100% { transform: translate(0, 0); }
            50% { transform: translate(${Math.random() * 50 - 25}px, ${Math.random() * 50 - 25}px); }
        }`;
        document.head.appendChild(style);
    </script>

</body>
</html>
