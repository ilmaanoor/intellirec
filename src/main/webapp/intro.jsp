<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Intellirec AI - Discover Your World</title>
    <link rel="stylesheet" href="css/style_v1.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&family=Playfair+Display:ital,wght@0,600;1,600&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #FFFDF8; /* Extremely soft, warm white-yellow */
            overflow-x: hidden;
            font-family: 'Outfit', sans-serif;
            margin: 0;
            padding: 0;
            color: #1A1A1A;
        }

        /* Ambient Creative Lighting Effects */
        .ambient-glow {
            position: absolute;
            border-radius: 50%;
            filter: blur(100px);
            z-index: -1;
            opacity: 0.6;
            animation: breathe 12s ease-in-out infinite alternate;
        }

        .glow-movies { width: 500px; height: 500px; background: rgba(255, 107, 107, 0.2); top: -100px; left: -100px; } /* Netflix Red hint */
        .glow-music { width: 400px; height: 400px; background: rgba(29, 185, 84, 0.15); bottom: 10%; right: -50px; } /* Spotify Green hint */
        .glow-travel { width: 600px; height: 600px; background: rgba(0, 166, 153, 0.15); top: 40%; left: 30%; } /* Tripadvisor Green hint */
        .glow-gifts { width: 450px; height: 450px; background: rgba(255, 153, 0, 0.2); top: 10%; right: 10%; } /* Amazon Orange/Yellow hint */

        @keyframes breathe {
            0% { transform: scale(0.8) translate(0, 0); opacity: 0.4; }
            100% { transform: scale(1.1) translate(30px, -20px); opacity: 0.7; }
        }

        /* Header Styling */
        header {
            position: absolute;
            top: 0; left: 0; width: 100%;
            padding: 2rem 4rem;
            box-sizing: border-box;
            z-index: 100;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.8rem;
            color: #1A1A1A;
            text-decoration: none;
            font-weight: 800;
            letter-spacing: -0.5px;
        }
        
        .logo span {
            color: #FFB300; /* Sophisticated Amber/Yellow */
        }
        
        .nav-link {
            padding: 0.8rem 1.8rem;
            border: 2px solid #EAEAEA;
            border-radius: 50px;
            color: #1A1A1A;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(10px);
        }

        .nav-link:hover {
            border-color: #1A1A1A;
            background: #1A1A1A;
            color: #FFF;
        }

        /* Hero Section Split Layout */
        .hero-container {
            display: flex;
            min-height: 100vh;
            align-items: center;
            justify-content: space-between;
            padding: 0 8vw;
            position: relative;
            z-index: 10;
        }

        /* Left Side: Editorial Typography */
        .hero-text {
            flex: 1;
            max-width: 600px;
            padding-right: 4rem;
        }

        .category-tags {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .tag {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 700;
            color: #888;
        }

        .hero-text h1 {
            font-family: 'Playfair Display', serif;
            font-size: 4.8rem;
            color: #1A1A1A;
            font-weight: 600;
            line-height: 1.05;
            margin: 0 0 1.5rem 0;
            letter-spacing: -1px;
        }

        .hero-text h1 span {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            color: #FFB300; /* The highlight yellow */
            display: block;
        }

        .hero-text p {
            font-size: 1.2rem;
            color: #555;
            font-weight: 300;
            line-height: 1.7;
            margin: 0 0 3rem 0;
            max-width: 480px;
        }

        /* The Amoeba Button */
        .amoeba-wrapper {
            position: relative;
            display: inline-block;
        }

        .amoeba-btn-custom {
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            width: 280px;
            height: 260px;
            background: linear-gradient(135deg, #FFC107 0%, #FF9800 100%);
            color: #FFF;
            font-size: 1.5rem;
            font-weight: 800;
            text-decoration: none;
            line-height: 1.2;
            cursor: pointer;
            box-shadow: 
                0 20px 40px rgba(255, 152, 0, 0.3),
                inset 0 2px 10px rgba(255, 255, 255, 0.4);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%;
            animation: morphBtn 8s ease-in-out infinite;
            padding: 2rem;
            position: relative;
            z-index: 5;
        }

        .amoeba-btn-custom::before {
            content: '';
            position: absolute;
            top: -2px; left: -2px; right: -2px; bottom: -2px;
            background: linear-gradient(45deg, #FFC107, transparent, #FF9800);
            z-index: -1;
            border-radius: inherit;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .amoeba-btn-custom:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 
                0 30px 50px rgba(255, 152, 0, 0.4),
                inset 0 2px 10px rgba(255, 255, 255, 0.6);
            letter-spacing: 1px;
        }
        
        .amoeba-btn-custom:hover::before {
            opacity: 1;
        }

        @keyframes morphBtn {
            0% { border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%; }
            33% { border-radius: 40% 60% 70% 30% / 50% 60% 30% 60%; }
            66% { border-radius: 50% 50% 40% 60% / 40% 40% 60% 60%; }
            100% { border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%; }
        }

        /* Right Side: Creative Visual Abstract Representation */
        .visual-showcase {
            flex: 1;
            position: relative;
            height: 600px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .glass-card {
            position: absolute;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.9);
            border-radius: 24px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            padding: 1rem 1.5rem;
            gap: 1.5rem;
            transition: transform 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .glass-card:hover {
            transform: translateY(-10px) scale(1.05) !important;
            z-index: 20;
            background: rgba(255, 255, 255, 0.95);
        }

        .glass-card img {
            width: 80px;
            height: 80px;
            border-radius: 16px;
            object-fit: cover;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .card-info h3 { margin: 0 0 0.3rem 0; font-size: 1.1rem; color: #1A1A1A; }
        .card-info p { margin: 0; font-size: 0.85rem; color: #888; text-transform: uppercase; letter-spacing: 1px; }

        /* Positioning the 4 category cards creatively */
        .card-movie { top: 10%; right: 10%; transform: rotate(5deg); animation: floatCard 6s ease-in-out infinite alternate; }
        .card-music { top: 40%; left: 0%; transform: rotate(-5deg); animation: floatCard 8s ease-in-out 1s infinite alternate; }
        .card-travel { bottom: 20%; right: 5%; transform: rotate(8deg); animation: floatCard 7s ease-in-out 2s infinite alternate; }
        .card-gift { bottom: -5%; left: 20%; transform: rotate(-8deg); animation: floatCard 9s ease-in-out 0.5s infinite alternate; }

        @keyframes floatCard {
            0% { transform: translateY(0px) rotate(var(--rot, 0deg)); }
            100% { transform: translateY(-20px) rotate(var(--rot, 0deg)); }
        }
        
        .card-movie { --rot: 5deg; }
        .card-music { --rot: -5deg; }
        .card-travel { --rot: 8deg; }
        .card-gift { --rot: -8deg; }

    </style>
</head>
<body>
    <!-- Abstract Ambient Glows representing the API sources subtly -->
    <div class="ambient-glow glow-movies"></div>
    <div class="ambient-glow glow-music"></div>
    <div class="ambient-glow glow-travel"></div>
    <div class="ambient-glow glow-gifts"></div>

    <header>
        <a href="index.jsp" class="logo">Intelli<span>Rec</span></a>
        <a href="#" id="logout-btn" class="nav-link">Logout</a>
    </header>

    <div class="hero-container">
        <!-- Left Side Typography & Button -->
        <div class="hero-text">
            <div class="category-tags">
                <span class="tag">Movies</span> • 
                <span class="tag">Music</span> • 
                <span class="tag">Gifts</span> • 
                <span class="tag">Travel</span>
            </div>
            <h1>Curated for your <br><span>Unique World</span></h1>
            <p>We analyze real-time data from Netflix, Spotify, Amazon, and Tripadvisor to bring you highly personalized, intelligent recommendations tailored specifically to your taste and mood.</p>
            
            <div class="amoeba-wrapper">
                <a href="categories.jsp" class="amoeba-btn-custom">
                    Recommendations<br>For You
                </a>
            </div>
        </div>

        <!-- Right Side Creative Abstract Visuals -->
        <div class="visual-showcase">
            <div class="glass-card card-movie">
                <img src="https://images.unsplash.com/photo-1485846234645-a62644f84728?w=200&h=200&fit=crop" alt="Cinema">
                <div class="card-info">
                    <h3>Cinema Graph</h3>
                    <p>Trending</p>
                </div>
            </div>

            <div class="glass-card card-music">
                <img src="https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=200&h=200&fit=crop" alt="Audio">
                <div class="card-info">
                    <h3>Audio Waves</h3>
                    <p>Frequency</p>
                </div>
            </div>

            <div class="glass-card card-travel">
                <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=200&h=200&fit=crop" alt="Oceans">
                <div class="card-info">
                    <h3>Horizon Lines</h3>
                    <p>Expedition</p>
                </div>
            </div>

            <div class="glass-card card-gift">
                <img src="https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=200&h=200&fit=crop" alt="Boutique">
                <div class="card-info">
                    <h3>Curated Items</h3>
                    <p>Selection</p>
                </div>
            </div>
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script>
        // Protection: redirect to login if not authenticated
        firebase.auth().onAuthStateChanged((user) => {
            if (!user) {
                window.location.href = 'login.jsp';
            }
        });
    </script>
</body>
</html>
