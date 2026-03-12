<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Travel - Intellirec AI</title>
    <link rel="stylesheet" href="css/style_v1.css">
    <style>
        .filter-bar {
            background: #FFF;
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 3rem;
            display: flex;
            gap: 2rem;
            align-items: center;
            border: 1px solid #00A699;
        }
        .travel-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }
        .travel-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            transition: var(--transition);
            border: 1px solid #EEE;
            position: relative;
        }
        .travel-card:hover {
            transform: scale(1.02);
            box-shadow: 0 20px 40px rgba(0, 166, 153, 0.15);
        }
        .place-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .tripadvisor-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: #00af87;
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 800;
        }
        .place-info { padding: 1.5rem; }
        .rating-stars { color: #00af87; font-weight: 700; }
    </style>
</head>
<body class="flow-travel">
    <div class="container">
        <header>
            <a href="index.jsp" class="logo">Intelli<span>Rec</span></a>
            <nav class="nav-links">
                <a href="categories.jsp">Back</a>
                <a href="#" id="logout-btn">Logout</a>
            </nav>
        </header>

        <section class="hero" style="padding: 2rem 0;">
            <h1>Tripadvisor Travel Destinations</h1>
            <p>Discover your next dream escape with AI curation.</p>
        </section>

        <div class="filter-bar">
            <div class="form-group" style="margin: 0; flex: 1;">
                <label style="margin-bottom: 0.5rem; font-size: 0.9rem;">Travel Purpose</label>
                <select id="purpose-filter" class="form-control">
                    <option value="Vacation">Relaxing Vacation</option>
                    <option value="Adventure">Adventure & Sports</option>
                    <option value="Culture">Cultural Discovery</option>
                    <option value="Food">Food & Nightlife</option>
                </select>
            </div>
        </div>

        <div id="travel-grid" class="travel-grid">
            <div class="loading-spinner">Mapping your journey...</div>
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js"></script>
    <script>
        async function loadTravel() {
            const grid = document.getElementById('travel-grid');
            const purpose = document.getElementById('purpose-filter').value;

            grid.innerHTML = '<div class="loading-spinner">Consulting local experts...</div>';

            try {
                const destinations = await ApiClient.getTravel(purpose);
                grid.innerHTML = '';
                
                destinations.forEach(dest => {
                    const card = document.createElement('div');
                    card.className = 'travel-card';
                    card.innerHTML = `
                        <div class="tripadvisor-badge">TRIPADVISOR CHOICE</div>
                        <img src="\${dest.img}" alt="\${dest.place}" class="place-img">
                        <div class="place-info">
                            <span style="font-size: 0.8rem; color: #00A699; font-weight: 600;">\${dest.type}</span>
                            <h3 style="margin: 0.5rem 0;">\${dest.place}</h3>
                            <div class="rating-stars">●●●●● <span style="color:var(--text-muted); font-weight:400; font-size:0.9rem;">\${dest.rating}/5</span></div>
                            <p style="color: var(--text-muted); margin: 1rem 0;">Highly recommended for \${purpose.toLowerCase()} seekers from current traveler reviews.</p>
                            <a href="#" style="color: #00A699; font-weight: 700; text-decoration: none;">Explore Details →</a>
                        </div>
                    `;
                    grid.appendChild(card);
                });
            } catch (err) {
                grid.innerHTML = '<div class="loading-spinner">Passport issues. Try again soon.</div>';
            }
        }

        document.getElementById('purpose-filter').addEventListener('change', loadTravel);
        window.addEventListener('DOMContentLoaded', loadTravel);
    </script>
</body>
</html>
