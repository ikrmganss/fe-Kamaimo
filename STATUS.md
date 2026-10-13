# STATUS — Berani Kamaimo

> Alat sinkronisasi antar-agent. Update tiap kali selesai/blocked/ganti fase.

## Info Proyek

| Item | Nilai |
|---|---|
| Nama | Berani Kamaimo |
| Root | `~/Dokumen/APL/berani_kamaimo` |
| Backend | Reuse `Backend_Dinas_Pariwisata` (Express + Prisma/PostgreSQL, port 3000) |
| Target | 1 aplikasi Flutter: mode user (publik) + mode admin (pintu rahasia) |

## Fase

| Fase | Status | Owner | Catatan |
|---|---|---|---|
| M0 — Skeleton + kontrak | 🟡 In progress | AI Claude | Setup struktur, tema, model, repository — 85% selesai |
| M1 — Mode user inti | 🟡 In progress | AI Claude | NavBar+Hero+Filter+Peta(placeholder)+Carousel+Event+Footer selesai; flutter run belum diverifikasi |
| M2 — Mode user lengkap | 🔲 Not started | — | Paket, Kuliner, Hotel, Ulasan, Ranking Turis |
| M3 — Mode admin | 🔲 Not started | — | Login rahasia, dashboard, CRUD 9 entitas, super admin |

Legenda: 🔲 Not started · 🟡 In progress · ✅ Done · 🔴 Blocked

## Next Task

Lihat Figma Design 1 (6 halaman desain) untuk styling akurat, lalu lanjut:
- M1-1.2 — NavBar blur saat scroll
- M1-1.3 — Menu scroll-to-section
- M1-1.4 — Hero paralax + animasi judul per-huruf
- M1-2 — Peta `flutter_map` + Carousel 3D cover-flow
- M1-3 — Detail Desa + "How to Get There"

## Blocker

- None

## Keputusan Aktif

1. Urutan build resmi: **M0 → M1 → M2 → M3**.
2. **Sleek design system di-skip dulu** (key belum tersedia).
3. Backend reuse apa adanya, kecuali model+rute `kunjunganTuris` (fitur Ranking Asal Turis).
4. Pintu admin pakai **kandidat A**: ketik kode rahasia di kolom pencarian Home.
6. App dibuka ke **Halaman Sambutan** tiap kali dibuka; Home hanya lewat tombol "Masuk" (PRD v1.1, [[Halaman Sambutan]]).
5. State management pakai `provider`.

## Link Penting

- BRAIN overview: `~/Dokumen/Obsidian/BRAIN/berani_kamaimo/proyek.md`
- PRD: `~/Dokumen/APL/berani_kamaimo/PRD.md`
- Perencanaan ini: `~/Dokumen/Obsidian/BRAIN/berani_kamaimo/log/Perencanaan Lengkap Build M0-M3.md`
- Backend API: `~/Dokumen/Obsidian/BRAIN/berani_kamaimo/Backend.md`
- Database: `~/Dokumen/Obsidian/BRAIN/berani_kamaimo/Database.md`
