/**
 * Intellirec AI - Central API Client v17.1 - FULLY REAL-TIME
 * All four recommendation engines now pull live data dynamically based on user filters.
 * Features: Daily Budget Guard, OTM Source Alignment, Tab Visibility Check.
 */

const API_CONFIG = {
    TMDB_API_KEY: 'e226f4a5f5bace766952aa0d17182959',
    IMAGE_BASE_URL: 'https://images.weserv.nl/?url=https://image.tmdb.org/t/p/w500',
    NETFLIX_PROVIDER_ID: 8,
    AMAZON_PARTNER_TAG: 'YOUR_AMAZON_TAG'
};

const ApiClient = {
    _lastError: null,

    // ✅ Bug 2 Fixed — cache properly initialized
    _travelCache: {},
    _apiCallTracker: {
        count: parseInt(localStorage.getItem('travel_api_calls') || '0'),
        date:  localStorage.getItem('travel_api_date') || '',
        DAILY_LIMIT: 100  // self-imposed safety limit, well under 5000
    },

    /**
     * MOVIES - Real-time TMDB Search or Discover
     * If searchQuery is provided, uses TMDB Search. Otherwise uses Discover.
     */
    async getMovies(genre = 'All', language = 'English', searchQuery = '') {
        const genreMap = {
            'Action': 28, 'Sci-Fi': 878, 'Comedy': 35, 'Drama': 18,
            'Fantasy': 14, 'Thriller': 53, 'Romance': 10749
        };
        const langMap = {
            'English': { apiLang: 'en-US', origLang: 'en' },
            'Hindi':   { apiLang: 'hi-IN', origLang: 'hi' },
            'Tamil':   { apiLang: 'ta-IN', origLang: 'ta' },
            'Telugu':  { apiLang: 'te-IN', origLang: 'te' },
            'Korean':  { apiLang: 'ko-KR', origLang: 'ko' }
        };

        const proxyBase = `${window.location.origin}/intellirec/proxy.jsp`;
        
        try {
            let finalResults = [];

            if (searchQuery && searchQuery.trim() !== '') {
                // LIVE SEARCH MODE
                console.log(`[Movies] Searching for: "${searchQuery}"...`);
                const params = new URLSearchParams({
                    api_key: API_CONFIG.TMDB_API_KEY,
                    query: searchQuery,
                    language: langMap[language]?.apiLang || 'en-US'
                }).toString();
                
                // Use proxy to call search endpoint
                const searchProxyUrl = `https://api.tmdb.org/3/search/movie?${params}`;
                const res = await fetch(`${proxyBase}?targetUrl=${encodeURIComponent(searchProxyUrl)}`);
                const data = await res.json();
                if (data.results) finalResults = data.results;
            } else {
                // DISCOVERY MODE (Existing logic)
                const genreId = genreMap[genre] || '';
                const langConfig = langMap[language] || langMap['English'];
                const page = Math.floor(Math.random() * 5) + 1;

                const baseParams = {
                    api_key: API_CONFIG.TMDB_API_KEY,
                    language: langConfig.apiLang,
                    with_original_language: langConfig.origLang,
                    sort_by: 'popularity.desc',
                    page: page
                };
                if (genreId) baseParams.with_genres = genreId;

                const sleep = ms => new Promise(r => setTimeout(r, ms));
                
                // Stage 1: Netflix India
                console.log(`[Movies] Discovering ${genre}/${language} (page ${page})...`);
                let params = new URLSearchParams({...baseParams, with_watch_providers: 8, watch_region: 'IN'}).toString();
                let res = await fetch(`${proxyBase}?${params}`);
                let data;
                try { data = await res.json(); } catch(e) { data = { results: [] }; }
                if (data.results && data.results.length > 0) finalResults = data.results;

                if (finalResults.length < 4) {
                    await sleep(500);
                    params = new URLSearchParams({...baseParams, with_watch_providers: 8}).toString();
                    res = await fetch(`${proxyBase}?${params}`);
                    try { data = await res.json(); } catch(e) { data = { results: [] }; }
                    if (data.results) finalResults = [...finalResults, ...data.results.filter(nr => !finalResults.some(fr => fr.id === nr.id))];
                }
            }

            if (!finalResults || finalResults.length === 0) return [];

            this._lastError = null;
            return finalResults.slice(0, 12).map(m => ({
                id: m.id,
                title: m.title || m.name,
                genre: genre,
                year: m.release_date ? m.release_date.substring(0, 4) : '',
                rating: (m.vote_average || 0).toFixed(1),
                img: m.poster_path
                    ? `${API_CONFIG.IMAGE_BASE_URL}${m.poster_path}`
                    : 'https://via.placeholder.com/500x750?text=No+Poster'
            }));
        } catch (err) {
            console.error('getMovies Exception:', err);
            this._lastError = 'Error: ' + err.message;
            return [];
        }
    },

    /**
     * SONGS - Real-time iTunes Search API
     * Searches by the user's language + mood or specific keyword.
     */
    async getSongs(language = 'English', mood = 'Happy', searchQuery = '') {
        const countryMap = {
            'English': 'US', 'Hindi': 'IN', 'Korean': 'KR', 'Chinese': 'TW', 'Tamil': 'IN'
        };

        const searchTerms = {
            'English': {
                'Happy':    ['happy pop hits', 'upbeat pop songs'],
                'Chill':    ['chill pop', 'relaxing pop music'],
                'Focus':    ['focus study music', 'ambient electronic'],
                'Workout':  ['workout gym music', 'energy workout songs'],
                'Romantic': ['romantic pop songs', 'love songs english']
            },
            'Hindi': {
                'Happy':    ['Hindi pop songs', 'new Hindi songs'],
                'Chill':    ['Hindi chill songs', 'indie Hindi music'],
                'Focus':    ['Hindi instrumental', 'Indian classical music'],
                'Workout':  ['Hindi workout songs', 'desi beats'],
                'Romantic': ['Hindi romantic songs', 'Bollywood love songs']
            }
        };

        const country = countryMap[language] || 'US';
        let term;

        if (searchQuery && searchQuery.trim() !== '') {
            term = searchQuery.trim();
        } else {
            const langTerms = searchTerms[language] || searchTerms['English'];
            const moodTerms = langTerms[mood] || langTerms['Happy'];
            term = moodTerms[Math.floor(Math.random() * moodTerms.length)];
        }

        const itunesUrl = `https://itunes.apple.com/search?term=${encodeURIComponent(term)}&country=${country}&media=music&entity=song&limit=50`;
        const proxyUrl = `${window.location.origin}/intellirec/proxy.jsp?targetUrl=${encodeURIComponent(itunesUrl)}`;

        console.log(`[Songs] Searching iTunes for: "${term}"...`);
        try {
            const res = await fetch(proxyUrl);
            const data = await res.json();

            if (data.results && data.results.length > 0) {
                const shuffled = data.results.sort(() => 0.5 - Math.random());
                return shuffled.slice(0, 12).map(t => ({
                    id: t.trackId,
                    title: t.trackName,
                    artist: t.artistName,
                    album: t.collectionName,
                    img: t.artworkUrl100 ? t.artworkUrl100.replace('100x100bb', '600x600bb') : 'https://via.placeholder.com/600',
                    url: t.trackViewUrl,
                    preview: t.previewUrl
                }));
            }
            return [];
        } catch (err) {
            console.error('[Songs] iTunes Exception:', err);
            return [];
        }
    },

    /**
     * GIFTS - REAL-TIME SCRAPER (Amazon & Flipkart)
     * Calls our local Java MarketSearchServlet which performs live scraping.
     */
    async getGifts(recipient = 'Friend', occasion = 'Birthday', searchQuery = '') {
        const keywordMap = {
            'Friend': { 'Birthday': 'cool gadget gift' },
            'Partner': { 'Birthday': 'romantic gift' },
            'Family': { 'Birthday': 'home decor' }
        };

        let query = searchQuery;
        if (!query || query.trim() === '') {
            const safeRecipient = keywordMap[recipient] ? recipient : 'Friend';
            query = (keywordMap[safeRecipient][occasion] || keywordMap[safeRecipient]['Birthday']) + ' for ' + recipient;
        }

        console.log(`[Gifts] Scraper Search for: "${query}"...`);

        try {
            const res = await fetch(`${window.location.origin}/intellirec/market-search?q=${encodeURIComponent(query)}`);
            const data = await res.json();

            if (data.error) throw new Error(data.error);

            // Merge Amazon and Flipkart results
            const allItems = [...(data.amazon || []), ...(data.flipkart || [])];
            
            // Randomize for fresh feel
            const shuffled = allItems.sort(() => 0.5 - Math.random());

            return shuffled.slice(0, 12).map((p, idx) => ({
                id: 'scraped-' + idx,
                name: p.title,
                category: p.source.toUpperCase() + ' MATCH',
                price: `₹${Math.round(p.price).toLocaleString('en-IN')}`,
                img: p.img || 'https://via.placeholder.com/400x400?text=No+Preview',
                amazonUrl: p.url
            }));
        } catch (e) {
            console.error('[Gifts] Scraper Exception:', e);
            return [];
        }
    },

    /**
     * ============================================================
     * SAFETY FILTER — Zero tolerance adult content block
     * ============================================================
     */
    _isSafeTravelContent(text) {
        if (!text) return true;
        const low = text.toLowerCase();

        const blockedPatterns = [
            /\bnude(s|ism|ist)?\b/,
            /\bnaturis(m|t)\b/,
            /\bporn(o|ography)?\b/,
            /\bx-rated\b/,
            /\bexplicit\b/,
            /\bhentai\b/,
            /\berotic(a)?\b/,
            /\bsensual\b/,
            /\bsexual\b/,
            /\bescort(s|ing)?\b/,
            /\bprostitut(e|ion|ed)\b/,
            /\bbrothel\b/,
            /\bstripper\b/,
            /\bstrip\s*club\b/,
            /\bstriptease\b/,
            /\bcam\s*girl\b/,
            /\bonlyfans\b/,
            /\bred.?light\s*district\b/,
            /\badult\s*(club|bar|show|lounge|content|entertainment|resort|venue)\b/,
            /\bfetish\b/,
            /\bkink(y)?\b/,
            /\bbdsm\b/,
            /\bswinger(s)?\b/,
            /\borgy\b/,
            /\bgo.?go\s*(bar|girl|boy)\b/,
            /\bpussy\b/,
            /\bsex\s*(club|show|tour|worker|industry|bar|beach)\b/,
            /\bsex\s*tourism\b/,
        ];

        return !blockedPatterns.some(pattern => pattern.test(low));
    },

    /**
     * ============================================================
     * DAILY BUDGET GUARD — stops runaway API calls
     * ============================================================
     */
    _checkCallBudget() {
        const today = new Date().toDateString();

        // Reset counter if it's a new day
        if (this._apiCallTracker.date !== today) {
            this._apiCallTracker.count = 0;
            this._apiCallTracker.date  = today;
            localStorage.setItem('travel_api_calls', '0');
            localStorage.setItem('travel_api_date',  today);
        }

        if (this._apiCallTracker.count >= this._apiCallTracker.DAILY_LIMIT) {
            console.warn('[Travel] Daily API budget of 100 reached — serving cache only');
            return false;
        }

        this._apiCallTracker.count++;
        localStorage.setItem('travel_api_calls', String(this._apiCallTracker.count));
        console.log(`[Travel] API call #${this._apiCallTracker.count} of ${this._apiCallTracker.DAILY_LIMIT} today`);
        return true;
    },

    /**
     * ============================================================
     * TRAVEL — Real-time OpenTripMap destination search
     *
     * Categories (must match TravelScraperEngine.java exactly):
     *   - Relaxing Vacation
     *   - Adventure & Sports
     *   - Cultural Discovery
     *   - Food & Nightlife
     * ============================================================
     */
    async getTravel(purpose = 'Relaxing Vacation', searchQuery = '') {

        // ✅ Bug 1 Fixed — keys now exactly match TravelScraperEngine.java switch cases
        const purposeQueryMap = {
            'Relaxing Vacation': [
                'Maldives', 'Bora Bora', 'Seychelles',
                'Fiji', 'Mykonos', 'Maui'
            ],
            'Adventure & Sports': [
                'Queenstown', 'Chamonix', 'Banff',
                'Patagonia', 'Zermatt', 'Moab'
            ],
            'Cultural Discovery': [
                'Rome', 'Kyoto', 'Athens',
                'Cairo', 'Petra', 'Istanbul'
            ],
            'Food & Nightlife': [
                'Tokyo', 'Bangkok', 'Osaka',
                'New Orleans', 'Barcelona', 'Mumbai'
            ]
        };

        // Pick random destination from the correct category
        const queryList = purposeQueryMap[purpose] || ['Paris', 'London', 'Dubai'];
        const autoQuery = queryList[Math.floor(Math.random() * queryList.length)];

        // User's explicit search always takes priority
        const term = (searchQuery && searchQuery.trim() !== '')
            ? searchQuery.trim()
            : autoQuery;

        console.log(`[Travel] Request → purpose="${purpose}" | query="${term}"`);

        // ─────────────────────────────────────────
        // CACHE CHECK — return instantly if available
        // ─────────────────────────────────────────
        const cacheKey = `${purpose}_${term}`.toLowerCase().trim();
        if (this._travelCache[cacheKey]) {
            console.log(`[Travel] Cache hit → "${cacheKey}" (no API call made)`);
            return this._travelCache[cacheKey];
        }

        // ─────────────────────────────────────────
        // BUDGET CHECK — stop if daily limit reached
        // ─────────────────────────────────────────
        if (!this._checkCallBudget()) {
            return [];
        }

        // ─────────────────────────────────────────
        // VISIBILITY CHECK — don't call if tab is hidden
        // ─────────────────────────────────────────
        if (document.hidden) {
            console.log('[Travel] Tab not visible — skipping API call');
            return [];
        }

        try {
            // ✅ Bug 3 Fixed — removed Date.now() cache buster since we manage
            //    freshness ourselves via the cache object above
            // ✅ Bug 4 Fixed — source changed from 'tripadvisor' to 'opentripmap'
            const params = new URLSearchParams({
                query:   term,
                purpose: purpose,
                source:  'opentripmap',  // ✅ matches your actual backend engine
                lang:    'en',
                limit:   '12'
            });

            const response = await fetch(
                `${window.location.origin}/intellirec/travel-search?${params}`,
                {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json'
                    }
                }
            );

            if (!response.ok) {
                throw new Error(`HTTP ${response.status} ${response.statusText}`);
            }

            // ✅ Log remaining API calls from response headers
            const remaining = response.headers.get('X-RateLimit-Requests-Remaining');
            if (remaining) {
                console.log(`[Travel] RapidAPI calls remaining today: ${remaining}`);
            }

            const results = await response.json();
            console.log(`[Travel] Raw results received: ${results.length}`);

            // Step 1 — Safety filter
            const safeResults = results.filter(dest =>
                this._isSafeTravelContent(dest.place) &&
                this._isSafeTravelContent(dest.description) &&
                this._isSafeTravelContent(dest.type || '')
            );

            // Step 2 — Deduplicate by place name
            const seen = new Set();
            const deduplicated = safeResults.filter(dest => {
                const key = (dest.place || '').toLowerCase().trim();
                if (seen.has(key)) return false;
                seen.add(key);
                return true;
            });

            // Step 3 — Validate minimum data fields
            const validated = deduplicated.filter(dest =>
                dest.place &&
                dest.place.trim() !== '' &&
                dest.description &&
                dest.description.trim().length > 20
            );

            console.log(`[Travel] Final clean results: ${validated.length}`);

            // ✅ Save to cache — next call for same purpose+term is instant
            if (validated.length > 0) {
                this._travelCache[cacheKey] = validated;
            }

            return validated;

        } catch (e) {
            console.error('[Travel] Fetch failed:', e);
            return [];
        }
    }
};

window.ApiClient = ApiClient;
