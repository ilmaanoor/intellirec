<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Travel discovery - IntelliRec AI</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/travel.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
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
        <h1>Travel Discovery</h1>
        <p>Real-time destination recommendations powered by OpenTripMap.</p>
    </div>

    <div class="filter-section" style="max-width: 1000px; display: flex; flex-direction: column; gap: 20px;">
        <div style="display: flex; gap: 20px; align-items: flex-end; flex-wrap: wrap;">
            <div class="filter-group" style="flex: 2; min-width: 300px;">
                <label>Search City or Destination</label>
                <div style="position: relative;">
                    <input type="text" id="travelSearchInput" class="form-control" placeholder="e.g. Paris, Tokyo, Bali..." style="padding-left: 35px; width: 100%;">
                    <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); opacity: 0.5;"></i>
                </div>
            </div>
            <div class="filter-group" style="flex: 1; min-width: 250px;">
                <label>Trip Type</label>
                <div class="filter-pills" id="purpose-filters">
                    <button class="pill active" data-purpose="Relaxing Vacation">
                        <i class="fa-solid fa-umbrella-beach"></i> Relaxing
                    </button>
                    <button class="pill" data-purpose="Adventure & Sports">
                        <i class="fa-solid fa-person-hiking"></i> Adventure
                    </button>
                    <button class="pill" data-purpose="Cultural Discovery">
                        <i class="fa-solid fa-landmark"></i> Cultural
                    </button>
                    <button class="pill" data-purpose="Food & Nightlife">
                        <i class="fa-solid fa-utensils"></i> Nightlife
                    </button>
                </div>
            </div>
            <div class="filter-group" style="flex: 0; min-width: 120px;">
                <button id="travelSearchBtn" class="btn-primary-site" style="width: 100%; border-radius: 15px; padding: 12px;">
                    Search
                </button>
            </div>
        </div>
        
        <div class="results-meta" style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border-light); padding-top: 15px;">
            <div>
                <span id="resultsCount" class="results-count"></span>
                <span id="resultsPurpose" class="results-purpose"></span>
            </div>
            <div id="apiCallsLeft" class="api-budget-badge">
                <i class="fa-solid fa-bolt"></i>
                <span id="callsLeftText">—</span> discovery slots left today
            </div>
        </div>
    </div>

    <!-- Status States -->
    <div id="travelLoading" class="loading-state" style="display:none;">
        <div class="loader-ring"></div>
        <p>Exploring the globe for you...</p>
    </div>

    <div id="travelError" class="error-state" style="display:none;">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <p id="travelErrorMsg">Something went wrong.</p>
        <button onclick="retrySearch()" class="btn-primary-site">Retry</button>
    </div>

    <div id="travelEmpty" class="empty-state" style="display:none;">
        <i class="fa-solid fa-map-location-dot"></i>
        <p>No destinations found. Try another search!</p>
    </div>

    <!-- Results Grid -->
    <div id="travel-grid" class="travel-grid"></div>

    <footer class="footer-site">
        Powered by IntelliRec AI • Live OpenTripMap Connection
    </footer>

    <!-- Destination Detail Modal -->
    <div id="destModal" class="modal-overlay" style="display:none;">
        <div class="modal-card">
            <button class="modal-close" onclick="closeModal()">
                <i class="fa-solid fa-xmark"></i>
            </button>
            <div class="modal-img-wrap">
                <img id="modalImg" src="" alt="Destination"/>
                <div class="modal-img-overlay">
                    <span id="modalRatingBadge" class="modal-rating">
                        <i class="fa-solid fa-star"></i>
                        <span id="modalRating"></span>
                    </span>
                </div>
            </div>
            <div class="modal-body">
                <h2 id="modalTitle"></h2>
                <div style="display: flex; gap: 10px; align-items: center; margin-bottom: 15px;">
                    <span id="modalType" class="card-type-badge"></span>
                    <span class="spotify-tag" style="background:var(--primary);">OTM VERIFIED</span>
                </div>
                <p id="modalDesc" class="card-desc" style="font-size: 1rem;"></p>
                <a id="modalExploreBtn" href="#" target="_blank" class="btn-primary-site" style="margin-top: 1rem;">
                    <i class="fa-solid fa-compass"></i> Explore Destination
                </a>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js?v=17.1"></script>
    <script src="js/travel.js"></script>

</body>
</html>
