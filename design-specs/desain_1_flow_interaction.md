# Desain 1 - Flow & Interaksi (Beranda "Berani Kamaimo")

## 🖼️ Export Screenshot
File: `/home/muh-ikhram/gembot_design1/desain_1_beranda.png` (2.8 MB, PNG 2x scale)

## 📐 Dimensi Desain
- Mobile frame: **412 x 2999 px**
- Safe area / padding horizontal: **20px**

---

## 🧭 INTERAKSI / FLOW SETIAP TOMBOL

### 1. Header Sticky Bar
| Elemen | Teks/Icon | Aksi |
|---|---|---|
| Logo | (SVG Gambar Pula) | Branding statis |
| Teks | "Berani Kamaimo" + "SULAWESI TENGAH" | Statis |
| Icon notifikasi | 🔔 | → Buka halaman Notifikasi |
| Avatar | (user foto) | → Buka halaman Profil |

### 2. Greeting & Weather
| Elemen | Teks/Icon | Aksi |
|---|---|---|
| Avatar | (traveler) | → Profil |
| Teks | "Halo, Penjelajah" / "Kamaimo Sulteng" | Statis |
| Weather badge | "28°C Cerah" | Statis |

### 3. Category Pills
| Tombol | Label | Aksi |
|---|---|---|
| Semua | "Semua" | Filter semua destinasi di feed |
| Bahari & Karst | | Filter kategori Bahari/Karst |
| Megalitikum | | Filter kategori Megalitikum |
| Budaya & Adat | | Filter kategori Budaya |
| Kuliner Khas | | Filter kategori Kuliner |

### 4. Search Bar
| Elemen | Label | Aksi |
|---|---|---|
| Input | "Cari Danau Paisu Pok, Sombori..." | → Buka pencarian penuh |
| Icon filter | (funnel) | → Buka panel filter pencarian |

### 5. Hero Card (Danau Paisu Pok)
| Tombol | Label | Aksi |
|---|---|---|
| Bookmark | (icon simpan) | Simpan/remove ke favorit |
| CTA | "Jelajahi Sekarang" | → Detail halaman Danau Paisu Pok |
| Tag harga | "Rp 15.000 /org" | Tampilkan harga tiket masuk |

### 6. Section: Destinasi Ikonik Sulteng
| Element | Label | Aksi |
|---|---|---|
| "Lihat Semua" | (link) | → Buka halaman semua destinasi |
| Card 1: Kep. Sombori | (gambar + judul) | → Detail Sombori |
| Tombol simpan (masing-masing card) | (bookmark icon) | Simpan ke favorit |
| CTA card 1 | "JelajahI" / "Rp 350.000 /hari" | → Booking/tour info |
| Card 2: Danau Poso & Saluopa | | → Detail Danau Poso |
| Card 3: Lembah Bada & Besoa | | → Detail Lembah Bada |
| "Lihat Semua" (akhir scroll) | | Scroll lebih lanjut / semua destinasi |

### 7. Event Promo Card
| Elemen | Label | Aksi |
|---|---|---|
| Countdown | "H-45 Hari" | Statis |
| CTA | "Lihat Rincian" | → Detail event Festival Danau Poso |

### 8. Quick Access Menu
| Tombol | Label | Aksi |
|---|---|---|
| Button | "Buka" | → Buka peta desa wisata full screen |

### 9. Statistik Wisman
| Elemen | Label | Aksi |
|---|---|---|
| Button | "Top 3 Turis" | → Lihat ranking lengkap |
| 1st: Jerman | | Statis |
| 2nd: Prancis | | Statis |
| 3rd: Australia | | Statis |

### 10. Testimonial
| Elemen | Label | Aksi |
|---|---|---|
| Avatar + Nama | "Lukas Weber" | → Profil user |
| Bintang | (5x icon) | Rating statis |

### 11. Concierge WhatsApp Banner
| Tombol | Label | Aksi |
|---|---|---|
| Button | "Chat WA" | → Buka WhatsApp chat ke Dinas Pariwisata |

### 12. Footer
| Elemen | Teks | Aksi |
|---|---|---|
| Text | "Dinas Pariwisata Provinsi Sulawesi Tengah" | Statis |
| Text | "BBWI • Berani Kamaimo" | Statis |

### 13. Bottom Navigation Bar (Floating)
| Tab | Label | Aksi |
|---|---|---|
| Beranda | (ikon rumah) | Aktif / kembali ke beranda |
| Destinasi | (ikon lokasi) | → Halaman semua destinasi |
| Event | (ikon kalender) | → Halaman semua event |
| Paket | (ikon keranjang) | → Halaman paket wisata |
| Kuliner | (ikon makanan) | → Halaman kuliner |

---

## 📋 Sisa Frame / Halaman yang Belum Dibuat

### Frame yang belum ada:
1. **Halaman Detail Destinasi** 
   - Contoh: Detail Danau Paisu Pok
   - Galeri foto, deskripsi, paket tiket, lokasi peta
2. **Halaman "Semua Destinasi" / Grid List**
   - Menampilkan semua tujuan wisata
3. **Halaman "Semua Event"**
   - Daftar event mendatang, filter, ranger
4. **Halaman Detail Event**
   - Contoh: Festival Danau Poso 2025
5. **Halaman Pencarian**
   - Hasil pencarian dari search bar
6. **Halaman Profil**
   - Info user, riwayat booking, favorit
7. **Halaman Notifikasi**
   - Daftar notifikasi push
8. **Halaman Keranjang / Booking**
   - Checkout paket/event/destinasi

### Diagram Alur (Text Flow)
```
Beranda (Desain 1) 
  ├─ [Search] → Halaman Pencarian
  ├─ [Category Pill] → Filtered Beranda atau Halaman Semua Destinasi
  ├─ [Hero CTA "Jelajahi Sekarang"] → Detail Destinasi (mis. Danau Paisu Pok)
  ├─ [Card Destinasi] → Detail Destinasi masing-masing
  ├─ [Lihat Semua Destinasi] → Halaman Semua Destinasi
  ├─ [Event Card CTA "Lihat Rincian"] → Detail Event (mis. Festival Danau Poso)
  ├─ [Icon Simpan] → Tambah ke Favorit (aksi lokal)
  ├─ [Quick Access "Buka"] → Peta Desa Wisata Full Screen
  ├─ [Statistik "Top 3 Turis"] → Ranking lengkap Wisman
  ├─ [Testimoni Author] → Profil Pengguna
  ├─ [Chat WA] → Chat WhatsApp Dinas Pariwisata
  ├─ [Notifikasi Icon] → Halaman Notifikasi
  ├─ [Profil Avatar] → Halaman Profil
  └─ [Bottom Tab Bar] → Navigasi global (Beranda/Destinasi/Event/Paket/Kuliner)
```

## 📁 File Pendukung
- Spec lengkap: `/home/muh-ikhram/gembot_design1/flutter_handoff_spec.md`
- Screenshot PNG: `/home/muh-ikhram/gembot_design1/desain_1_beranda.png`
