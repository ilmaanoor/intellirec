/**
 * Intellirec AI - Central API Client v16.0 - FULLY REAL-TIME
 * All four recommendation engines now pull live data dynamically based on user filters.
 */

const API_CONFIG = {
    TMDB_API_KEY: 'e226f4a5f5bace766952aa0d17182959',
    IMAGE_BASE_URL: 'https://images.weserv.nl/?url=https://image.tmdb.org/t/p/w500',
    NETFLIX_PROVIDER_ID: 8,
    AMAZON_PARTNER_TAG: 'YOUR_AMAZON_TAG'
};

const ApiClient = {
    _lastError: null,

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
     * TRAVEL - Real-time Wikipedia Search
     */
    async getTravel(purpose = 'Vacation', searchQuery = '') {
        const wikiCategories = {
            'Vacation':  ['beach resort', 'tropical island'],
            'Adventure': ['mountain trekking', 'national park'],
            'Culture':   ['historic city', 'heritage site'],
            'Food':      ['food capital', 'culinary city']
        };

        let term = searchQuery;
        if (!term || term.trim() === '') {
            const categories = wikiCategories[purpose] || wikiCategories['Vacation'];
            term = categories[Math.floor(Math.random() * categories.length)];
        }

        console.log(`[Travel] Wikipedia Search for: "${term}"...`);

        try {
            const wikiSearchUrl = `https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=${encodeURIComponent(term + ' travel')}&srnamespace=0&srlimit=20&format=json&origin=*`;
            const searchRes = await fetch(wikiSearchUrl);
            const searchData = await searchRes.json();
            const articles = (searchData.query?.search || []).sort(() => 0.5 - Math.random()).slice(0, 8);

            const results = [];
            for (const article of articles) {
                if (results.length >= 6) break;
                try {
                    const imgUrl = `https://en.wikipedia.org/w/api.php?action=query&titles=${encodeURIComponent(article.title)}&prop=pageimages|extracts&exchars=200&exintro=true&format=json&pithumbsize=1000&origin=*`;
                    const imgRes = await fetch(imgUrl);
                    const imgData = await imgRes.json();
                    const page = Object.values(imgData.query.pages)[0];

                    if (page && page.thumbnail) {
                    }
                } catch (e) {}
            }
            return results;
        } catch (e) {
            console.error('[Travel] Exception:', e);
            return [];
        }
    }
};

window.ApiClient = ApiClient;
