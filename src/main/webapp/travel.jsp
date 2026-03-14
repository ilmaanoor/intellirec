<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>IntelliRec — Travel</title>
    <link rel="stylesheet" href="css/global.css"/>
    <link rel="stylesheet" href="css/travel.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>

<!-- ═══════════════════════════════════════════
     GLOBAL NAVBAR
════════════════════════════════════════════ -->
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

<!-- ═══════════════════════════════════════════
     HERO SECTION
════════════════════════════════════════════ -->
<section class="travel-hero" style="margin-top: 100px;">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1><i class="fa-solid fa-earth-americas"></i> Discover Your Next Adventure</h1>
        <p>Real-time destination recommendations powered by OpenTripMap</p>

        <!-- SEARCH BAR -->
        <div class="search-bar">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input
                type="text"
                id="travelSearchInput"
                placeholder="Search a city or destination... (e.g. Paris, Bali)"
                autocomplete="off"
            />
            <button id="travelSearchBtn">
                <i class="fa-solid fa-paper-plane"></i> Search
            </button>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════
     FILTER BAR
════════════════════════════════════════════ -->
<section class="filter-section">
    <div class="filter-container">
        <span class="filter-label">
            <i class="fa-solid fa-sliders"></i> Trip Type
        </span>
        <div class="filter-pills">
            <button class="pill active" data-purpose="Relaxing Vacation">
                <i class="fa-solid fa-umbrella-beach"></i> Relaxing Vacation
            </button>
            <button class="pill" data-purpose="Adventure & Sports">
                <i class="fa-solid fa-person-hiking"></i> Adventure & Sports
            </button>
            <button class="pill" data-purpose="Cultural Discovery">
                <i class="fa-solid fa-landmark"></i> Cultural Discovery
            </button>
            <button class="pill" data-purpose="Food & Nightlife">
                <i class="fa-solid fa-utensils"></i> Food & Nightlife
            </button>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════
     RESULTS SECTION
════════════════════════════════════════════ -->
<section class="results-section">

    <!-- Status Bar -->
    <div class="results-header">
        <div class="results-meta">
            <span id="resultsCount" class="results-count"></span>
            <span id="resultsPurpose" class="results-purpose"></span>
        </div>
        <div class="results-actions">
            <span id="apiCallsLeft" class="api-budget-badge">
                <i class="fa-solid fa-bolt"></i>
                <span id="callsLeftText">—</span> calls left today
            </span>
        </div>
    </div>

    <!-- Loading State -->
    <div id="travelLoading" class="loading-state" style="display:none;">
        <div class="loader-ring"></div>
        <p>Finding destinations for you...</p>
    </div>

    <!-- Error State -->
    <div id="travelError" class="error-state" style="display:none;">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <p id="travelErrorMsg">Something went wrong. Please try again.</p>
        <button onclick="retrySearch()">
            <i class="fa-solid fa-rotate-right"></i> Retry
        </button>
    </div>

    <!-- Empty State -->
    <div id="travelEmpty" class="empty-state" style="display:none;">
        <i class="fa-solid fa-map-location-dot"></i>
        <p>No destinations found. Try a different search or category.</p>
    </div>

    <!-- Results Grid -->
    <div id="travelGrid" class="travel-grid"></div>

</section>

<!-- ═══════════════════════════════════════════
     DESTINATION DETAIL MODAL
════════════════════════════════════════════ -->
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
            <p id="modalType" class="modal-type-badge"></p>
            <p id="modalDesc" class="modal-desc"></p>
            <a id="modalExploreBtn" href="#" target="_blank" class="modal-explore-btn">
                <i class="fa-solid fa-compass"></i> Explore Destination
            </a>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="js/api.js"></script>
<script src="js/travel.js"></script>

</body>
</html>
