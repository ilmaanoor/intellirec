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
            min-height: 480px; /* Ensure cards have height */
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
            background: #f0f0f0;
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
            z-index: 10;
        }

        .travel-meta { padding: 24px; }

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

        /* Loading */
        .loading-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 80px 20px;
            color: var(--text-muted);
            font-weight: 600;
        }

        .loading-spinner {
            display: inline-block;
            width: 48px;
            height: 48px;
            border: 4px solid rgba(0, 166, 153, 0.15);
            border-top-color: #00A699;
            border-radius: 50%;
            animation: spin 0.9s linear infinite;
            margin-bottom: 18px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Result count badge */
        .result-count {
            text-align: center;
            margin: -30px auto 30px;
            font-size: 13px;
            font-weight: 700;
            color: #00A699;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* Search button */
        .search-btn {
            background: linear-gradient(135deg, #00A699, #00BFB3);
            color: white;
            border: none;
            padding: 14px 28px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 166, 153, 0.35);
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

    <!-- Filter & Search Bar -->
    <div class="filter-section" style="max-width: 860px; display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
        <div class="filter-group" style="flex: 2; min-width: 200px;">
            <label>Search Destination</label>
            <input type="text" id="travel-search" class="form-control"
                   placeholder="e.g. Paris, Bali, Swiss Alps, Taj Mahal..." style="width: 100%;"
                   oninput="onSearchInput(this.value)">
        </div>
        <div class="filter-group" style="flex: 1; min-width: 150px;">
            <label>Travel Purpose</label>
            <select id="purpose-filter" class="form-control">
                <option value="Vacation">&#127958; Relaxing Vacation</option>
                <option value="Adventure">&#127956; Adventure &amp; Sports</option>
                <option value="Culture">&#127981; Cultural Discovery</option>
                <option value="Food">&#127860; Food &amp; Nightlife</option>
            </select>
        </div>
        <div class="filter-group">
            <label style="visibility:hidden;">Go</label>
            <button class="search-btn" onclick="loadTravel()">&#128269; Search</button>
        </div>
    </div>

    <!-- Result count badge -->
    <div id="result-count" class="result-count" style="display:none;"></div>

    <!-- Results Grid -->
    <div id="travel-grid" class="travel-grid">
        <div class="loading-state">
            <div class="loading-spinner"></div>
            <p>Consulting global experts...</p>
        </div>
    </div>

    <footer class="footer-site">
        Powered by IntelliRec AI &bull; Real-Time Data via TripAdvisor
    </footer>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js?v=21.0"></script>
    <script>
        firebase.auth().onAuthStateChanged((user) => {
            if (user) {
                const name = user.displayName || user.email.split('@')[0];
                document.getElementById('user-avatar').src =
                    'https://ui-avatars.com/api/?background=F9A825&color=white&bold=true&name=' + encodeURIComponent(name);
            }
        });

        // Rotating status messages shown during TripAdvisor load
        var loadingMessages = [
            '&#127758; Connecting to TripAdvisor travel database...',
            '&#128269; Scanning global destinations...',
            '&#128240; Fetching real descriptions and verified images...',
            '&#9989; Curating your personalized results...'
        ];

        function showLoadingAnimation() {
            var grid = document.getElementById('travel-grid');
            var countEl = document.getElementById('result-count');
            if (countEl) countEl.style.display = 'none';
            var msgIndex = 0;
            grid.innerHTML = '<div class="loading-state" id="loading-msg">' +
                '<div class="loading-spinner"></div>' +
                '<p>' + loadingMessages[0] + '</p></div>';
            
            return setInterval(function() {
                msgIndex = (msgIndex + 1) % loadingMessages.length;
                var el = document.getElementById('loading-msg');
                if (el) el.querySelector('p').innerHTML = loadingMessages[msgIndex];
            }, 1200);
        }

        let _debounceTimer = null;

        function onSearchInput(value) {
            clearTimeout(_debounceTimer);
            
            // Only fires 600ms AFTER user stops typing
            _debounceTimer = setTimeout(() => {
                loadTravel();
            }, 600);
        }

        async function loadTravel() {
            var grid    = document.getElementById('travel-grid');
            var purpose = document.getElementById('purpose-filter').value;
            var query   = document.getElementById('travel-search').value;
            var countEl = document.getElementById('result-count');
            var intervalId = showLoadingAnimation();

            try {
                var destinations = await ApiClient.getTravel(purpose, query);
                clearInterval(intervalId);
                grid.innerHTML = '';

                if (!destinations || destinations.length === 0) {
                    if (countEl) countEl.style.display = 'none';
                    grid.innerHTML = '<div class="loading-state">&#128533; No destinations found. Try a different search term.</div>';
                    return;
                }

                // Show count badge
                if (countEl) {
                    countEl.textContent = '\u2713 Found ' + destinations.length + ' destination' + (destinations.length !== 1 ? 's' : '');
                    countEl.style.display = 'block';
                }

                destinations.forEach(function(dest) {
                    var card = document.createElement('div');
                    card.className = 'travel-card';

                    var ratingNumeric = parseFloat(dest.rating) || 4;
                    var stars = '\u2605'.repeat(Math.min(5, Math.round(ratingNumeric)));

                    // Use Unsplash as fallback image
                    var imgSrc = (dest.img && dest.img.length > 15)
                        ? dest.img
                        : 'https://source.unsplash.com/800x600/?' + encodeURIComponent(dest.place) + ',travel';

                    var cardHtml = '<div class="tripadvisor-tag">TRIPADVISOR <span style="color:#00A699;font-size:10px;font-weight:bold;">[LIVE]</span></div>' +
                        '<img src="' + imgSrc + '" alt="' + dest.place + '" class="travel-thumb" ' +
                        'onerror="this.src=\'https://source.unsplash.com/800x600/?travel,world,destination\'">' +
                        '<div class="travel-meta">' +
                        '<span class="place-type">' + dest.type + '</span>' +
                        '<h3 class="place-name">' + dest.place + '</h3>' +
                        '<p style="font-size:14px;color:var(--text-muted);line-height:1.6;margin-bottom:15px;">' + dest.description + '</p>' +
                        '<div class="travel-footer">' +
                        '<div class="rating-dots">' + stars + ' <span style="font-size:12px;color:#888;margin-left:4px;">' + dest.rating + '</span></div>' +
                        '<a href="' + dest.tripadvisorUrl + '" target="_blank" class="explore-link">Explore on TripAdvisor &#8599;</a>' +
                        '</div></div>';
                    
                    card.innerHTML = cardHtml;
                    grid.appendChild(card);
                });

            } catch (err) {
                clearInterval(intervalId);
                if (countEl) countEl.style.display = 'none';
                grid.innerHTML = '<div class="loading-state">&#10060; Failed to load destinations. Please refresh.</div>';
                console.error('[Travel] loadTravel error:', err);
            }
        }

        document.getElementById('purpose-filter').addEventListener('change', loadTravel);
        // Removed keypress Enter listener since we now use the debounced oninput directly on the field

        // Auto-load on page open
        loadTravel();
    </script>
</body>
</html>
