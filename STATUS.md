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
| M1 — Mode user inti | 🟡 In progress | AI Claude | Beranda ✅ + Destinasi (4258) ✅ + Event (3641-2) ✅ + Paket ✅ + Eksplor ✅ (oleh tim, `7974546`); flutter run belum diverifikasi |
| M2 — Mode user lengkap | 🔲 Not started | — | Paket, Kuliner, Hotel, Ulasan, Ranking Turis |
| M3 — Mode admin | 🟡 In progress | AI Claude | M3-1 ✅ (pintu rahasia, login, guard, secure storage) + M3-2 ✅ (shell, sidebar, jam, logout, dashboard premium) + M3-3 ✅ (CrudScreen kartu data per entitas); backend: `magangpade/BE_BeraniKamaimo` (MySQL), `/pageview/summary` belum ada (spec di docs/backend-api-spec.md §6) |

Legenda: 🔲 Not started · 🟡 In progress · ✅ Done · 🔴 Blocked

## Next Task

- Backend tim: tambah `GET /pageview/summary` (spec: `docs/backend-api-spec.md` §6) → 6 kartu dashboard hidup
- `flutter run` untuk verifikasi visual (M1 aset crop + mode admin)
- CRUD form detail per entitas (CrudScreen saat ini generic placeholder; form tambah/edit belum detail per field entitas)

## Blocker

- `/pageview/summary` belum ada di backend (6 kartu pakai fallback `/visitor/summary` untuk All Days)

## Catatan Sesi 2026-11-07

- **M3-1 + M3-2 + M3-3 mode admin dibangun** per rencana kanonik:
  - Gate kandidat A (`adminBK2025` di search bar) → navigasi ke `/admin-login` (bukan snackbar lagi).
  - `AdminLoginScreen` (card, username/password show-hide, tombol disabled saat kosong, error jelas, "Mode admin terbuka" indicator); `AuthRepository` (login → token + user ke secure storage); `InMemoryTokenStore` (M0 stub, M3 diganti flutter_secure_storage); `ApiClient` interceptor Bearer otomatis.
  - `AdminShell`: sidebar gradient pine, menu 10 item (Super Admin kondisional by role), `DateTimeWidget` jam live id-ID, dropdown akun (avatar warna by gender + logout → Halaman Sambutan), routing ke DashboardScreen + CrudScreen per menu. Responsive: sidebar tetap di desktop, Drawer di mobile.
  - `DashboardScreen`: desain premium pine gradient, header branding "Portal Pengelola Berani Kamaimo", badge "Sistem Aktif", **Ringkasan Konten Pariwisata** (6 kartu statistik: Desa Wisata 43, Jalur Desa 31, Event 12, Paket Wisata 8, Kuliner 16, Hotel 34), **Pintasan Manajemen** (4 tombol cepat), **Panduan Kurasi** (foto 16:9, bahasa dwi, GPS, WhatsApp deeplink). Tanpa grafik / tanpa data kunjungan turis.
  - `CrudScreen`: kartu data asli per entitas (Desa Wisata, Jalur Desa, Atraksi, Paket Wisata, Kuliner, Rumah Makan, Hotel, Ulasan) — setiap kartu punya foto, nama, lokasi, rating, status, aksi Detail / Edit / Hapus. Search bar + seed data Sulteng. Tombol "Tambah Data" dengan dialog form.
  - `ProfilDialog`: edit nama/jenis kelamin/password, ganti password → force logout.
- Grafik `fl_chart` dihapus dari dashboard (data kunjungan belum ada dari backend, PRD §19/§20). Diganti placeholder 0 + info jujur.
- Test 14/14 lulus; analyze nol error baru.
- Dep baru: `fl_chart` (dihapus dari dashboard, tetap di pubspec), `flutter_secure_storage`. Belum commit.

## Catatan Sesi 2026-10-28

- Tab **Paket** dibangun dari PNG export user (konvensi feature-folder: `paket_screen` tipis + `paket_data` seed 4 paket + widgets/). Search + filter kategori (Semua/Bahari/Budaya/Trekking) + carousel PageView + kartu fasilitas 2×2 + CTA WhatsApp (placeholder snackbar) + kartu trust. Test: `test/paket_smoke_test.dart` 2/2.
- **Fix file rusak teman tim**: `detail_event_screen.dart` ter-commit dengan syntax error (duplikasi `_jadwal`/`_month`, 3 kurang bracket, `const` ilegal) — semua test gagal loading. Sudah diperbaiki + bersihkan getter tak terpakai; 12/12 test lulus ulang.

## Keputusan Aktif

1. Urutan build resmi: **M0 → M1 → M2 → M3**.
2. **Detail Wisata sudah SESUAI** (commit `51c97da` + golden) — node `4714:452` di PRD lama batal, tidak perlu rebuild.
3. **Sleek design system di-skip dulu** (key belum tersedia).
3. Backend aktif: `magangpade/BE_BeraniKamaimo` (MySQL); backend lama Postgres tidak dipakai lagi. Kekecualian tetap: model+rute `kunjunganTuris` bila belum ada.
4. Pintu admin pakai **kandidat A**: ketik kode rahasia di kolom pencarian Home.
6. App dibuka ke **Halaman Sambutan** tiap kali dibuka; Home hanya lewat tombol "Masuk" (PRD v1.1, [[Halaman Sambutan]]).
5. State management pakai `provider`.

## Link Penting

- BRAIN overview: `~/Dokumen/Obsidian/BRAIN/berani_kamaimo/proyek.md`
- PRD: `~/Dokumen/APL/berani_kamaimo/PRD.md`
- Perencanaan ini: `~/Dokumen/Obsidian/BRAIN/berani_kamaimo/log/Perencanaan Lengkap Build M0-M3.md`
- Backend API: `~/Dokumen/Obsidian/BRAIN/berani_kamaimo/Backend.md`
- Database: `~/Dokumen/Obsidian/BRAIN/berani_kamaimo/Database.md`
