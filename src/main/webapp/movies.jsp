<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movies - IntelliRec AI</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/global.css">
    <style>
        .page-header {
            padding: 120px 20px 40px;
            text-align: center;
        }

        .filter-section {
            max-width: 800px;
            margin: 0 auto 50px;
            display: flex;
            gap: 20px;
            background: white;
            padding: 20px;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
        }

        .filter-group {
            flex: 1;
        }

        .filter-group label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 8px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto 60px;
            padding: 0 20px;
        }

        .movie-card {
            background: white;
            border-radius: 24px;
            overflow: hidden;
            transition: var(--transition-smooth);
            border: 1px solid rgba(0,0,0,0.03);
            text-decoration: none;
            color: inherit;
        }

        .movie-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(249, 168, 37, 0.15);
            border-color: var(--primary-light);
        }

        .movie-thumb {
            width: 100%;
            height: 340px;
            object-fit: cover;
            background: #EEE;
        }

        .movie-meta {
            padding: 20px;
        }

        .movie-tag {
            font-size: 11px;
            font-weight: 800;
            color: var(--primary);
            text-transform: uppercase;
            margin-bottom: 8px;
            display: block;
        }

        .movie-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 12px;
            line-height: 1.3;
        }

        .movie-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
            color: var(--text-muted);
        }

        .rating {
            color: #FFA000;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .loading-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 100px 20px;
            color: var(--text-muted);
            font-weight: 600;
        }

        @media (max-width: 600px) {
            .filter-section { flex-direction: column; }
        }
    </style>
</head>
<body>

    <nav class="navbar-global">
        <a href="index.jsp" class="nav-brand">Intelli<span>Rec AI</span></a>
        <ul class="nav-links-global">
            <li><a href="intro.jsp">Home</a></li>
            <li><a href="movies.jsp" class="active">Movies</a></li>
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

    <div class="page-header">
        <h1>Movie Recommendations</h1>
        <p>Curated selections for your next cinematic experience.</p>
    </div>

    <div class="filter-section">
        <div class="filter-group">
            <label>Genre</label>
            <select id="genre-filter" class="form-control">
                <option value="All">All Genres</option>
                <option value="Action">Action</option>
                <option value="Sci-Fi">Sci-Fi</option>
                <option value="Comedy">Comedy</option>
                <option value="Drama">Drama</option>
                <option value="Fantasy">Fantasy</option>
            </select>
        </div>
        <div class="filter-group">
            <label>Language</label>
            <select id="lang-filter" class="form-control">
                <option value="English">English</option>
                <option value="Hindi">Hindi</option>
                <option value="Tamil">Tamil</option>
                <option value="Telugu">Telugu</option>
                <option value="Korean">Korean</option>
            </select>
        </div>
    </div>

    <div id="movie-grid" class="movie-grid">
        <div class="loading-state">Analyzing your preferences...</div>
    </div>

    <footer class="footer-site">
        Powered by IntelliRec AI • Connected to Netflix
    </footer>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js?v=12.0"></script>
    <script>
        // User Sync
        firebase.auth().onAuthStateChanged((user) => {
            if (user) {
                const name = user.displayName || user.email.split('@')[0];
                document.getElementById('user-avatar').src = `https://ui-avatars.com/api/?background=F9A825&color=white&bold=true&name=\${name}`;
            }
        });

        async function loadMovies() {
            const grid = document.getElementById('movie-grid');
            const genre = document.getElementById('genre-filter').value;
            const lang = document.getElementById('lang-filter').value;

            grid.innerHTML = '<div class="loading-state">Curating your list...</div>';

            try {
                const movies = await ApiClient.getMovies(genre, lang);
                grid.innerHTML = '';
                
                if (!movies || movies.length === 0) {
                    grid.innerHTML = '<div class="loading-state">No matching movies found on Netflix right now. Try another genre!</div>';
                    return;
                }

                // Real-Time Mirror Status
                const sourceBadge = '<span style="color: #4caf50; font-size: 11px; font-weight: bold;">[REAL TIME]</span>';

                movies.forEach(movie => {
                    const card = document.createElement('div');
                    card.className = 'movie-card';
                    card.innerHTML = `
                        <img src="\${movie.img}" alt="\${movie.title}" class="movie-thumb" onerror="this.src='https://via.placeholder.com/400x600?text=No+Image'">
                        <div class="movie-meta">
                            <span class="movie-tag">Netflix Choice \${sourceBadge}</span>
                            <h3 class="movie-title">\${movie.title}</h3>
                            <div class="movie-footer">
                                <span>\${movie.genre}</span>
                                <span class="rating">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                                    \${movie.rating}
                                </span>
                            </div>
                        </div>
                    `;
                    grid.appendChild(card);
                });
            } catch (err) {
                grid.innerHTML = '<div class="loading-state">Unable to load recommendations. Please check your internet connection or browser console (F12).</div>';
            }
        }

        document.getElementById('genre-filter').addEventListener('change', loadMovies);
        document.getElementById('lang-filter').addEventListener('change', loadMovies);
        
        loadMovies();
    </script>
</body>
</html>
