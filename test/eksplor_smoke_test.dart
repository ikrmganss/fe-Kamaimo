import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/token_store.dart';
import 'package:berani_kamaimo/features/user/eksplor/eksplor_screen.dart';
import 'package:berani_kamaimo/features/user/eksplor/eksplor_data.dart';
import 'package:berani_kamaimo/features/user/eksplor/eksplor_service.dart';
import 'package:berani_kamaimo/features/user/eksplor/widgets/kuliner_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Service palsu: data seed langsung, tanpa jaringan.
class _SeedService extends EksplorService {
  _SeedService()
    : super(apiClient: ApiClient(tokenStore: InMemoryTokenStore()));

  @override
  Future<List<HotelItem>> fetchHotel() async => EksplorSeed.hotel;

  @override
  Future<List<KulinerItem>> fetchKuliner() async => EksplorSeed.kuliner;
}

/// Smoke test Tab Eksplor (Katalog Wisata & Kuliner) — desain dari PNG export
/// user (Tempat Menginap / Kuliner Khas), dikerjakan 2026-10-29.
void main() {
  testWidgets('tab Eksplor: segmented mengganti katalog Menginap <-> Kuliner', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(home: EksplorScreen(service: _SeedService())),
    );
    await tester.pumpAndSettle();

    // Header + segmented selalu tampil
    expect(find.text('Katalog Wisata & Kuliner'), findsOneWidget);
    expect(find.text('KATALOG PILIHAN DINAS PARIWISATA'), findsOneWidget);
    expect(find.byKey(const Key('eksplorTabMenginap')), findsOneWidget);
    expect(find.byKey(const Key('eksplorTabKuliner')), findsOneWidget);

    // Default tab Tempat Menginap: kartu hotel + trust card
    expect(find.text('Swiss–Belhotel Silae Palu'), findsOneWidget);
    expect(find.text('Jaminan Harga Resmi Dinas Pariwisata'), findsOneWidget);
    expect(find.text('Mulai dari'), findsWidgets);
    // Kartu berikutnya ikut ter-render (peek) → tombol aksi bisa lebih dari 1
    expect(find.text('Telepon'), findsWidgets);
    expect(find.text('Maps'), findsWidgets);
    expect(find.text('Website'), findsWidgets);

    // Switch ke tab Kuliner: intro gastronomi + kartu kuliner
    await tester.tap(find.byKey(const Key('eksplorTabKuliner')));
    await tester.pumpAndSettle();

    expect(find.text('Cita Rasa Otentik Bumi Tadulako'), findsOneWidget);
    expect(find.text('EKSPLORASI GASTRONOMI'), findsOneWidget);
    expect(find.text('Onyop (Kuah Asam Ikan Segar)'), findsOneWidget);
    // Trust card hanya ada di tab hotel
    expect(find.text('Jaminan Harga Resmi Dinas Pariwisata'), findsNothing);

    // Balik ke tab hotel
    await tester.tap(find.byKey(const Key('eksplorTabMenginap')));
    await tester.pumpAndSettle();
    expect(find.text('Swiss–Belhotel Silae Palu'), findsOneWidget);

    // Kartu harus ukuran mengikuti konten (tidak di-stretch penuh karusel 700)
    await tester.tap(find.byKey(const Key('eksplorTabKuliner')));
    await tester.pumpAndSettle();
    final cardRender = tester.renderObject<RenderBox>(
      find.byType(KulinerCard).first,
    );
    expect(
      cardRender.size.height,
      lessThan(700),
      reason: 'Kartu tidak boleh di-stretch memenuhi tinggi karusel',
    );
  });

  testWidgets('search memfilter kartu per tab aktif', (tester) async {
    tester.view.physicalSize = const Size(430, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(home: EksplorScreen(service: _SeedService())),
    );
    await tester.pumpAndSettle();

    // Tab kuliner: cari "kaledo"
    await tester.tap(find.byKey(const Key('eksplorTabKuliner')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'kaledo');
    await tester.pumpAndSettle();

    expect(find.text('Kaledo (Kaki Lemboe Asli)'), findsOneWidget);
    expect(find.text('Onyop (Kuah Asam Ikan Segar)'), findsNothing);
    expect(find.text('Lalampa (Ketan Bakar Isi Tuna)'), findsNothing);

    // Query ngawur → pesan kosong
    await tester.enterText(find.byType(TextField), 'rendang padang');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('eksplorKosong')), findsOneWidget);

    // Bersihkan & switch tab hotel: cari "swiss"
    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.byKey(const Key('eksplorTabMenginap')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'swiss');
    await tester.pumpAndSettle();

    expect(find.text('Swiss–Belhotel Silae Palu'), findsOneWidget);
    expect(find.text('Bukabuka Island Resort'), findsNothing);
  });

  test('mapper BE: hotel & kuliner diubah ke model UI', () {
    const hotelJson = {
      'nama_hotel': 'Hotel Uji',
      'wilayah': 'Palu',
      'lokasi': 'Jl. Uji',
      'tag': 'Tag Uji',
      'rating': '4.90',
      'rating_count': '12',
      'highlight': 'Highlight Uji',
      'harga_minimum': 100000,
      'harga_maximum': 200000,
      'jumlah_kamar': 10,
      'jumlah_tempatTidur': 4,
      'website': 'https://uji.id',
      'foto': 'assets/images/eksplor/hotel1.jpg',
    };
    final h = EksplorService.mapHotel(hotelJson);
    expect(h.nama, 'Hotel Uji');
    expect(h.rating, '4.9'); // 4.90 → 4.9
    expect(h.harga, 100000);
    expect(h.hargaCoret, 200000);
    expect(
      h.chips.map((c) => c.$2),
      containsAll(['10 Kamar', '4 Tempat Tidur']),
    );

    const kulinerJson = {
      'nama_makanan': 'Masakan Uji',
      'warung': 'Warung Uji',
      'wilayah': 'Palu',
      'tag': null,
      'deskripsi_id': 'Deskripsi uji.',
      'foto': 'assets/images/eksplor/kuliner1.jpg',
      'bahan': '🌿 Asam Jawa Muda, 🌶️ Cabai Rawit Hijau',
    };
    final k = EksplorService.mapKuliner(kulinerJson);
    expect(k.deskripsi, 'Deskripsi uji.');
    expect(k.bahan, hasLength(2));
    // Emoji dibuang → label murni teks
    expect(k.bahan[0].$2, 'Asam Jawa Muda');
    expect(k.bahan[1].$2, 'Cabai Rawit Hijau');
  });
}
