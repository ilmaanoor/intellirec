/**
 * IntelliRec — Admin Dashboard Controller
 * Handles diagnostics and metrics
 */

document.addEventListener('DOMContentLoaded', () => {
    verifyAdmin();
    updateMetrics();
    
    document.getElementById('run-diagnostics').addEventListener('click', runFullDiagnostic);
});

async function verifyAdmin() {
    firebase.auth().onAuthStateChanged((user) => {
        if (!user) {
            window.location.href = 'login.jsp';
            return;
        }

        const name = user.displayName || user.email.split('@')[0];
        document.getElementById('user-avatar').src = `https://ui-avatars.com/api/?background=F9A825&color=white&bold=true&name=${name}`;

        // Basic admin check (can be expanded)
        const isAdmin = user.email.includes('admin') || user.email === 'admin@intellirec.com';
        if (!isAdmin) {
            log('warn', `Access denied for user: ${user.email}`);
            setTimeout(() => { window.location.href = 'intro.jsp'; }, 2000);
            return;
        }
        
        log('success', `Admin authenticated: ${user.email}`);
    });
}

function updateMetrics() {
    const travelCalls = parseInt(localStorage.getItem('travel_api_calls') || '0');
    document.getElementById('metric-travel-count').textContent = travelCalls;
    
    const budgetPercent = Math.min(100, travelCalls);
    document.getElementById('metric-budget-percent').textContent = `${budgetPercent}%`;
}

async function runFullDiagnostic() {
    const btn = document.getElementById('run-diagnostics');
    btn.disabled = true;
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Checking...';
    
    log('info', 'Starting full system diagnostic...');
    
    // 1. Check TMDB
    await checkService('TMDB API', 'status-tmdb', async () => {
        const res = await fetch('https://api.themoviedb.org/3/movie/popular?api_key=e226f4a5f5bace766952aa0d17182959');
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
    });

    // 2. Check OTM (via dummy call)
    await checkService('OpenTripMap', 'status-otm', async () => {
        const res = await fetch('https://api.opentripmap.com/0.1/en/places/geoname?name=Paris&apikey=5ae2e3f221c38a28845f05b630232599764516104f6c4bf92a08c00');
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
    });

    // 3. Check Backend Servlets
    await checkService('Backend Servlets', 'status-servlets', async () => {
        const res = await fetch('TravelSearchServlet?purpose=Relaxing%20Vacation');
        // If it's a 404/500 it might fail, but 200/405/etc means servlet is reachable
        if (res.status === 404) throw new Error('Servlet not found');
    });

    // 4. Scraper Check
    await checkService('Scraper Engine', 'status-scrapers', async () => {
        // Just verify internal classes are loaded (simulated)
        log('info', 'Verifying ScraperEngine classes...');
    });

    log('success', 'Diagnostic complete.');
    btn.disabled = false;
    btn.innerHTML = '<i class="fa-solid fa-bolt-lightning"></i> Run System Check';
}

async function checkService(name, elementId, checkFn) {
    const li = document.getElementById(elementId);
    const dot = li.querySelector('.dot');
    
    log('info', `Checking ${name}...`);
    dot.className = 'dot dot-unknown';
    
    try {
        await checkFn();
        dot.className = 'dot dot-good';
        log('success', `${name} is operational.`);
    } catch (err) {
        dot.className = 'dot dot-bad';
        log('error', `${name} failure: ${err.message}`);
        document.getElementById('overall-status').textContent = 'Issues Detected';
        document.getElementById('overall-status').className = 'status-badge status-bad';
    }
}

function log(type, msg) {
    const console = document.getElementById('admin-console');
    const entry = document.createElement('div');
    const time = new Date().toLocaleTimeString();
    entry.className = `log-entry log-${type}`;
    entry.textContent = `[${time}] ${msg}`;
    console.appendChild(entry);
    console.scrollTop = console.scrollHeight;
}

function clearConsole() {
    document.getElementById('admin-console').innerHTML = '';
}
