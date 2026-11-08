import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../home/user_shell.dart';
import 'eksplor_data.dart';
import 'eksplor_service.dart';
import 'widgets/eksplor_header.dart';
import 'widgets/hotel_card.dart';
import 'widgets/kuliner_card.dart';
import 'widgets/trust_card.dart';

/// Tab Eksplor — "Katalog Wisata & Kuliner" (Tempat Menginap / Kuliner Khas)
/// sesuai 2 PNG export desain dari user (2026-10-29).
///
/// Data dari BE via `EksplorService` (/hotel, /kuliner).
class EksplorScreen extends StatefulWidget {
  const EksplorScreen({super.key, this.service});

  /// Injeksi untuk test; null = service nyata.
  final EksplorService? service;

  @override
  State<EksplorScreen> createState() => _EksplorScreenState();
}

class _EksplorScreenState extends State<EksplorScreen> {
  final _search = TextEditingController();
  final _page = PageController(viewportFraction: 0.95);

  int _tab = 0; // 0 = Tempat Menginap | 1 = Kuliner Khas
  int _wilayah = 0;
  String _query = '';

  // Data dari BE; null = masih memuat (gagal → fallback seed).
  List<HotelItem>? _hotelData;
  List<KulinerItem>? _kulinerData;
  EksplorService? _service;

  // Tinggi kartu tertinggi (self-measure) → tinggi karusel adaptif konten.
  double? _maxCardH;
  final _measureKeys = <GlobalKey>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {});
    try {
      final service = _service ??= widget.service ?? EksplorService();
      final hasil = await Future.wait([
        service.fetchHotel(),
        service.fetchKuliner(),
      ]);
      if (!mounted) return;
      setState(() {
        _hotelData = hasil[0] as List<HotelItem>;
        _kulinerData = hasil[1] as List<KulinerItem>;
        _maxCardH = null; // ukur ulang dengan data baru
      });
    } catch (e) {
      if (!mounted) return;
      // ponytail: fallback seed saat BE tak terjangkau (HP tak bisa localhost).
      // Naik level: hapus ini saat API_BASE_URL dijamin benar per perangkat.
      setState(() {
        _hotelData = EksplorSeed.hotel;
        _kulinerData = EksplorSeed.kuliner;
      });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    _page.dispose();
    super.dispose();
  }

  /// Reset ukuran terukur setiap data kartu berubah (tab/wilayah/query).
  void _invalidateCardHeight() {
    setState(() {
      _maxCardH = null;
      _measureKeys
        ..clear()
        ..addAll(
          List.generate(
            _tab == 0 ? _hotels.length : _kuliners.length,
            (_) => GlobalKey(),
          ),
        );
    });
  }

  void _measureCards() {
    if (_maxCardH != null || _measureKeys.isEmpty) return;
    double maxH = 0;
    for (final key in _measureKeys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) maxH = math.max(maxH, box.size.height);
    }
    if (maxH > 0) setState(() => _maxCardH = maxH);
  }

  List<HotelItem> get _hotels {
    final q = _query.trim().toLowerCase();
    final semua = _hotelData ?? const <HotelItem>[];
    return semua.where((h) {
      final cocokWilayah =
          _wilayah == 0 || h.wilayah == EksplorSeed.wilayah[_wilayah];
      final cocokQuery =
          q.isEmpty ||
          h.nama.toLowerCase().contains(q) ||
          h.wilayah.toLowerCase().contains(q) ||
          h.lokasi.toLowerCase().contains(q) ||
          h.tag.toLowerCase().contains(q);
      return cocokWilayah && cocokQuery;
    }).toList();
  }

  List<KulinerItem> get _kuliners {
    final q = _query.trim().toLowerCase();
    final semua = _kulinerData ?? const <KulinerItem>[];
    return semua.where((k) {
      final cocokWilayah =
          _wilayah == 0 || k.wilayah == EksplorSeed.wilayah[_wilayah];
      final cocokQuery =
          q.isEmpty ||
          k.nama.toLowerCase().contains(q) ||
          k.warung.toLowerCase().contains(q) ||
          (k.tag?.toLowerCase().contains(q) ?? false) ||
          k.wilayah.toLowerCase().contains(q);
      return cocokWilayah && cocokQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        key: const Key('eksplorScroll'),
        slivers: [
          const SliverPersistentHeader(
            pinned: true,
            delegate: KamaimoBarDelegate(showToggle: false),
          ),
          SliverToBoxAdapter(
            child: EksplorHeader(
              tabIndex: _tab,
              searchController: _search,
              wilayahIndex: _wilayah,
              onTab: (i) {
                setState(() => _tab = i);
                _invalidateCardHeight();
              },
              onQuery: (v) {
                setState(() => _query = v);
                _invalidateCardHeight();
              },
              onWilayah: (i) {
                setState(() => _wilayah = i);
                _invalidateCardHeight();
              },
            ),
          ),
          SliverToBoxAdapter(child: _intro()),
          SliverToBoxAdapter(child: _carousel()),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                if (_tab == 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TrustCard(),
                  ),
                const SizedBox(height: 24),
                const KamaimoFooter(),
                const KamaimoNavClearance(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Blok kontekstual di atas carousel per tab.
  Widget _intro() {
    final isHotel = _tab == 0;
    final jumlah = isHotel ? _hotels.length : _kuliners.length;

    return Padding(
      // Bawah: beri napas konsisten sebelum carousel
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isHotel) ..._gastronomi(),
          // Bullet + label verifikasi (kuliner diberi angka, seperti desain)
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.pine800,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isHotel
                    ? 'AKOMODASI TERVERIFIKASI PEMPROV'
                    : '$jumlah REKOMENDASI TERVERIFIKASI',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                  color: AppColors.pine500,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Intro besar tab Kuliner: chip "EKSPLORASI GASTRONOMI" + H2 + deskripsi.
  List<Widget> _gastronomi() {
    return [
      // Chip mint + ikon buku (kiri-aligned seperti desain)
      Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.mintSoftStrong,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, size: 15, color: AppColors.pine800),
            SizedBox(width: 6),
            Text(
              'EKSPLORASI GASTRONOMI',
              key: Key('eksplorGastronomi'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
                color: AppColors.pine800,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Cita Rasa Otentik Bumi Tadulako',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          height: 1.2,
          letterSpacing: -0.6,
          color: AppColors.pine900,
          fontFamily: 'PlusJakartaSans',
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Simfoni rempah segar, perasan asam alami, dan aroma gurih kelapa '
        'bakar warisan leluhur pesisir hingga pegunungan.',
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          height: 1.55,
          color: AppColors.textBody,
          fontFamily: 'PlusJakartaSans',
        ),
      ),
      const SizedBox(height: 18),
    ];
  }

  Widget _carousel() {
    final isHotel = _tab == 0;
    final kosong = isHotel ? _hotels.isEmpty : _kuliners.isEmpty;

    if (_hotelData == null || _kulinerData == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 56),
        child: Column(
          key: Key('eksplorMemuat'),
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(height: 12),
            Text(
              'Memuat katalog...',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          ],
        ),
      );
    }

    if (kosong) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 56),
        child: Column(
          key: Key('eksplorKosong'),
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 32,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: 10),
            Text(
              'Belum ada hasil untuk filter ini',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Coba kata kunci lain atau pilih wilayah lain',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          ],
        ),
      );
    }

    final cards = <Widget>[];
    if (isHotel) {
      cards.addAll([
        for (final h in _hotels) HotelCard(item: h, onKontak: _onKontak),
      ]);
    } else {
      cards.addAll([
        for (final k in _kuliners) KulinerCard(item: k, onKontak: _onKontak),
      ]);
    }

    if (_maxCardH == null) {
      // Samakan jumlah kunci dengan jumlah kartu (termasuk build pertama).
      if (_measureKeys.length != cards.length) {
        _measureKeys
          ..clear()
          ..addAll(List.generate(cards.length, (_) => GlobalKey()));
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureCards());
    }

    final pageH = _maxCardH ?? 700;

    return Stack(
      children: [
        SizedBox(
          height: pageH,
          child: PageView.builder(
            controller: _page,
            itemCount: cards.length,
            // Align melepas min-constraint dari PageView,
            // kartu ukuran ke kebutuhan konten.
            itemBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Align(alignment: Alignment.topCenter, child: cards[i]),
            ),
          ),
        ),
        if (_maxCardH == null)
          // Pass ukur: ter-render (bisa diukur), transparan & di-positioned
          // supaya tidak memengaruhi ukuran stack. Lebar kartu ukur harus
          // sama persis dengan lebar halaman PageView (0.88 viewport + padding)
          // supaya jumlah wrap teks (dan tingginya) identik.
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: LayoutBuilder(
              builder: (ctx, cons) {
                final pageW = cons.maxWidth * _page.viewportFraction - 10;
                return Opacity(
                  opacity: 0,
                  child: Column(
                    children: [
                      for (var i = 0; i < cards.length; i++)
                        KeyedSubtree(
                          key: _measureKeys[i],
                          child: SizedBox(width: pageW, child: cards[i]),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _onKontak() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kontak resmi: aktif saat data API (M2)')),
    );
  }
}
