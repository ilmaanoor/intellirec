<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Movies - Intellirec AI</title>
    <link rel="stylesheet" href="css/style_v1.css">
    <style>
        .filter-bar {
            background: white;
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 3rem;
            display: flex;
            gap: 2rem;
            align-items: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 2rem;
        }
        .movie-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            transition: var(--transition);
            border: 1px solid #EEE;
        }
        .movie-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(255, 215, 0, 0.2);
        }
        .movie-img {
            width: 100%;
            height: 320px;
            object-fit: crop;
            background: #f0f0f0;
        }
        .movie-info {
            padding: 1.2rem;
        }
        .movie-info h4 { margin: 0 0 0.5rem; font-size: 1.2rem; }
        .movie-info .tag {
            background: var(--bg-light);
            padding: 0.2rem 0.6rem;
            border-radius: 5px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .loading-spinner {
            grid-column: 1 / -1;
            text-align: center;
            padding: 4rem;
            font-size: 1.5rem;
            color: var(--text-muted);
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <a href="index.jsp" class="logo">Intelli<span>Rec</span></a>
            <nav class="nav-links">
                <a href="categories.jsp">Back</a>
                <a href="#" id="logout-btn">Logout</a>
            </nav>
        </header>

        <section class="hero" style="padding: 2rem 0;">
            <h1>Netflix Recommendations</h1>
            <p>Trending hits and personalized suggestions just for you.</p>
        </section>

        <div class="filter-bar">
            <div class="form-group" style="margin: 0; flex: 1;">
                <label style="margin-bottom: 0.5rem; font-size: 0.9rem;">Select Genre</label>
                <select id="genre-filter" class="form-control">
                    <option value="All">All Genres</option>
                    <option value="Action">Action</option>
                    <option value="Sci-Fi">Sci-Fi</option>
                    <option value="Comedy">Comedy</option>
                    <option value="Drama">Drama</option>
                </select>
            </div>
            <div class="form-group" style="margin: 0; flex: 1;">
                <label style="margin-bottom: 0.5rem; font-size: 0.9rem;">Language</label>
                <select id="lang-filter" class="form-control">
                    <option value="English">English</option>
                    <option value="Spanish">Spanish</option>
                    <option value="Hindi">Hindi</option>
                </select>
            </div>
        </div>

        <div id="movie-grid" class="movie-grid">
            <!-- Dynamically populated -->
            <div class="loading-spinner">Loading recommendations...</div>
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js"></script>
    <script>
        async function loadMovies() {
            const grid = document.getElementById('movie-grid');
            const genre = document.getElementById('genre-filter').value;
            const lang = document.getElementById('lang-filter').value;

            grid.innerHTML = '<div class="loading-spinner">Analyzing your taste...</div>';

            try {
                const movies = await ApiClient.getMovies(genre, lang);
                grid.innerHTML = '';
                
                movies.forEach(movie => {
                    const card = document.createElement('div');
                    card.className = 'movie-card';
                    card.innerHTML = `
                        <img src="\${movie.img}" alt="\${movie.title}" class="movie-img">
                        <div class="movie-info">
                            <span class="tag">Netflix Original</span>
                            <h4>\${movie.title}</h4>
                            <div style="display:flex; justify-content:space-between; align-items:center;">
                                <span style="font-size:0.9rem; color:var(--text-muted);">\${movie.genre}</span>
                                <span style="color:#ffd700;">★ \${movie.rating}</span>
                            </div>
                        </div>
                    `;
                    grid.appendChild(card);
                });
            } catch (err) {
                grid.innerHTML = '<div class="loading-spinner">Failed to load content. Please try again.</div>';
            }
        }

        document.getElementById('genre-filter').addEventListener('change', loadMovies);
        document.getElementById('lang-filter').addEventListener('change', loadMovies);
        
        // Initial load
        window.addEventListener('DOMContentLoaded', loadMovies);
    </script>
</body>
</html>
