/**
 * Intellirec AI - Central API Client
 * Handles requests to Netflix (Simulated), Spotify, Amazon, and Tripadvisor.
 */

const API_CONFIG = {
    // IMPORTANT: Get your TMDB API Key from https://www.themoviedb.org/settings/api
    TMDB_API_KEY: 'e226f4a5f5bace766952aa0d17182959',
    TMDB_BASE_URL: 'https://api.themoviedb.org/3',
    NETFLIX_PROVIDER_ID: 8,
    SPOTIFY_CLIENT_ID: 'YOUR_SPOTIFY_CLIENT_ID',
    AMAZON_PARTNER_TAG: 'YOUR_AMAZON_TAG',
    TRIPADVISOR_API_KEY: 'YOUR_TRIPADVISOR_KEY'
};

const ApiClient = {
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
            // Using proxy.jsp to avoid "Failed to fetch" network/CORS issues
            const url = new URL(`${window.location.origin}/intellirec/proxy.jsp`);
            const params = {
                api_key: API_CONFIG.TMDB_API_KEY,
                language: langCode,
                sort_by: 'popularity.desc',
                with_watch_providers: API_CONFIG.NETFLIX_PROVIDER_ID,
                watch_region: 'IN', // Optimized for the requested languages
                'vote_count.gte': 50 // Lowered threshold for broader results
            };

            if (genreId) params.with_genres = genreId;

            url.search = new URLSearchParams(params).toString();
            console.log(`TMDB Request: ${url.toString()}`);

            const response = await fetch(url);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            
            const data = await response.json();
            console.log('TMDB Response:', data);

            if (!data.results || data.results.length === 0) {
                console.warn('No real-time results found for this filter. Falling back to simulation.');
                return this._getSimulatedMovies(genre);
            }

            return data.results.slice(0, 12).map(m => ({
                id: m.id,
                title: m.title,
                genre: genre,
                rating: m.vote_average.toFixed(1),
                img: m.poster_path ? `https://image.tmdb.org/t/p/w500${m.poster_path}` : 'https://via.placeholder.com/500x750?text=No+Poster'
            }));
        } catch (err) {
            console.error('TMDB Fetch Error:', err);
            // Alerting user for live debugging
            alert('IntelliRec Debug: Movie Fetch Failed! Error: ' + err.message + '. Check browser console (F12) for details.');
            return this._getSimulatedMovies(genre);
        }
    },

    /**
     * Internal simulation fallback if API key is missing
     */
    async _getSimulatedMovies(genre) {
        return [
            { id: 1, title: 'Stranger Things', genre: genre, rating: 4.8, img: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?w=400&h=600&fit=crop' },
            { id: 2, title: 'Extraction 2', genre: genre, rating: 4.5, img: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=400&h=600&fit=crop' },
            { id: 3, title: 'The Witcher', genre: genre, rating: 4.7, img: 'https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=400&h=600&fit=crop' },
            { id: 4, title: 'Money Heist', genre: genre, rating: 4.9, img: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=400&h=600&fit=crop' }
        ];
    },

    /**
     * Fetch Song recommendations (Spotify)
     * @param {string} mood 
     */
    async getSongs(mood = 'Happy') {
        console.log(`Fetching ${mood} songs from Spotify...`);
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve([
                    { id: 1, title: 'Blinding Lights', artist: 'The Weeknd', album: 'After Hours', img: 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?w=300&h=300&fit=crop' },
                    { id: 2, title: 'Levitating', artist: 'Dua Lipa', album: 'Future Nostalgia', img: 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=300&h=300&fit=crop' },
                    { id: 3, title: 'Stay', artist: 'The Kid LAROI & Justin Bieber', album: 'F*CK LOVE 3', img: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=300&h=300&fit=crop' }
                ]);
            }, 100);
        });
    },

    /**
     * Fetch Gift recommendations (Amazon)
     * @param {string} recipient 
     * @param {string} occasion 
     */
    async getGifts(recipient = 'Friend', occasion = 'Birthday') {
        console.log(`Fetching gifts for ${recipient}'s ${occasion}...`);
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve([
                    { id: 1, name: 'Kindle Paperwhite', category: 'Tech', price: '$139.99', img: 'https://images.unsplash.com/photo-1589998059171-988d887df646?w=400&h=400&fit=crop' },
                    { id: 2, name: 'Echo Dot (5th Gen)', category: 'Smart Home', price: '$49.99', img: 'https://images.unsplash.com/photo-1589492477829-5e65395b66cc?w=400&h=400&fit=crop' },
                    { id: 3, name: 'Fujifilm Instax Mini 12', category: 'Photography', price: '$79.00', img: 'https://images.unsplash.com/photo-1526170315870-ef6d82f583f7?w=400&h=400&fit=crop' }
                ]);
            }, 100);
        });
    },

    /**
     * Fetch Travel recommendations (Tripadvisor)
     * @param {string} purpose 
     */
    async getTravel(purpose = 'Vacation') {
        console.log(`Fetching ${purpose} destinations from Tripadvisor...`);
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve([
                    { id: 1, place: 'Bali, Indonesia', type: 'Tropical', rating: 4.9, img: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=600&h=400&fit=crop' },
                    { id: 2, place: 'Swiss Alps, Switzerland', type: 'Adventure', rating: 4.8, img: 'https://images.unsplash.com/photo-1531310197839-ccf54634509e?w=600&h=400&fit=crop' },
                    { id: 3, place: 'Kyoto, Japan', type: 'Culture', rating: 4.7, img: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=600&h=400&fit=crop' }
                ]);
            }, 100);
        });
    }
};

window.ApiClient = ApiClient;
