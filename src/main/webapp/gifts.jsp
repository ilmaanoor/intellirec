<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gifts - IntelliRec AI</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/global.css">
    <style>
        .page-header { padding: 120px 20px 40px; text-align: center; }
        
        .filter-section {
            max-width: 800px;
            margin: 0 auto 50px;
            display: flex;
            gap: 20px;
            background: white;
            padding: 20px;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
        }

        .gift-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto 60px;
            padding: 0 20px;
        }

        .gift-card {
            background: white;
            border-radius: 24px;
            padding: 24px;
            transition: var(--transition-smooth);
            border: 1px solid rgba(0,0,0,0.03);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .gift-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(234, 113, 37, 0.1);
            border-color: #FF9900;
        }

        .gift-thumb {
            width: 100%;
            height: 200px;
            object-fit: contain;
            background: #f9f9f9;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .amazon-tag {
            color: #FF9900;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .gift-name { font-size: 18px; font-weight: 700; margin-bottom: 10px; color: var(--text-dark); }
        .gift-price { font-size: 20px; font-weight: 800; color: var(--primary-dark); margin-top: auto; }

        .loading-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 100px 20px;
            color: var(--text-muted);
            font-weight: 600;
        }
    </style>
</head>
<body>

    <nav class="navbar-global">
        <a href="index.jsp" class="nav-brand">Intelli<span>Rec AI</span></a>
        <ul class="nav-links-global">
            <li><a href="intro.jsp">Home</a></li>
            <li><a href="movies.jsp">Movies</a></li>
            <li><a href="songs.jsp">Songs</a></li>
            <li><a href="gifts.jsp" class="active">Gifts</a></li>
            <li><a href="travel.jsp">Travel</a></li>
        </ul>
        <div class="nav-user">
            <img id="user-avatar" src="https://ui-avatars.com/api/?background=F9A825&color=white&name=User" alt="Avatar">
            <a href="#" id="logout-btn" class="btn-logout-nav" title="Sign Out">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            </a>
        </div>
    </nav>

    <div class="page-header">
        <h1>Curated Gift Guide</h1>
        <p>Expertly picked matches from Amazon for every occasion.</p>
    </div>

    <div class="filter-section">
        <div class="filter-group" style="flex: 1;">
            <label>Recipient</label>
            <select id="recipient-filter" class="form-control">
                <option value="Friend">For a Friend</option>
                <option value="Partner">For a Partner</option>
                <option value="Family">For Family</option>
                <optgroup label="Professional">
                    <option value="Colleague">For a Colleague</option>
                    <option value="Manager">For a Manager</option>
                    <option value="Client">For a Client</option>
                    <option value="Mentor">For a Mentor</option>
                </optgroup>
            </select>
        </div>
        <div class="filter-group" style="flex: 1;">
            <label>Occasion</label>
            <select id="occasion-filter" class="form-control">
                <option value="Birthday">Birthday</option>
                <option value="Anniversary">Anniversary</option>
                <option value="Holiday">Just Because / Holiday</option>
                <optgroup label="Professional Events">
                    <option value="Promotion">Promotion</option>
                    <option value="Farewell">Farewell / Retirement</option>
                    <option value="ThankYou">Thank You</option>
                    <option value="Welcome">Onboarding / Welcome</option>
                </optgroup>
            </select>
        </div>
    </div>

    <div id="gift-grid" class="gift-grid">
        <div class="loading-state">Finding the perfect match...</div>
    </div>

    <footer class="footer-site">
        Powered by IntelliRec AI • Connected via Amazon Partner Program
    </footer>

    <script src="js/firebase-app-compat.js"></script>
    <script src="js/firebase-auth-compat.js"></script>
    <script src="js/firebase-config.js"></script>
    <script src="js/auth.js"></script>
    <script src="js/api.js"></script>
    <script>
        firebase.auth().onAuthStateChanged((user) => {
            if (user) {
                const name = user.displayName || user.email.split('@')[0];
                document.getElementById('user-avatar').src = `https://ui-avatars.com/api/?background=F9A825&color=white&bold=true&name=\${name}`;
            }
        });

        async function loadGifts() {
            const grid = document.getElementById('gift-grid');
            const recipient = document.getElementById('recipient-filter').value;
            const occasion = document.getElementById('occasion-filter').value;

            grid.innerHTML = '<div class="loading-state">Scanning millions of options...</div>';

            try {
                const gifts = await ApiClient.getGifts(recipient, occasion);
                grid.innerHTML = '';
                
                gifts.forEach(gift => {
                    const card = document.createElement('div');
                    card.className = 'gift-card';
                    const sourceBadge = '<span style="color: #FF9900; font-size: 10px; font-weight: bold;">[REAL TIME]</span>';
                    
                    card.innerHTML = `
                        <img src="\${gift.img}" alt="\${gift.name}" class="gift-thumb">
                        <span class="amazon-tag">AMAZON IN \${sourceBadge}</span>
                        <div class="gift-name">\${gift.name}</div>
                        <div style="font-size:13px; color:var(--text-muted); margin-bottom:15px; text-transform: capitalize;">\${gift.category}</div>
                        <div class="gift-price">\${gift.price}</div>
                        <a href="\${gift.amazonUrl}" target="_blank" style="margin-top: 15px; background: #FF9900; color: white; padding: 10px 15px; border-radius: 8px; font-size: 14px; font-weight: 700; text-decoration: none; width: 100%; display: inline-block;">
                            Buy on Amazon.in
                        </a>
                    `;
                    grid.appendChild(card);
                });
            } catch (err) {
                grid.innerHTML = '<div class="loading-state">Failed to fetch gifts. Please try again.</div>';
            }
        }

        document.getElementById('recipient-filter').addEventListener('change', loadGifts);
        document.getElementById('occasion-filter').addEventListener('change', loadGifts);
        loadGifts();
    </script>
</body>
</html>
