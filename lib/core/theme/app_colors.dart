import 'package:flutter/material.dart';

/// Palet warna Berani Kamaimo — Pine aesthetic dari Figma design.
/// Referensi: Beranda - Berani Kamaimo (Aesthetic & Peta Interaktif).
/// Design Spec colors: Primary #1A3A2A, Background #F6F8F5, Surface #FFFFFF
class AppColors {
  AppColors._();

  // ── Primary Pine (match Figma design spec) ──
  static const Color pine900 = Color(0xFF1A3A2A);    // Primary brand - heading utama
  static const Color pine800 = Color(0xFF1E4D35);    // navbar active, pill active (darker)
  static const Color pine700 = Color(0xFF3B6E53);    // tombol primer, badge (Secondary/Accent)
  static const Color pine600 = Color(0xFF4A7C5E);    // logo bg
  static const Color pine500 = Color(0xFF5A8A6C);    // label section, lokasi
  static const Color pine400 = Color(0xFF6B987B);    // secondary text

  // ── Accent Emerald ──
  static const Color emerald500 = Color(0xFF10B981); // CTA, success dot
  static const Color emerald600 = Color(0xFF065F46); // text pada badge hijau
  static const Color emerald100 = Color(0xFFD1FAE5); // badge background
  static const Color emerald50  = Color(0xFFECFDF5); // light badge bg

  // ── Surface & Background (match Figma) ──
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color background  = Color(0xFFF6F8F5); // base halaman (match Figma #F6F8F5)
  static const Color surfaceElevated = Color(0xFFF2F4EE); // card gradient via
  static const Color surfaceVariant = Color(0xFFEDEFE9); // secondary button

  // ── Text (match Figma spec) ──
  static const Color textPrimary   = Color(0xFF1C241F);  // #1C241F per Figma spec
  static const Color textSecondary = Color(0xFF616E66);  // #616E66 per Figma spec
  static const Color textTertiary  = Color(0xFF405A32);  // #405A32 per Figma spec
  static const Color textMuted     = Color(0xFF717972);  // placeholder, caption
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Border & Divider ──
  static const Color border       = Color(0xFFE5EAE2);  // #E5EAE2 per Figma spec
  static const Color borderLight  = Color(0x80E5EAE2);  // 50% opacity
  static const Color divider      = Color(0xFFE5EAE2);

  // ── Semantic ──
  static const Color error   = Color(0xFFE53935);
  static const Color warning = Color(0xFFF59E0B); // orange marker, weather icon bg
  static const Color info    = Color(0xFF3B82F6); // blue map marker
  static const Color success = Color(0xFF10B981);

  // ── Glass / Overlay ──
  static const Color glassBg       = Color(0xCCFFFFFF);    // 80% white
  static const Color glassBgStrong = Color(0xF2FFFFFF);    // 95% white
  static const Color glassBorder   = Color(0x80E5EAE2);

  // ── Shadows (match Figma spec) ──
  static const List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x0A1A3A2A), // 4% pine900
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowFloating = [
    BoxShadow(
      color: Color(0x1F1A3A2A), // 12% pine900 - match Figma 0px 16px 36px -6px rgba(26, 58, 42, 0.12)
      blurRadius: 36,
      offset: Offset(0, 16),
      spreadRadius: -6,
    ),
  ];

  static const List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Color(0x0A1A3A2A), // 4% pine900
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

  // Hero overlay gradient (match Figma: rgba(18, 40, 29, 0.8) to transparent)
  static const LinearGradient heroImageOverlay = LinearGradient(
    colors: [Color(0xCC12281D), Color(0x0012281D)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
