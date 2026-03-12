/**
 * Intellirec AI - Central API Client
 * Handles requests to Netflix (Simulated), Spotify, Amazon, and Tripadvisor.
 */

const API_CONFIG = {
    // These would be replaced with actual API keys in a production environment
    NETFLIX_SIMULATED: true,
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
        console.log(`Fetching ${genre} movies in ${language}...`);
        // Simulating Netflix-style API response
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve([
                    { id: 1, title: 'Stranger Things', genre: 'Sci-Fi', rating: 4.8, img: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?w=400&h=600&fit=crop' },
                    { id: 2, title: 'Extraction 2', genre: 'Action', rating: 4.5, img: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=400&h=600&fit=crop' },
                    { id: 3, title: 'The Witcher', genre: 'Fantasy', rating: 4.7, img: 'https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=400&h=600&fit=crop' },
                    { id: 4, title: 'Money Heist', genre: 'Crime', rating: 4.9, img: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=400&h=600&fit=crop' }
                ]);
            }, 100);
        });
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
