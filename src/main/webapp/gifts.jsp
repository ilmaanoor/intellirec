<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gifts - Intellirec AI</title>
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
            border: 1px solid #FF9900;
        }
        .gift-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 2rem;
        }
        .gift-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            transition: var(--transition);
            border: 1px solid #EEE;
            display: flex;
            flex-direction: column;
        }
        .gift-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(255, 153, 0, 0.15);
        }
        .product-img {
            width: 100%;
            aspect-ratio: 1/1;
            object-fit: contain;
            margin-bottom: 1.5rem;
        }
        .amazon-link {
            background: #FF9900;
            color: white;
            padding: 0.8rem;
            border-radius: 8px;
            text-align: center;
            text-decoration: none;
            font-weight: 700;
            margin-top: auto;
        }
        .price { font-size: 1.4rem; font-weight: 800; color: #B12704; margin: 0.5rem 0; }
        .rating-amazon { color: #FFA41C; font-size: 0.9rem; margin-bottom: 1rem; }
    </style>
</head>
<body class="flow-gifts">
    <div class="container">
        <header>
            <a href="index.jsp" class="logo">Intelli<span>Rec</span></a>
            <nav class="nav-links">
                <a href="categories.jsp">Back</a>
                <a href="#" id="logout-btn">Logout</a>
            </nav>
        </header>

        <section class="hero" style="padding: 2rem 0;">
            <h1>Amazon Gift Recommendations</h1>
            <p>Smart gift ideas for everyone you care about.</p>
        </section>

        <div class="filter-bar">
            <div class="form-group" style="margin: 0; flex: 1;">
                <label style="margin-bottom: 0.5rem; font-size: 0.9rem;">Recipient</label>
                <select id="recipient-filter" class="form-control">
                    <option value="Friend">A Friend</option>
                    <option value="Partner">Partner</option>
                    <option value="Parent">Parent</option>
                    <option value="Colleague">Colleague</option>
                </select>
            </div>
            <div class="form-group" style="margin: 0; flex: 1;">
                <label style="margin-bottom: 0.5rem; font-size: 0.9rem;">Occasion</label>
                <select id="occasion-filter" class="form-control">
                    <option value="Birthday">Birthday</option>
                    <option value="Anniversary">Anniversary</option>
                    <option value="Holiday">Holiday</option>
                </select>
            </div>
        </div>

        <div id="gift-grid" class="gift-grid">
            <div class="loading-spinner">Picking out the perfect box...</div>
        </div>
    </div>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js"></script>
    <script>
        async function loadGifts() {
            const grid = document.getElementById('gift-grid');
            const recipient = document.getElementById('recipient-filter').value;
            const occasion = document.getElementById('occasion-filter').value;

            grid.innerHTML = '<div class="loading-spinner">Searching Amazon catalog...</div>';

            try {
                const gifts = await ApiClient.getGifts(recipient, occasion);
                grid.innerHTML = '';
                
                gifts.forEach(gift => {
                    const card = document.createElement('div');
                    card.className = 'gift-card';
                    card.innerHTML = `
                        <img src="\${gift.img}" alt="\${gift.name}" class="product-img">
                        <span style="font-size: 0.8rem; color: #565959;">\${gift.category}</span>
                        <h4 style="margin: 0.5rem 0;">\${gift.name}</h4>
                        <div class="rating-amazon">★★★★★ (2,400+ reviews)</div>
                        <div class="price">\${gift.price}</div>
                        <a href="#" class="amazon-link">View on Amazon</a>
                    `;
                    grid.appendChild(card);
                });
            } catch (err) {
                grid.innerHTML = '<div class="loading-spinner">Something went wrong. Let\'s try again.</div>';
            }
        }

        document.getElementById('recipient-filter').addEventListener('change', loadGifts);
        document.getElementById('occasion-filter').addEventListener('change', loadGifts);
        window.addEventListener('DOMContentLoaded', loadGifts);
    </script>
</body>
</html>
