<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Travel - IntelliRec AI</title>
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

        .travel-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto 60px;
            padding: 0 20px;
        }

        .travel-card {
            background: white;
            border-radius: 24px;
            overflow: hidden;
            transition: var(--transition-smooth);
            border: 1px solid rgba(0,0,0,0.03);
            position: relative;
        }

        .travel-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0, 166, 153, 0.1);
            border-color: #00A699;
        }

        .travel-thumb {
            width: 100%;
            height: 240px;
            object-fit: cover;
        }

        .tripadvisor-tag {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #34E0A1;
            color: #000;
            font-size: 10px;
            font-weight: 800;
            padding: 4px 12px;
            border-radius: 50px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .travel-meta {
            padding: 24px;
        }

        .place-type {
            font-size: 11px;
            font-weight: 800;
            color: #00A699;
            text-transform: uppercase;
            margin-bottom: 8px;
            display: block;
        }

        .place-name {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 12px;
            color: var(--text-dark);
        }

        .travel-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #F0F0F0;
            padding-top: 15px;
            margin-top: 15px;
        }

        .rating-dots {
            color: #34E0A1;
            font-size: 14px;
            letter-spacing: 2px;
        }

        .explore-link {
            font-weight: 700;
            color: #00A699;
            text-decoration: none;
            font-size: 14px;
        }

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
            <li><a href="songs.jsp">Songs</a></li>
            <li><a href="gifts.jsp">Gifts</a></li>
            <li><a href="travel.jsp" class="active">Travel</a></li>
        </ul>
        <div class="nav-user">
            <img id="user-avatar" src="https://ui-avatars.com/api/?background=F9A825&color=white&name=User" alt="Avatar">
            <a href="#" id="logout-btn" class="btn-logout-nav" title="Sign Out">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            </a>
        </div>
    </nav>

    <div class="page-header">
        <h1>Global Destinations</h1>
        <p>Your personalized passport to the world's most incredible places.</p>
    </div>

    <div class="filter-section">
        <div class="filter-group">
            <label>Whats your Travel Purpose?</label>
            <select id="purpose-filter" class="form-control">
                <option value="Vacation">Relaxing Vacation</option>
                <option value="Adventure">Adventure & Sports</option>
                <option value="Culture">Cultural Discovery</option>
                <option value="Food">Food & Nightlife</option>
            </select>
        </div>
    </div>

    <div id="travel-grid" class="travel-grid">
        <div class="loading-state">Consulting global experts...</div>
    </div>

    <footer class="footer-site">
        Powered by IntelliRec AI • Connected to TripAdvisor
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

        async function loadTravel() {
            const grid = document.getElementById('travel-grid');
            const purpose = document.getElementById('purpose-filter').value;

            grid.innerHTML = '<div class="loading-state">Consulting local experts...</div>';

            try {
                const destinations = await ApiClient.getTravel(purpose);
                grid.innerHTML = '';
                
                destinations.forEach(dest => {
                    const card = document.createElement('div');
                    card.className = 'travel-card';
                    const sourceBadge = '<span style="color: #00A699; font-size: 10px; font-weight: bold;">[REAL TIME]</span>';
                    
                    card.innerHTML = `
                        <div class="tripadvisor-tag">TRIPADVISOR \${sourceBadge}</div>
                        <img src="\${dest.img}" alt="\${dest.place}" class="travel-thumb">
                        <div class="travel-meta">
                            <span class="place-type">\${dest.type}</span>
                            <h3 class="place-name">\${dest.place}</h3>
                            <p style="font-size:14px; color:var(--text-muted); line-height:1.5; margin-bottom:15px;">
                                Experience the best of \${dest.place}, curated for \${purpose.toLowerCase()} lovers.
                            </p>
                            <div class="travel-footer">
                                <div class="rating-dots">●●●●●</div>
                                <a href="\${dest.tripadvisorUrl}" target="_blank" class="explore-link">Explore Details</a>
                            </div>
                        </div>
                    `;
                    grid.appendChild(card);
                });
            } catch (err) {
                grid.innerHTML = '<div class="loading-state">Failed to map destinations. Please refresh.</div>';
            }
        }

        document.getElementById('purpose-filter').addEventListener('change', loadTravel);
        loadTravel();
    </script>
</body>
</html>
