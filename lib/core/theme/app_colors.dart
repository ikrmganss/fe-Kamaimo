import 'package:flutter/material.dart';

/// Palet warna Berani Kamaimo — Pine aesthetic dari Figma design.
/// Referensi: Beranda - Berani Kamaimo (Aesthetic & Peta Interaktif).
class AppColors {
  AppColors._();

  // ── Primary Pine ──
  static const Color pine900 = Color(0xFF1D3A30);    // heading utama
  static const Color pine800 = Color(0xFF15442D);    // navbar active, pill active
  static const Color pine700 = Color(0xFF2E5C43);    // tombol primer, badge
  static const Color pine600 = Color(0xFF35644A);    // logo bg
  static const Color pine500 = Color(0xFF467A5C);    // label section, lokasi
  static const Color pine400 = Color(0xFF50725E);    // KAMAIMO secondary text

  // ── Accent Emerald ──
  static const Color emerald500 = Color(0xFF10B981); // CTA, success dot
  static const Color emerald600 = Color(0xFF065F46); // text pada badge hijau
  static const Color emerald100 = Color(0xFFD1FAE5); // badge background
  static const Color emerald50  = Color(0xFFECFDF5); // light badge bg

  // ── Surface & Background ──
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color background  = Color(0xFFF8FAF4); // base halaman (hijau sangat muda)
  static const Color surfaceElevated = Color(0xFFF2F4EE); // card gradient via
  static const Color surfaceVariant = Color(0xFFEDEFE9); // secondary button

  // ── Text ──
  static const Color textPrimary   = Color(0xFF1D3A30);
  static const Color textSecondary = Color(0xFF414943);
  static const Color textTertiary  = Color(0xFF717972);  // placeholder, caption
  static const Color textMuted     = Color(0xFF505953);  // nav inactive
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Border & Divider ──
  static const Color border       = Color(0xFFE2E8E0);
  static const Color borderLight  = Color(0x80E2E8E0);  // 50% opacity
  static const Color divider      = Color(0xFFE2E8E0);

  // ── Semantic ──
  static const Color error   = Color(0xFFE53935);
  static const Color warning = Color(0xFFF59E0B); // orange marker, weather icon bg
  static const Color info    = Color(0xFF3B82F6); // blue map marker
  static const Color success = Color(0xFF10B981);

  // ── Glass / Overlay ──
  static const Color glassBg       = Color(0xCCFFFFFF);    // 80% white
  static const Color glassBgStrong = Color(0xF2FFFFFF);    // 95% white
  static const Color glassBorder   = Color(0x80E2E8E0);

  // ── Shadows ──
  static const List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x0B2E5C43), // 4% pine700
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0B2E5C43),
      blurRadius: 32,
      offset: Offset(0, -4),
    ),
  ];

  static const List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Color(0x122E5C43), // 7% pine700
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  // ── Gradients ──
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFECFDF5), Color(0xFFF2F4EE), surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardImageOverlay = LinearGradient(
    colors: [Color(0x00000000), Color(0x8C000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
