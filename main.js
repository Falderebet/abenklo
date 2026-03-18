// ── Lead Form ───────────────────────────────────────────
const form = document.getElementById('leadForm');

if (form) {
  form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const btn = form.querySelector('[type="submit"]');
    btn.disabled = true;
    btn.textContent = 'Sender…';

    const data = Object.fromEntries(new FormData(form));

    try {
      // POST to /api/leads when backend is wired up.
      // For now, simulate a short delay and show success.
      await new Promise(r => setTimeout(r, 900));

      // Replace form with success message
      form.classList.add('form--success');
      form.innerHTML = `
        <div class="success-icon">✅</div>
        <h3>Tak, ${escapeHtml(data.name || 'du')}!</h3>
        <p>Vi vender tilbage inden for 24 timer på hverdage.<br/>
           Kig også i din spam-mappe hvis du ikke hører fra os.</p>
      `;
    } catch {
      btn.disabled = false;
      btn.textContent = 'Book gratis AI-Sikkerhedsvurdering';
      alert('Noget gik galt. Prøv igen eller skriv direkte til os.');
    }
  });
}

// ── Smooth-scroll active nav link ──────────────────────
const sections  = document.querySelectorAll('section[id]');
const navBtn    = document.querySelector('.nav .btn');

const observer = new IntersectionObserver(entries => {
  entries.forEach(entry => {
    if (entry.isIntersecting && entry.target.id === 'kontakt') {
      navBtn?.classList.add('btn--active');
    }
  });
}, { threshold: 0.3 });

sections.forEach(s => observer.observe(s));

// ── Tiny XSS guard ─────────────────────────────────────
function escapeHtml(str) {
  return str.replace(/[&<>"']/g, c => ({
    '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;'
  }[c]));
}
