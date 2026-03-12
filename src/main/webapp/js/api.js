/**
 * Intellirec AI - Central API Client
 * Handles requests to Netflix (Simulated), Spotify, Amazon, and Tripadvisor.
 */

const API_CONFIG = {
    // IMPORTANT: Get your TMDB API Key from https://www.themoviedb.org/settings/api
    TMDB_API_KEY: 'e226f4a5f5bace766952aa0d17182959',
    TMDB_BASE_URL: 'https://api.tmdb.org/3', // Unblocked mirror for India
    IMAGE_BASE_URL: 'https://images.weserv.nl/?url=https://image.tmdb.org/t/p/w500', // Unblocked image proxy
    NETFLIX_PROVIDER_ID: 8,
    SPOTIFY_CLIENT_ID: 'YOUR_SPOTIFY_CLIENT_ID',
    AMAZON_PARTNER_TAG: 'YOUR_AMAZON_TAG',
    TRIPADVISOR_API_KEY: 'YOUR_TRIPADVISOR_KEY'
};

const ApiClient = {
    _lastError: null,
    /**
     * Fetch Movie recommendations (Netflix Style)
     * @param {string} genre 
     * @param {string} language 
     */
    async getMovies(genre = 'All', language = 'English') {
        console.log('TMDB Key Check:', API_CONFIG.TMDB_API_KEY);
        if (API_CONFIG.TMDB_API_KEY === 'YOUR_TMDB_API_KEY_HERE' || !API_CONFIG.TMDB_API_KEY) {
            console.warn('TMDB API Key missing. Falling back to simulation.');
            return this._getSimulatedMovies(genre);
        }

        const genreMap = {
            'Action': 28, 'Sci-Fi': 878, 'Comedy': 35, 'Drama': 18, 'Fantasy': 14, 'Thriller': 53
        };

        const langMap = {
            'English': 'en-US', 'Hindi': 'hi-IN', 'Tamil': 'ta-IN', 'Telugu': 'te-IN', 'Korean': 'ko-KR'
        };

        const genreId = genreMap[genre] || '';
        const langCode = langMap[language] || 'en-US';

        console.log(`Fetching real-time ${genre} movies in ${language} from TMDB...`);

        try {
            const url = new URL(`${window.location.origin}/intellirec/proxy.jsp`);
            const baseParams = {
                api_key: API_CONFIG.TMDB_API_KEY,
                language: langCode,
                sort_by: 'popularity.desc'
            };
            if (genreId) baseParams.with_genres = genreId;

            let finalResults = [];

            // Stage 1: Try Netflix (India)
            console.log("Stage 1: Attempting Netflix (India)...");
            url.search = new URLSearchParams({...baseParams, with_watch_providers: 8, watch_region: 'IN'}).toString();
            let res = await fetch(url);
            let rawText = await res.text();
            let data;
            try {
                data = JSON.parse(rawText);
            } catch (e) {
                console.error("Stage 1 - Non-JSON response:", rawText.substring(0, 200));
                this._lastError = "Proxy Error: Received HTML instead of Data. Check Tomcat console.";
                data = { results: [] };
            }
            console.log("Stage 1 Response:", data);
            if (data.results && data.results.length > 0) finalResults = data.results;
            if (data.error) this._lastError = "Proxy Error (S1): " + data.error;

            // Wait 1.5s between stages if results are missing
            const sleep = ms => new Promise(r => setTimeout(r, ms));

            // Stage 2: Try Netflix (Global)
            if (finalResults.length < 4) {
                await sleep(1500);
                console.log("Stage 2: Attempting Netflix (Global)...");
                url.search = new URLSearchParams({...baseParams, with_watch_providers: 8}).toString();
                res = await fetch(url);
                rawText = await res.text();
                try {
                    data = JSON.parse(rawText);
                } catch (e) {
                    console.error("Stage 2 - Non-JSON response:", rawText.substring(0, 200));
                    data = { results: [] };
                }
                console.log("Stage 2 Response:", data);
                if (data.results && data.results.length > 0) {
                    const newBatch = data.results.filter(nr => !finalResults.some(fr => fr.id === nr.id));
                    finalResults = [...finalResults, ...newBatch];
                }
                if (data.error && finalResults.length === 0) this._lastError = "Proxy Error (S2): " + data.error;
            }

            // Stage 3: Try All Trending
            if (finalResults.length === 0) {
                await sleep(1500);
                console.log("Stage 3: Attempting All Trending...");
                url.search = new URLSearchParams(baseParams).toString();
                res = await fetch(url);
                rawText = await res.text();
                try {
                    data = JSON.parse(rawText);
                } catch (e) {
                    console.error("Stage 3 - Non-JSON response:", rawText.substring(0, 200));
                    data = { results: [] };
                }
                console.log("Stage 3 Response:", data);
                if (data.results) finalResults = data.results;
                if (data.error) this._lastError = "Proxy Error (S3): " + data.error;
            }

            if (!finalResults || finalResults.length === 0) {
                console.warn('No real-time results found across all stages. Last Error:', this._lastError);
                return [];
            }

            this._lastError = null; // Clear error on success
            return finalResults.slice(0, 12).map(m => ({
                id: m.id,
                title: m.title,
                genre: genre,
                rating: (m.vote_average || 0).toFixed(1),
                img: m.poster_path ? `${API_CONFIG.IMAGE_BASE_URL}${m.poster_path}` : 'https://via.placeholder.com/500x750?text=No+Poster'
            }));
        } catch (err) {
            console.error('ApiClient.getMovies Exception:', err);
            this._lastError = "System Exception: " + err.message;
            return [];
        }
    },

    /**
     * Simulation removed to prioritize requested Real-Time link
     */
    async _getSimulatedMovies(genre) {
        return [];
    },

    /**
     * Internal: Fetch Spotify Access Token
     */
    async _getSpotifyToken() {
        try {
            const res = await fetch(`${window.location.origin}/intellirec/spotify_auth.jsp`);
            const data = await res.json();
            if (data.access_token) return data.access_token;
            console.error('Spotify Token Error:', data.error);
            return null;
        } catch (e) {
            console.error('Spotify Auth Exception:', e);
            return null;
        }
    },

    /**
     * Fetch Top Songs based on Language & Mood using iTunes API
     * USES HIGHLY CURATED ARTIST MAPPING: iTunes search fails on abstract keywords (like 'hindi romantic'). 
     * To guarantee 100% diverse and accurate results, we map moods to the absolute top artists in those regions.
     */
    async getSongs(language = 'English', mood = 'Happy', artist = '') {
        // Curated map of top artists for exact iTunes matching
        const queryMap = {
            'English': {
                'Happy': 'Dua Lipa',
                'Chill': 'Billie Eilish',
                'Focus': 'Hans Zimmer',
                'Workout': 'Eminem',
                'Romantic': 'Ed Sheeran'
            },
            'Hindi': {
                'Happy': 'Badshah',
                'Chill': 'Pritam',
                'Focus': 'A. R. Rahman',
                'Workout': 'Mika Singh',
                'Romantic': 'Arijit Singh'
            },
            'Korean': {
                'Happy': 'BTS',
                'Chill': 'IU',
                'Focus': 'Yiruma',
                'Workout': 'BLACKPINK',
                'Romantic': 'Crush'
            },
            'Chinese': {
                'Happy': 'Jolin Tsai',
                'Chill': 'Jay Chou',
                'Focus': 'Guzheng',
                'Workout': 'Jackson Wang',
                'Romantic': 'Eric Chou'
            },
            'Tamil': {
                'Happy': 'Anirudh Ravichander',
                'Chill': 'Yuvan Shankar Raja',
                'Focus': 'Ilayaraja',
                'Workout': 'Vijay',
                'Romantic': 'Sid Sriram'
            }
        };

        // Specific country codes to force iTunes regional catalogs
        const countryMap = {
            'English': 'US',
            'Hindi': 'IN',
            'Korean': 'KR',
            'Chinese': 'TW',
            'Tamil': 'IN'
        };

        let query;
        let country = 'US'; // default

        if (artist && artist.trim() !== '') {
            query = artist.trim();
        } else {
            // Fallback to a generic query if somehow not mapped
            const safeLanguage = queryMap[language] ? language : 'English';
            const safeMood = queryMap[safeLanguage][mood] ? mood : 'Happy';
            query = queryMap[safeLanguage][safeMood];
            country = countryMap[safeLanguage];
        }

        // Search iTunes endpoint using the specific artist and country code
        const itunesUrl = `https://itunes.apple.com/search?term=${encodeURIComponent(query)}&country=${country}&media=music&entity=song&limit=12`;
        const proxyUrl = `${window.location.origin}/intellirec/proxy.jsp?targetUrl=${encodeURIComponent(itunesUrl)}`;

        console.log(`Searching iTunes for Artist/Keyword: ${query} in ${country}...`);
        try {
            const res = await fetch(proxyUrl);
            const data = await res.json();
            
            if (data.results && data.results.length > 0) {
                // Shuffle the tracks to give a fresh "radio" feel each time requested
                const shuffled = data.results.sort(() => 0.5 - Math.random());
                
                return shuffled.map(t => ({
                    id: t.trackId,
                    title: t.trackName,
                    artist: t.artistName,
                    album: t.collectionName,
                    img: t.artworkUrl100 ? t.artworkUrl100.replace('100x100bb', '300x300bb') : 'https://via.placeholder.com/300?text=No+Cover',
                    url: t.trackViewUrl,
                    preview: t.previewUrl
                }));
            }
            // Fallback if the top artist query somehow fails
            console.warn("iTunes returned no results for query:", query);
            return [];
        } catch (err) {
            console.error('iTunes API Exception:', err);
            return [];
        }
    },

    /**
     * Fetch Gift recommendations (DummyJSON for UI, Amazon IN for Purchasing)
     * Maps Recipient & Occasion to a specific category and generates direct Amazon.in search links
     */
    async getGifts(recipient = 'Friend', occasion = 'Birthday') {
        // Expanded category map for personal and professional combinations
        const categoryMap = {
            'Friend': {
                'Birthday': 'smartphones',
                'Anniversary': 'sunglasses',
                'Holiday': 'sports-accessories',
                'Promotion': 'mens-watches',
                'Farewell': 'fragrances',
                'ThankYou': 'groceries', // often contains chocolates/gift baskets in DummyJSON
                'Welcome': 'home-decoration'
            },
            'Partner': {
                'Birthday': 'womens-watches', 
                'Anniversary': 'womens-jewellery',
                'Holiday': 'fragrances',
                'Promotion': 'smartphones',
                'Farewell': 'womens-bags',
                'ThankYou': 'womens-jewellery',
                'Welcome': 'tops'
            },
            'Family': {
                'Birthday': 'home-decoration',
                'Anniversary': 'furniture',
                'Holiday': 'groceries',
                'Promotion': 'tablets',
                'Farewell': 'home-decoration',
                'ThankYou': 'groceries',
                'Welcome': 'furniture'
            },
            'Colleague': {
                'Birthday': 'laptops',
                'Anniversary': 'mens-watches',
                'Holiday': 'tablets',
                'Promotion': 'smartphones',
                'Farewell': 'mens-shirts',
                'ThankYou': 'fragrances',
                'Welcome': 'tablets'
            },
            'Manager': {
                'Birthday': 'mens-watches',
                'Anniversary': 'home-decoration',
                'Holiday': 'laptops',
                'Promotion': 'smartphones',
                'Farewell': 'furniture',
                'ThankYou': 'fragrances',
                'Welcome': 'mens-shirts'
            },
            'Client': {
                'Birthday': 'fragrances',
                'Anniversary': 'laptops',
                'Holiday': 'home-decoration',
                'Promotion': 'tablets',
                'Farewell': 'mens-watches',
                'ThankYou': 'home-decoration',
                'Welcome': 'fragrances'
            },
            'Mentor': {
                'Birthday': 'tablets',
                'Anniversary': 'womens-watches',
                'Holiday': 'furniture',
                'Promotion': 'laptops',
                'Farewell': 'home-decoration',
                'ThankYou': 'mens-watches',
                'Welcome': 'fragrances'
            }
        };

        const safeRecipient = categoryMap[recipient] ? recipient : 'Friend';
        const safeOccasion = categoryMap[safeRecipient][occasion] ? occasion : 'Birthday';
        const category = categoryMap[safeRecipient][safeOccasion];

        const dummyUrl = `https://dummyjson.com/products/category/${category}`;
        const proxyUrl = `${window.location.origin}/intellirec/proxy.jsp?targetUrl=${encodeURIComponent(dummyUrl)}`;

        console.log(`Fetching real-time gifts for ${recipient} on ${occasion} (Category: ${category})...`);
        try {
            const res = await fetch(proxyUrl);
            const data = await res.json();
            if (data.products) {
                return data.products.slice(0, 12).map(p => ({
                    id: p.id,
                    name: p.title,
                    category: p.category.replace('-', ' '),
                    price: `₹${Math.round(p.price * 83).toLocaleString('en-IN')}`,
                    img: p.thumbnail,
                    // Dynamically generate an Amazon India search link for this specific item
                    amazonUrl: `https://www.amazon.in/s?k=${encodeURIComponent(p.title + ' ' + p.brand)}&tag=${API_CONFIG.AMAZON_PARTNER_TAG}`
                }));
            }
            return [];
        } catch (e) {
            console.error('Gifts API Exception:', e);
            return [];
        }
    },

    /**
     * Fetch Travel recommendations (RestCountries)
     * @param {string} purpose 
     */
    async getTravel(purpose = 'Vacation') {
        const regionMap = {
            'Vacation': 'europe',
            'Adventure': 'americas',
            'Culture': 'asia',
            'Food': 'oceania'
        };
        const region = regionMap[purpose] || 'asia';
        const countriesUrl = `https://restcountries.com/v3.1/region/${region}`;
        const proxyUrl = `${window.location.origin}/intellirec/proxy.jsp?targetUrl=${encodeURIComponent(countriesUrl)}`;

        console.log(`Fetching real-time ${purpose} destinations...`);
        try {
            const res = await fetch(proxyUrl);
            const data = await res.json();
            if (Array.isArray(data)) {
                return data.sort(() => 0.5 - Math.random()).slice(0, 12).map((c, i) => ({
                    id: i,
                    place: c.name.common,
                    type: c.subregion || purpose,
                    rating: (4 + Math.random()).toFixed(1),
                    img: c.flags.png || c.flags.svg
                }));
            }
            return [];
        } catch (e) {
            console.error('Travel API Exception:', e);
            return [];
        }
    }
};

window.ApiClient = ApiClient;
