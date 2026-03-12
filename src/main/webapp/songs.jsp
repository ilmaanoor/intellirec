<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Songs - IntelliRec AI</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/global.css">
    <style>
        .page-header { padding: 120px 20px 40px; text-align: center; }
        
        .filter-section {
            max-width: 600px;
            margin: 0 auto 50px;
            background: white;
            padding: 20px;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
        }

        .song-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 25px;
            max-width: 1200px;
            margin: 0 auto 60px;
            padding: 0 20px;
        }

        .song-card {
            background: white;
            border-radius: 20px;
            padding: 15px;
            transition: var(--transition-smooth);
            border: 1px solid rgba(0,0,0,0.03);
            text-align: center;
        }

        .song-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(29, 185, 84, 0.1);
            border-color: #1DB954;
        }

        .album-art {
            width: 100%;
            aspect-ratio: 1/1;
            border-radius: 12px;
            margin-bottom: 15px;
            object-fit: cover;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .spotify-tag {
            background: #1DB954;
            color: white;
            font-size: 10px;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 50px;
            display: inline-block;
            margin-bottom: 10px;
        }

        .song-title { font-weight: 700; font-size: 16px; margin-bottom: 5px; color: var(--text-dark); }
        .artist-name { color: var(--text-muted); font-size: 13px; font-weight: 600; }

        .loading-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 100px 20px;
            color: var(--text-muted);
            font-weight: 600;
        }
    </style>
</head>
<body>

    <nav class="navbar-global">
        <a href="index.jsp" class="nav-brand">Intelli<span>Rec AI</span></a>
        <ul class="nav-links-global">
            <li><a href="intro.jsp">Home</a></li>
            <li><a href="movies.jsp">Movies</a></li>
            <li><a href="songs.jsp" class="active">Songs</a></li>
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

    <div class="page-header">
        <h1>Spotify Playlists</h1>
        <p>AI-curated music perfectly synchronized with your mood.</p>
    </div>

    <div class="filter-section">
        <div class="filter-group">
            <label>Whats your Mood?</label>
            <select id="mood-filter" class="form-control">
                <option value="Happy">Happy & Upbeat</option>
                <option value="Chill">Chill & Acoustic</option>
                <option value="Focus">Focus & Study</option>
                <option value="Workout">Workout Energy</option>
            </select>
        </div>
    </div>

    <div id="song-grid" class="song-grid">
        <div class="loading-state">Scanning your vibe...</div>
    </div>

    <footer class="footer-site">
        Powered by IntelliRec AI • Connected to Spotify
    </footer>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js"></script>
    <script>
        firebase.auth().onAuthStateChanged((user) => {
            if (user) {
                const name = user.displayName || user.email.split('@')[0];
                document.getElementById('user-avatar').src = `https://ui-avatars.com/api/?background=F9A825&color=white&bold=true&name=\${name}`;
            }
        });

        async function loadSongs() {
            const grid = document.getElementById('song-grid');
            const mood = document.getElementById('mood-filter').value;

            grid.innerHTML = '<div class="loading-state">Tuning your frequency...</div>';

            try {
                const songs = await ApiClient.getSongs(mood);
                grid.innerHTML = '';
                
                songs.forEach(song => {
                    const card = document.createElement('div');
                    card.className = 'song-card';
                    card.innerHTML = `
                        <img src="\${song.img}" alt="\${song.album}" class="album-art">
                        <span class="spotify-tag">SPOTIFY</span>
                        <div class="song-title">\${song.title}</div>
                        <div class="artist-name">\${song.artist} • \${song.album}</div>
                    `;
                    grid.appendChild(card);
                });
            } catch (err) {
                grid.innerHTML = '<div class="loading-state">Connection lost. Please refresh.</div>';
            }
        }

        document.getElementById('mood-filter').addEventListener('change', loadSongs);
        loadSongs();
    </script>
</body>
</html>
