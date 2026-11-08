import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/token_store.dart';
import 'eksplor_data.dart';

/// Data Tab Eksplor dari BE (`/hotel`, `/kuliner`).
/// Mapper murni (static) agar bisa dites tanpa jaringan.
class EksplorService {
  EksplorService({ApiClient? apiClient})
    : _api = apiClient ?? ApiClient(tokenStore: InMemoryTokenStore());

  final ApiClient _api;

  Future<List<HotelItem>> fetchHotel() async {
    final rows = (await _api.get('/hotel'))['data'] as List? ?? const [];
    return [for (final r in rows) mapHotel(r as Map<String, dynamic>)];
  }

  Future<List<KulinerItem>> fetchKuliner() async {
    final rows = (await _api.get('/kuliner'))['data'] as List? ?? const [];
    return [for (final r in rows) mapKuliner(r as Map<String, dynamic>)];
  }

  /// BE: nama_hotel, jumlah_kamar, harga_minimum/maximum, dst → HotelItem.
  static HotelItem mapHotel(Map<String, dynamic> r) {
    final kamar = (r['jumlah_kamar'] as num?)?.toInt() ?? 0;
    final tidur = (r['jumlah_tempatTidur'] as num?)?.toInt() ?? 0;
    final website = r['website'] as String? ?? '';
    return HotelItem(
      foto: r['foto'] as String? ?? '',
      nama: r['nama_hotel'] as String? ?? '',
      wilayah: r['wilayah'] as String? ?? '',
      lokasi: r['lokasi'] as String? ?? '',
      tag: r['tag'] as String? ?? '',
      rating: trimRating(r['rating']),
      ratingCount: r['rating_count'] as String? ?? '',
      highlight: r['highlight'] as String? ?? '',
      harga: (r['harga_minimum'] as num?)?.toInt() ?? 0,
      hargaCoret: (r['harga_maximum'] as num?)?.toInt(),
      chips: [
        if (kamar > 0) (Icons.apartment_rounded, '$kamar Kamar'),
        if (tidur > 0) (Icons.king_bed_rounded, '$tidur Tempat Tidur'),
        if (website.isNotEmpty) (Icons.language_rounded, 'Website Resmi'),
      ],
    );
  }

  /// "4.90" → "4.9"; bukan angka → apa adanya.
  static String trimRating(dynamic raw) {
    final d = double.tryParse('$raw');
    return d?.toString() ?? '$raw';
  }

  /// BE: nama_makanan, bahan string, dst → KulinerItem.
  static KulinerItem mapKuliner(Map<String, dynamic> r) {
    return KulinerItem(
      foto: r['foto'] as String? ?? '',
      nama: r['nama_makanan'] as String? ?? '',
      warung: r['warung'] as String? ?? '',
      wilayah: r['wilayah'] as String? ?? '',
      tag: r['tag'] as String?,
      deskripsi:
          (r['deskripsi_id'] ?? r['deskripsi_en'] ?? '') as String? ?? '',
      bahan: mapBahan(r['bahan'] as String?),
    );
  }

  /// "🌿 Asam Jawa Muda, 🌶️ Cabai Rawit Hijau" → chip (ikon, teks, warna).
  /// Emoji seed dihapus — tampilan selalu ikon Material, tanpa emoji.
  static List<(IconData, String, ChipKind)> mapBahan(String? raw) {
    if ((raw ?? '').trim().isEmpty) return const [];
    final kinds = [ChipKind.mint, ChipKind.peach, ChipKind.cream];
    final items = raw!.split(',').where((e) => e.trim().isNotEmpty).toList();
    return [
      for (final (i, item) in items.indexed)
        (_bahanIcon(item), _stripEmoji(item.trim()), kinds[i % 3]),
    ];
  }

  /// "🌿 Asam Jawa Muda" → "Asam Jawa Muda" (token tanpa huruf = emoji).
  static String _stripEmoji(String s) {
    final spasi = s.indexOf(' ');
    if (spasi <= 0) return s;
    final first = s.substring(0, spasi);
    return first.contains(RegExp(r'[a-zA-Z]')) ? s : s.substring(spasi + 1);
  }

  static IconData _bahanIcon(String label) {
    final l = label.toLowerCase();
    if (l.contains('cabai') || l.contains('pedas')) {
      return KulinerIcons.cabai;
    }
    if (l.contains('tuna') || l.contains('ikan')) return KulinerIcons.tuna;
    if (l.contains('pisang')) return KulinerIcons.daunPisang;
    if (l.contains('santan')) return KulinerIcons.santan;
    if (l.contains('daging')) return KulinerIcons.daging;
    if (l.contains('ketan') || l.contains('beras') || l.contains('singkong')) {
      return KulinerIcons.singkong;
    }
    if (l.contains('kunyit') || l.contains('jahe')) return KulinerIcons.kunyit;
    return KulinerIcons.asamJawa;
  }
}
