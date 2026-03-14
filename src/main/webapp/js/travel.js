/**
 * IntelliRec — Travel Page Controller
 * Handles UI, filter pills, search, card rendering, modal
 */

// ─── State ───────────────────────────────────────────
let currentPurpose = 'Relaxing Vacation';
let currentQuery   = '';
let debounceTimer  = null;

// ─── Init on page load ───────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
    updateBudgetBadge();
    loadTravel(currentPurpose, '');

    // User Avatar Sync
    firebase.auth().onAuthStateChanged((user) => {
        if (user) {
            const name = user.displayName || user.email.split('@')[0];
            document.getElementById('user-avatar').src = `https://ui-avatars.com/api/?background=F9A825&color=white&bold=true&name=${name}`;

            // Show Admin Link if eligible
            if (user.email.includes('admin') || user.email === 'admin@intellirec.com') {
                if (document.getElementById('admin-nav-item')) {
                    document.getElementById('admin-nav-item').style.display = 'block';
                }
            }
        }
    });

    // Filter pill clicks
    document.querySelectorAll('.pill').forEach(pill => {
        pill.addEventListener('click', () => {
            document.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
            pill.classList.add('active');
            currentPurpose = pill.dataset.purpose;
            currentQuery   = '';
            document.getElementById('travelSearchInput').value = '';
            loadTravel(currentPurpose, '');
        });
    });

    // Search button click
    document.getElementById('travelSearchBtn').addEventListener('click', () => {
        const val = document.getElementById('travelSearchInput').value.trim();
        currentQuery = val;
        loadTravel(currentPurpose, currentQuery);
    });

    // Search on Enter key
    document.getElementById('travelSearchInput').addEventListener('keydown', e => {
        if (e.key === 'Enter') {
            const val = e.target.value.trim();
            currentQuery = val;
            loadTravel(currentPurpose, currentQuery);
        }
    });

    // Close modal on overlay click
    document.getElementById('destModal').addEventListener('click', e => {
        if (e.target === document.getElementById('destModal')) closeModal();
    });

    // Close modal on Escape key
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') closeModal();
    });
});

// ─── Main Load Function ──────────────────────────────
async function loadTravel(purpose, query) {
    console.log(`[Travel] Loading: ${purpose}, Query: "${query}"`);
    const grid = document.getElementById('travel-grid');
    
    showLoading(true);
    hideStates();

    try {
        const results = await ApiClient.getTravel(purpose, query);
        console.log(`[Travel] Results received:`, results);

        showLoading(false);

        // Budget check
        const callCount = parseInt(localStorage.getItem('travel_api_calls') || '0');
        if (callCount >= 100) {
            console.error('[Travel] Daily budget of 100 calls reached.');
            showError('Daily discovery limit reached (100/100). Please try again tomorrow.');
            updateBudgetBadge();
            return;
        }

        if (!results || results.length === 0) {
            console.warn('[Travel] No results found.');
            document.getElementById('travelEmpty').style.display = 'flex';
            updateHeader(0, purpose, query);
            return;
        }

        renderCards(results);
        updateHeader(results.length, purpose, query);
        updateBudgetBadge();

        console.log(`[Travel] Rendered children: ${grid.children.length}`);

    } catch (err) {
        showLoading(false);
        showError('Unable to load destinations. Please check your connection.');
        console.error('[Travel Page] Load error:', err);
    }
}

// ─── Render Cards ────────────────────────────────────
function renderCards(destinations) {
    const grid = document.getElementById('travel-grid');
    grid.innerHTML = '';

    destinations.forEach((dest, index) => {
        const card = document.createElement('div');
        card.className = 'travel-card';

        const ratingNum  = parseFloat(dest.rating) || 0;
        const starsHtml  = buildStars(ratingNum);
        const typeBadge  = dest.type ? `<span class="card-type-badge">${dest.type}</span>` : '';

        card.innerHTML = `
            <div class="card-img-wrap">
                <img
                    src="${dest.img}"
                    alt="${escapeHtml(dest.place)}"
                    loading="lazy"
                    onerror="this.src='https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800'"
                >
                <div class="card-img-overlay">
                    ${typeBadge}
                    <div class="card-rating">
                        <i class="fa-solid fa-star"></i>
                        ${dest.rating || 'N/A'}
                    </div>
                </div>
            </div>
            <div class="card-body">
                <h3 class="card-title">${escapeHtml(dest.place)}</h3>
                <div class="card-stars">${starsHtml}</div>
                <p class="card-desc">${escapeHtml(truncate(dest.description, 120))}</p>
                <div class="card-footer">
                    <button class="card-details-btn" onclick='showDetails(${JSON.stringify(dest).replace(/'/g, "&apos;")})'>
                        View Details
                    </button>
                    <a href="${dest.exploreUrl || dest.tripadvisorUrl || '#'}" target="_blank" class="card-explore-btn">
                        Explore
                    </a>
                </div>
            </div>
        `;

        grid.appendChild(card);
    });
}

// ─── Modal ───────────────────────────────────────────
function showDetails(dest) {
    document.getElementById('modalImg').src = dest.img;
    document.getElementById('modalTitle').textContent = dest.place;
    document.getElementById('modalRating').textContent = dest.rating || 'N/A';
    document.getElementById('modalType').textContent = dest.type || 'Attraction';
    document.getElementById('modalDesc').textContent = dest.description;
    document.getElementById('modalExploreBtn').href = dest.exploreUrl || dest.tripadvisorUrl || '#';

    document.getElementById('destModal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

function closeModal() {
    document.getElementById('destModal').style.display = 'none';
    document.body.style.overflow = '';
}

// ─── UI Helpers ──────────────────────────────────────
function showLoading(show) {
    document.getElementById('travelLoading').style.display = show ? 'block' : 'none';
    document.getElementById('travel-grid').style.display   = show ? 'none' : 'grid';
}

function hideStates() {
    document.getElementById('travelError').style.display = 'none';
    document.getElementById('travelEmpty').style.display = 'none';
}

function showError(msg) {
    document.getElementById('travelErrorMsg').textContent = msg;
    document.getElementById('travelError').style.display  = 'block';
    document.getElementById('travel-grid').style.display  = 'none';
}

function retrySearch() {
    loadTravel(currentPurpose, currentQuery);
}

function updateHeader(count, purpose, query) {
    document.getElementById('resultsCount').textContent = count > 0 ? `${count} destinations found` : '';
    document.getElementById('resultsPurpose').textContent = query ? `for "${query}"` : `· ${purpose}`;
}

function updateBudgetBadge() {
    const count = parseInt(localStorage.getItem('travel_api_calls') || '0');
    const left  = Math.max(0, 100 - count);
    document.getElementById('callsLeftText').textContent = left;
}

function buildStars(ratingOutOf10) {
    const stars = Math.round((ratingOutOf10 / 10) * 5 * 2) / 2;
    let html = '';
    for (let i = 1; i <= 5; i++) {
        if (stars >= i) html += '<i class="fa-solid fa-star"></i>';
        else if (stars >= i - 0.5) html += '<i class="fa-solid fa-star-half-stroke"></i>';
        else html += '<i class="fa-regular fa-star"></i>';
    }
    return html;
}

function truncate(str, maxLen) {
    if (!str) return '';
    return str.length > maxLen ? str.substring(0, maxLen) + '...' : str;
}

function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
