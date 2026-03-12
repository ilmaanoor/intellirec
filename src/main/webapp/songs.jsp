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
        <h1>Music Discovery</h1>
        <p>Real-time top hits based on language and mood.</p>
    </div>

    <div class="filter-section" style="max-width: 900px; display: flex; flex-direction: column; gap: 20px;">
        <div style="display: flex; gap: 20px; align-items: flex-end;">
            <div class="filter-group" style="flex: 1;">
                <label>Select Language</label>
                <select id="language-filter" class="form-control">
                    <option value="English">English</option>
                    <option value="Hindi">Hindi</option>
                    <option value="Tamil">Tamil</option>
                    <option value="Korean">Korean</option>
                    <option value="Chinese">Chinese</option>
                </select>
            </div>
            <div class="filter-group" style="flex: 1;">
                <label>Select Mood/Vibe</label>
                <select id="mood-filter" class="form-control">
                    <option value="Happy">Happy & Upbeat</option>
                    <option value="Chill">Chill & Relaxed</option>
                    <option value="Focus">Focus & Study</option>
                    <option value="Workout">Workout Energy</option>
                    <option value="Romantic">Romantic</option>
                </select>
            </div>
            <div class="filter-group" style="flex: 1.2;">
                <label>Optional: specific Artist</label>
                <div style="position: relative;">
                    <input type="text" id="artist-search" class="form-control" placeholder="e.g. Taylor Swift" style="padding-left: 35px;">
                    <svg style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); opacity: 0.5;" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                </div>
            </div>
        </div>
    </div>

    <div id="song-grid" class="song-grid">
        <div class="loading-state">Initializing Audio Engine...</div>
    </div>

    <audio id="global-player" style="display:none;"></audio>

    <footer class="footer-site">
        Powered by IntelliRec AI • Live Music Connection
    </footer>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js?v=2.2"></script>
    <script>
        firebase.auth().onAuthStateChanged((user) => {
            if (user) {
                const name = user.displayName || user.email.split('@')[0];
                document.getElementById('user-avatar').src = `https://ui-avatars.com/api/?background=B9B9B9&color=white&bold=true&name=\${name}`;
            }
        });

        // Global Audio Control
        const player = document.getElementById('global-player');
        let currentPlayingBtn = null;

        function togglePreview(url, btn) {
            if (player.src === url && !player.paused) {
                player.pause();
                btn.innerHTML = '▶';
                return;
            }
            
            if (currentPlayingBtn) currentPlayingBtn.innerHTML = '▶';
            
            player.src = url;
            player.play();
            btn.innerHTML = '⏸';
            currentPlayingBtn = btn;
            
            player.onended = () => {
                btn.innerHTML = '▶';
                currentPlayingBtn = null;
            };
        }

        async function loadSongs() {
            const grid = document.getElementById('song-grid');
            const language = document.getElementById('language-filter').value;
            const mood = document.getElementById('mood-filter').value;
            const artist = document.getElementById('artist-search').value;

            grid.innerHTML = '<div class="loading-state">Tuning your frequency...</div>';

            try {
                let songs = await ApiClient.getSongs(language, mood, artist);

                grid.innerHTML = '';
                
                if (songs.length === 0) {
                    grid.innerHTML = '<div class="loading-state">No tracks found. Check your connection or try different filters.</div>';
                    return;
                }

                songs.forEach(song => {
                    const card = document.createElement('div');
                    card.className = 'song-card';
                    const sourceBadge = '<span style="color: #A238FF; font-size: 10px; font-weight: bold; background: rgba(162, 56, 255, 0.1); padding: 2px 6px; border-radius: 4px; border: 1px solid #A238FF; margin-left: 5px;">TRENDING</span>';
                    
                    const previewBtn = song.preview ? 
                        `<button class="play-btn" onclick="togglePreview('\${song.preview}', this)">▶</button>` : 
                        `<span style="font-size:10px; opacity:0.5; background: rgba(0,0,0,0.5); padding: 4px; border-radius: 4px; color: white;">No Preview</span>`;

                    card.innerHTML = `
                        <div style="position:relative;">
                            <img src="\${song.img}" alt="\${song.album}" class="album-art">
                            <div style="position:absolute; bottom:15px; right:15px;">\${previewBtn}</div>
                        </div>
                        <span class="spotify-tag" style="background: #A238FF;">DEEZER \${sourceBadge}</span>
                        <div class="song-title" title="\${song.title}">\${song.title}</div>
                        <div class="artist-name">\${song.artist}</div>
                        <a href="\${song.url}" target="_blank" style="font-size:11px; color:#A238FF; text-decoration:none; margin-top:10px; display:inline-block; font-weight:700;">Open Track</a>
                    `;
                    grid.appendChild(card);
                });
            } catch (err) {
                grid.innerHTML = '<div class="loading-state">Connection lost. Failed to fetch music.</div>';
            }
        }

        function debounce(func, timeout = 500) {
            let timer;
            return (...args) => {
                clearTimeout(timer);
                timer = setTimeout(() => { func.apply(this, args); }, timeout);
            };
        }

        // Event Listeners
        document.getElementById('mood-filter').addEventListener('change', loadSongs);
        document.getElementById('language-filter').addEventListener('change', loadSongs);
        document.getElementById('artist-search').addEventListener('input', debounce(loadSongs));

        // Add Play Button Style
        const playerStyle = document.createElement('style');
        playerStyle.innerHTML = `
            .play-btn {
                width: 35px; height: 35px; border-radius: 50%; background: #1DB954; color: white;
                border: none; cursor: pointer; display: flex; align-items: center; justify-content: center;
                box-shadow: 0 4px 10px rgba(0,0,0,0.3); transition: transform 0.2s;
            }
            .play-btn:hover { transform: scale(1.1); background: #1ed760; }
            .song-title { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; width: 100%; }
        `;
        document.head.appendChild(playerStyle);

        loadSongs();
    </script>
</body>
</html>
