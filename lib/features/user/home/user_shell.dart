import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';

/// Shell user: bottom nav floating + home screen panjang.
class UserShell extends StatefulWidget {
  const UserShell({super.key});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          // M2 screens — placeholder sementara
          _PlaceholderScreen('Destinasi'),
          _PlaceholderScreen('Event'),
          _PlaceholderScreen('Paket'),
          _PlaceholderScreen('Eksplor'),
        ],
      ),
      // Bottom nav floating glassmorphic (M1-1.1)
      bottomNavigationBar: _FloatingBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─── Floating Bottom Nav ───────────────────────────────────────────────────

class _FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingBottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    (icon: Icons.home_rounded, label: 'Beranda'),
    (icon: Icons.map_rounded, label: 'Destinasi'),
    (icon: Icons.event_rounded, label: 'Event'),
    (icon: Icons.card_giftcard_rounded, label: 'Paket'),
    (icon: Icons.explore_rounded, label: 'Eksplor'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 70,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(_items.length, (i) {
                  final item = _items[i];
                  final active = i == currentIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: 22,
                            color: active ? AppColors.pine800 : AppColors.textMuted,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: active ? FontWeight.bold : FontWeight.w500,
                              color: active ? AppColors.pine800 : AppColors.textMuted,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (active)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.pine800,
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Home Screen ─────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scroll = ScrollController();
  String _locale = 'ID'; // M1-1.6 language switcher state

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            slivers: [
              // NavBar sticky (M1-1.2)
              SliverPersistentHeader(
                pinned: true,
                delegate: _NavBarDelegate(
                  locale: _locale,
                  onToggleLocale: () {
                    setState(() => _locale = _locale == 'ID' ? 'EN' : 'ID');
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 7.2 Hero + Search (M1-1.4)
                    _HeroSection(locale: _locale),
                    // Quick Pill Filters
                    _QuickFilters(),
                    // 7.3 Peta Interaktif (M1-2)
                    _PetaSection(),
                    // 7.4 Carousel Wisata Unggulan (M1-2.6)
                    _CarouselWisata(),
                    // 7.6 Event & Atraksi (M1-2.7)
                    _EventSection(),
                    // 7.9 Footer
                    _Footer(),
                    // extra padding bawah untuk floating nav
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Nav Bar Delegate (sticky) ────────────────────────────────────────────────

class _NavBarDelegate extends SliverPersistentHeaderDelegate {
  final String locale;
  final VoidCallback onToggleLocale;

  const _NavBarDelegate({required this.locale, required this.onToggleLocale});

  @override
  double get minExtent => 64;
  @override
  double get maxExtent => 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo BERANI KAMAIMO
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.pine600,
                      borderRadius: BorderRadius.circular(5.65),
                    ),
                    child: const Icon(
                      Icons.landscape_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BERANI',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: AppColors.pine900,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'KAMAIMO',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w900,
                          color: AppColors.pine500,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Language Pill Switcher (M1-1.6)
              GestureDetector(
                onTap: onToggleLocale,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.6),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _LangPill(label: 'ID', active: locale == 'ID'),
                      const SizedBox(width: 8),
                      _LangPill(label: 'EN', active: locale == 'EN'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_NavBarDelegate old) =>
      old.locale != locale;
}

class _LangPill extends StatelessWidget {
  final String label;
  final bool active;
  const _LangPill({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.pine800 : Colors.transparent,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: active ? Colors.white : AppColors.textMuted,
          fontFamily: 'PlusJakartaSans',
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final String locale;
  const _HeroSection({required this.locale});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xB2ECFDF5), Color(0xFFF2F4EE), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border.withOpacity(0.7)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x122E5C43),
              blurRadius: 24,
              offset: Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.pine900,
                              letterSpacing: -0.65,
                              height: 1.25,
                            ),
                            children: [
                              TextSpan(text: 'Jelajahi Surga\nTersembunyi di \n'),
                              TextSpan(
                                text: 'Jantung Sulawesi',
                                style: TextStyle(color: AppColors.pine700),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Temukan pesona bahari kristal, labirin karst megah, '
                          'dan keagungan peradaban megalitikum tertua di Nusantara.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            height: 1.62,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Weather Card
                  _WeatherCard(),
                ],
              ),
              const SizedBox(height: 16),
              // Search Bar (kandidat A — secret admin code masuk sini, M1-1.5)
              _SearchBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 81,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emerald100.withOpacity(0.8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny_rounded, color: Color(0xFFF59E0B), size: 18),
              SizedBox(width: 4),
              Text(
                '29°C',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_rounded, size: 10, color: AppColors.emerald600),
              SizedBox(width: 2),
              Text('Palu', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.emerald600)),
            ],
          ),
          Text(
            'Cerah Berawan',
            style: TextStyle(fontSize: 9, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _ctrl = TextEditingController();

  // Kandidat A: ketik kode rahasia untuk masuk mode admin (M1-1.5 / Keputusan #4)
  static const String _secretCode = 'adminBK2025'; // ponytail: pindah ke env/config saat M3

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onSubmit(String value) {
    if (value.trim() == _secretCode) {
      _ctrl.clear();
      // M3: Navigator.pushNamed(context, AppConstants.routeAdminLogin);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mode admin: segera diaktifkan di M3')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _ctrl,
              onSubmitted: _onSubmit,
              style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari destinasi atau kabupaten...',
                hintStyle: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─── Quick Pill Filters ───────────────────────────────────────────────────────

class _QuickFilters extends StatefulWidget {
  @override
  State<_QuickFilters> createState() => _QuickFiltersState();
}

class _QuickFiltersState extends State<_QuickFilters> {
  int _selected = 0;
  static const _filters = ['Semua', 'Bahari & Karst', 'Megalitikum', 'Danau & Air Terjun'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 0, 0),
      child: SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (ctx, i) {
            final active = i == _selected;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? AppColors.pine700 : Colors.white,
                  borderRadius: BorderRadius.circular(9999),
                  border: active ? null : Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: Text(
                  _filters[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.bold : FontWeight.w600,
                    color: active ? Colors.white : AppColors.pine900,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Peta Section (M1-2: placeholder, flutter_map di M1-2.x) ─────────────────

class _PetaSection extends StatefulWidget {
  @override
  State<_PetaSection> createState() => _PetaSectionState();
}

class _PetaSectionState extends State<_PetaSection> {
  int _kabupatenIndex = 0;
  static const _kabupaten = ['Semua (43)', 'Banggai (14)', 'Poso (11)', 'Morowali (9)', 'Palu & Sigi (9)'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Peta Interaktif Desa Wisata',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pine900,
                  letterSpacing: -0.45,
                ),
              ),
              Container(
                height: 33,
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.emerald50,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: AppColors.emerald100),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.near_me_rounded, size: 12, color: AppColors.emerald600),
                    SizedBox(width: 5),
                    Text(
                      '12 di Sekitarmu',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Filter kabupaten
          SizedBox(
            height: 31,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _kabupaten.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final active = i == _kabupatenIndex;
                return GestureDetector(
                  onTap: () => setState(() => _kabupatenIndex = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: active ? AppColors.pine700 : Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                      border: active ? null : Border.all(color: AppColors.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _kabupaten[i],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.white : AppColors.pine900,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Peta Placeholder (M1-2: ganti dengan flutter_map)
          Container(
            height: 320,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2EB),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x141D3A30),
                  blurRadius: 32,
                  offset: Offset(0, 12),
                  spreadRadius: -6,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Placeholder background
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 48, color: AppColors.pine500.withOpacity(0.4)),
                      const SizedBox(height: 8),
                      Text(
                        'Peta Desa Wisata Sulteng',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pine500.withOpacity(0.6),
                        ),
                      ),
                      // ponytail: tambah flutter_map ^6.x saat M1-2; CartoDB Light tile layer
                    ],
                  ),
                ),
                // Legend (kiri bawah)
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        _LegendDot(color: AppColors.emerald500, label: 'Unggulan'),
                        SizedBox(width: 8),
                        _LegendDot(color: Color(0xFF3B82F6), label: 'Wisata Alam'),
                        SizedBox(width: 8),
                        _LegendDot(color: Color(0xFFF59E0B), label: 'Budaya'),
                      ],
                    ),
                  ),
                ),
                // Zoom controls (kanan atas)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Column(
                    children: [
                      _MapButton(icon: Icons.add),
                      const SizedBox(height: 6),
                      _MapButton(icon: Icons.remove),
                      const SizedBox(height: 6),
                      _MapButton(icon: Icons.my_location_rounded),
                    ],
                  ),
                ),
                // Card desa aktif (bawah)
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: _DesaActiveCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.pine900)),
      ],
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  const _MapButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, size: 16, color: AppColors.pine900),
    );
  }
}

class _DesaActiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E15442D),
            blurRadius: 40,
            offset: Offset(0, 16),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Foto thumbnail
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.pine500.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Icon(Icons.landscape, color: AppColors.pine500, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.emerald100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'DESA\nUNGGULAN',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: AppColors.emerald600,
                          letterSpacing: 0.225,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star_rounded, size: 12, color: AppColors.pine500),
                    const SizedBox(width: 2),
                    const Text('4.9', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.pine500)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppColors.pine700.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Text(
                        '2.4 km',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.pine700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Desa Luk Panenteng',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.pine900),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.pine700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Text('Buka', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, color: Colors.white, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Carousel Wisata Unggulan ─────────────────────────────────────────────────

class _CarouselWisata extends StatefulWidget {
  @override
  State<_CarouselWisata> createState() => _CarouselWisataState();
}

class _CarouselWisataState extends State<_CarouselWisata> {
  final _pageCtrl = PageController(viewportFraction: 0.75);
  int _page = 0;

  static const _items = [
    (
      kabupaten: 'BANGGAI KEPULAUAN',
      nama: 'Luk Panenteng & Danau Paisu Pok',
      desc: 'Air danau sejernih kaca dengan vegetasi hutan…',
      badge: 'KOLAM KACA',
      rating: '4.9',
      ulasan: '1.4k ulasan',
      harga: 'Rp 15.000',
      satuan: '/orang',
    ),
    (
      kabupaten: 'MOROWALI',
      nama: 'Kepulauan Sombori',
      desc: 'Karst megah, tebing cadas, & laguna toska.',
      badge: 'THE SECRET PARADISE',
      rating: '4.95',
      ulasan: '930 ulasan',
      harga: 'Rp 350.000',
      satuan: '/tur',
    ),
    (
      kabupaten: 'POSO • TENTENA',
      nama: 'Danau Poso & Pasir Emas',
      desc: 'Danau purba ketiga terbesar dengan pasir…',
      badge: 'PASIR EMAS TENTENA',
      rating: '4.88',
      ulasan: '2.1k ulasan',
      harga: 'Rp 10.000',
      satuan: '/orang',
    ),
  ];

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 12, color: AppColors.pine500),
                        SizedBox(width: 6),
                        Text(
                          'PILIHAN TERBAIK',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.pine500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Wisata Unggulan Sulteng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.pine900,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text('Semua', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.pine700)),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.pine700),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 460,
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: _items.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (ctx, i) {
                final item = _items[i];
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    left: i == 0 ? 16 : 8,
                    right: i == _items.length - 1 ? 16 : 8,
                    bottom: active ? 0 : 8,
                    top: active ? 0 : 8,
                  ),
                  child: _WisataCard(item: item),
                );
              },
            ),
          ),
          // Dot indicator
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_items.length, (i) {
              return Container(
                width: i == _page ? 16 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: i == _page ? AppColors.pine700 : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _WisataCard extends StatelessWidget {
  final ({
    String kabupaten,
    String nama,
    String desc,
    String badge,
    String rating,
    String ulasan,
    String harga,
    String satuan,
  }) item;

  const _WisataCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x141D3A30),
            blurRadius: 32,
            offset: Offset(0, 12),
            spreadRadius: -6,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area placeholder
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: AppColors.pine500.withOpacity(0.25),
                  child: const Center(
                    child: Icon(Icons.landscape, size: 64, color: AppColors.pine500),
                  ),
                ),
                // Gradient overlay
                const DecoratedBox(
                  decoration: BoxDecoration(gradient: AppColors.cardImageOverlay),
                ),
                // Badge top-left
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      item.badge,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.pine700,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ),
                ),
                // Rating bottom-left
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          item.rating,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${item.ulasan})',
                          style: const TextStyle(fontSize: 10, color: Color(0xB3FFFFFF)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info area
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 12, color: AppColors.pine500),
                    const SizedBox(width: 4),
                    Text(
                      item.kabupaten,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pine500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pine900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 11),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MULAI DARI',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textTertiary, letterSpacing: 0.5),
                        ),
                        Row(
                          children: [
                            Text(
                              item.harga,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.pine700),
                            ),
                            Text(
                              item.satuan,
                              style: const TextStyle(fontSize: 9, color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.pine700,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Row(
                        children: [
                          Text('Detail', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded, color: Colors.white, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Event Section ─────────────────────────────────────────────────────────────

class _EventSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.event_rounded, size: 12, color: AppColors.pine500),
                      SizedBox(width: 6),
                      Text(
                        'KARISMA EVENT NUSANTARA 2025',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pine500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Atraksi & Event Budaya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pine900,
                      letterSpacing: -0.45,
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Text('Semua', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.pine700)),
                  Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.pine700),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _EventCard(
            tanggal: '24 OKT',
            countdown: 'H-45 Hari',
            lokasi: 'Tentena, Poso',
            nama: 'Festival Danau Poso ke-24',
            desc: 'Parade budaya, tari mogele, & lomba perahu naga.',
            color: AppColors.pine700,
          ),
          const SizedBox(height: 12),
          _EventCard(
            tanggal: '18 NOV',
            countdown: 'H-70 Hari',
            lokasi: 'Parigi Moutong',
            nama: 'Festival Teluk Tomini (FTT)',
            desc: 'Eksplorasi bawah laut, karnaval kostum bahari & expo UMKM.',
            color: AppColors.pine500,
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String tanggal;
  final String countdown;
  final String lokasi;
  final String nama;
  final String desc;
  final Color color;

  const _EventCard({
    required this.tanggal,
    required this.countdown,
    required this.lokasi,
    required this.nama,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x122E5C43),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail kalender
          Container(
            width: 56,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.pine500.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.pine500.withOpacity(0.15),
                    child: const Center(
                      child: Icon(Icons.image_rounded, size: 24, color: AppColors.pine500),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: color,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    tanggal,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xCCFDE68A)),
                      ),
                      child: Text(
                        countdown,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      lokasi,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.pine500),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  nama,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.pine900),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Text('Detail', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.pine900)),
                SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, size: 12, color: AppColors.pine900),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.account_balance_rounded, size: 16, color: AppColors.pine700),
              SizedBox(width: 6),
              Text(
                'Dinas Pariwisata Provinsi Sulawesi Tengah',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pine700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Berani Kamaimo • Gerakan Wisata Berkelanjutan & Ekraf Sulteng',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: const [
              _FooterLink('Hotel & Penginapan'),
              Text('•', style: TextStyle(color: AppColors.pine500)),
              _FooterLink('Kuliner Khas'),
              Text('•', style: TextStyle(color: AppColors.pine500)),
              _FooterLink('Peta Wisata'),
              Text('•', style: TextStyle(color: AppColors.pine500)),
              _FooterLink('Tentang Kami'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  const _FooterLink(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.pine500),
    );
  }
}

// ─── Placeholder Screen ───────────────────────────────────────────────────────

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          '$title (M2)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textTertiary),
        ),
      ),
    );
  }
}
