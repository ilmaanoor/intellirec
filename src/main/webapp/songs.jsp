<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Songs - Intellirec AI</title>
    <link rel="stylesheet" href="css/style_v1.css">
    <style>
        body.flow-songs {
            background: linear-gradient(135deg, #121212 0%, #191414 100%);
            color: white;
        }
        .filter-bar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 3rem;
            display: flex;
            gap: 2rem;
            align-items: center;
        }
        .song-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 2rem;
        }
        .song-card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 1.2rem;
            transition: var(--transition);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .song-card:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-5px);
        }
        .album-art {
            width: 100%;
            aspect-ratio: 1/1;
            border-radius: 8px;
            margin-bottom: 1rem;
            box-shadow: 0 8px 16px rgba(0,0,0,0.3);
        }
        .song-title { font-weight: 700; font-size: 1.1rem; margin-bottom: 0.3rem; }
        .artist-name { color: #b3b3b3; font-size: 0.9rem; }
        .spotify-badge {
            background: #1DB954;
            color: black;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            display: inline-block;
        }
    </style>
</head>
<body class="flow-songs">
    <div class="container">
        <header>
            <a href="index.jsp" class="logo" style="color: white;">Intelli<span>Rec</span></a>
            <nav class="nav-links">
                <a href="categories.jsp" style="color: white;">Back</a>
                <a href="#" id="logout-btn" style="color: white;">Logout</a>
            </nav>
        </header>

        <section class="hero" style="padding: 2rem 0;">
            <h1 style="color: white;">Spotify Playlists</h1>
            <p style="color: #b3b3b3;">AI-curated music for every moment of your day.</p>
        </section>

        <div class="filter-bar">
            <div class="form-group" style="margin: 0; flex: 1;">
                <label style="margin-bottom: 0.5rem; font-size: 0.9rem; color: #b3b3b3;">Your Mood</label>
                <select id="mood-filter" class="form-control" style="background: #282828; border: none; color: white;">
                    <option value="Happy">Happy & Upbeat</option>
                    <option value="Chill">Chill & Acoustic</option>
                    <option value="Focus">Focus & Study</option>
                    <option value="Workout">Workout Energy</option>
                </select>
            </div>
        </div>

        <div id="song-grid" class="song-grid">
            <div class="loading-spinner">Tuning in...</div>
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js"></script>
    <script>
        async function loadSongs() {
            const grid = document.getElementById('song-grid');
            const mood = document.getElementById('mood-filter').value;

            grid.innerHTML = '<div class="loading-spinner">Scanning your mood...</div>';

            try {
                const songs = await ApiClient.getSongs(mood);
                grid.innerHTML = '';
                
                songs.forEach(song => {
                    const card = document.createElement('div');
                    card.className = 'song-card';
                    card.innerHTML = `
                        <img src="\${song.img}" alt="\${song.album}" class="album-art">
                        <span class="spotify-badge">SPOTIFY</span>
                        <div class="song-title">\${song.title}</div>
                        <div class="artist-name">\${song.artist} • \${song.album}</div>
                    `;
                    grid.appendChild(card);
                });
            } catch (err) {
                grid.innerHTML = '<div class="loading-spinner">Lost signal. Try again.</div>';
            }
        }

        document.getElementById('mood-filter').addEventListener('change', loadSongs);
        window.addEventListener('DOMContentLoaded', loadSongs);
    </script>
</body>
</html>
