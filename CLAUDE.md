# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Static single-page marketing site for Åbenklo — a Danish consulting service helping SMVs adopt open-source software. Deployed via Docker + Nginx on Coolify.

## Architecture

- **Static site**: Pure HTML/CSS/JS, no build step required
- **Server**: `nginx:1.27-alpine` with custom `nginx.conf` (security headers, gzip, 30-day asset caching)
- **Form**: `main.js` handles lead form submission client-side; backend (`/api/leads`) is a 501 placeholder

## Deployment

Coolify deploys the Docker image via webhook. To trigger a deployment manually:

```bash
cp .env.deploy.example .env.deploy  # fill in COOLIFY_TOKEN and COOLIFY_WEBHOOK_URL
./deploy.sh
```

The script sends a GET request to the Coolify webhook URL with a Bearer token. A 200 or 201 response means the deployment was queued.

**Coolify CLI alternative** — if you have the Coolify CLI installed:
```bash
coolify deploy --token $COOLIFY_TOKEN
```
Or via the API directly:
```bash
curl -X GET "$COOLIFY_WEBHOOK_URL" -H "Authorization: Bearer $COOLIFY_TOKEN"
```

## Key files

| File | Purpose |
|------|---------|
| `index.html` | Entire landing page (nav, hero, pain points, process, benefits, testimonials, lead form) |
| `style.css` | All styles — no framework, custom CSS variables |
| `main.js` | Form XSS sanitization, submit handler, nav CTA visibility logic |
| `nginx.conf` | Server config — edit here for routes, headers, caching |
| `Dockerfile` | Copies static files into nginx alpine image |
| `deploy.sh` | Triggers Coolify webhook deployment |

## Design guidelines

The site uses **Nordic Editorial with Terminal accents** — a hybrid of warm Scandinavian editorial typography and subtle developer/terminal aesthetics.

### Palette

| Token | Value | Use |
|-------|-------|-----|
| `--green` | `#4a7c59` | Primary accent — CTAs, highlights, borders |
| `--green-dk` | `#3d6b4a` | Button hover state |
| `--green-50/100` | `#f2f8f4` / `#e8f4ed` | Subtle tinted backgrounds |
| `--stone-50` | `#fafaf8` | Hero and alternating section backgrounds |
| `--stone-100` | `#f4f3ef` | Form background |
| `--stone-200` | `#e8e6e0` | Borders, dividers |
| `--stone-400` | `#a09890` | Muted text, metadata |
| `--stone-500` | `#78726a` | Secondary body text |
| `--stone-700` | `#3d3730` | Primary body text |
| `--stone-900` | `#1c1a16` | Headings, nav border, contact bg |

### Typography

Three font families, each with a distinct role:

| Variable | Font | Use |
|----------|------|-----|
| `--font-serif` | Playfair Display | Section headings, nav logo, step titles, testimonial quotes |
| `--font-body` | Source Serif 4 | Body text, form copy |
| `--font-sans` | Inter | Buttons (uppercase tracked), footer, cite attribution |
| `--font-mono` | JetBrains Mono | Terminal accents: hero badge, trust line, section subtitles, step numbers, benefit titles, form labels/inputs |

### Terminal accent elements (from Design 2)

These elements give the site a subtle developer feel without abandoning the editorial tone:

- **Hero badge**: monospace, green, bordered box with blinking `▋` cursor
- **Trust line**: `// ` prefix before each item (via `::before` pseudo-element)
- **Section subtitles**: wrapped in `/* ... */` CSS comment syntax
- **Step numbers** (I, II, III): monospace, 48×48px bordered box, green glow shadow
- **Benefit titles**: monospace green, smaller than body
- **Form labels**: monospace, uppercase, green
- **Form inputs**: monospace, underline-only (no border box)
- **Hero scanline**: `repeating-linear-gradient` overlay (0.015 opacity — nearly invisible texture)
- **Pain card hover**: green top-border slides in from left (`scaleX` transition)

### Layout principles

- Left-aligned content (not centered) — editorial newspaper feel
- Grid-bordered cards with no gap (borders between cells, not box shadows)
- Horizontal rules (`border-bottom: 1.5px solid var(--stone-900)`) under section headers
- Contact section uses `--stone-900` dark background as a visual anchor at page bottom
- No border-radius on buttons or form — sharp corners throughout
- Section padding: `80px 0` desktop, `60px 0` mobile

### Do and don't

- **Do** keep headings in `--font-serif` (Playfair Display)
- **Do** use monospace only for UI chrome and metadata, not body copy
- **Don't** add box shadows to cards — the grid border system replaces shadows
- **Don't** add border-radius — the design is intentionally sharp/square
- **Don't** use blue or any cool accent — the palette is warm stone + sage green only
