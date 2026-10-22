import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';
import 'semua_destinasi_screen.dart';

/// Shell user: bottom nav floating + home screenpanjang.
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
          _PlaceholderScreen('Kuliner'),
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
    (icon: Icons.restaurant_menu_rounded, label: 'Kuliner'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 70,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
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

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scroll,
        slivers: [
          // Header Sticky Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _NavBarDelegate(scrollController: _scroll),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Greeting + Weather
                const _GreetingWeatherSection(),
                const SizedBox(height: 24),
                // 2. Headline
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Mau jelajah ke mana hari ini?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.pine900,
                      height: 1.25,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 3. Category Pills
                _CategoryPills(),
                const SizedBox(height: 20),
                // 4. Search Bar
                _SearchBar(),
                const SizedBox(height: 24),
                // 5. Hero Card: Danau Paisu Pok
                const _HeroCardPaisuPok(),
                const SizedBox(height: 24),
                // 6. Destinasi Ikonik (Horizontal Scroll)
                const _DestinasiIkonikSection(),
                const SizedBox(height: 24),
                // 7. Event Promo Card
                const _EventPromoCard(),
                const SizedBox(height: 24),
                // 8. Quick Access Menu: Peta Desa Wisata
                const _QuickAccessMap(),
                const SizedBox(height: 24),
                // 9. Statistik Wisman
                const _StatistikWisman(),
                const SizedBox(height: 24),
                // 10. Testimoni
                const _TestimoniSection(),
                const SizedBox(height: 24),
                // 11. Concierge WhatsApp Banner
                const _ConciergeWABanner(),
                const SizedBox(height: 24),
                // 12. Footer
                _Footer(),
                // extra padding bawah untuk floating nav
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nav Bar Delegate (sticky) ────────────────────────────────────────────────

class _NavBarDelegate extends SliverPersistentHeaderDelegate {
  final ScrollController scrollController;
  const _NavBarDelegate({required this.scrollController});

  @override
  double get minExtent => 64;
  @override
  double get maxExtent => 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isBlurred = shrinkOffset > 4;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: isBlurred ? Colors.white.withValues(alpha: 0.8) : AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: isBlurred ? Colors.white.withValues(alpha: 0.3) : AppColors.border,
            width: 1.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo + Text "Berani Kamaimo" + "SULAWESI TENGAH"
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.pine600,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.landscape_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BERANI KAMAIMO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.pine900,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'SULAWESI TENGAH',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pine500,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Language pill (ID/EN)
              const _LangPill(label: 'ID', active: false),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_NavBarDelegate old) => false;
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

// ─── Greeting & Weather Section ───────────────────────────────────────────────

class _GreetingWeatherSection extends StatelessWidget {
  const _GreetingWeatherSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, Penjelajah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.pine900,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Kamaimo Sulteng',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
          // Weather badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.emerald50,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: AppColors.emerald100),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wb_sunny_rounded, color: Color(0xFFF59E0B), size: 14),
                SizedBox(width: 4),
                Text(
                  '28°C Cerah',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.emerald600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category Pills ────────────────────────────────────────────────────────────

class _CategoryPills extends StatefulWidget {
  @override
  State<_CategoryPills> createState() => _CategoryPillsState();
}

class _CategoryPillsState extends State<_CategoryPills> {
  int _selected = 0;
  static const _categories = [
    'Semua',
    'Bahari & Karst',
    'Megalitikum',
    'Budaya & Adat',
    'Kuliner Khas',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (ctx, i) {
            final active = i == _selected;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? AppColors.pine700 : Colors.white,
                  borderRadius: BorderRadius.circular(9999),
                  border: active ? null : Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: Text(
                  _categories[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.bold : FontWeight.w600,
                    color: active ? Colors.white : AppColors.pine900,
                    letterSpacing: 0.5,
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
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.pine700.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _ctrl,
              onSubmitted: _onSubmit,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari Danau Paisu Pok, Sombori...',
                hintStyle: TextStyle(fontSize: 14, color: AppColors.textTertiary),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // Filter icon
          Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppColors.pine700,
              size: 22,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ─── Hero Card: Danau Paisu Pok ─────────────────────────────────────────────

class _HeroCardPaisuPok extends StatelessWidget {
  const _HeroCardPaisuPok();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/danau_paisu_pok.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay for text readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'DANAU PAISU POK',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.pine700,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                const Text(
                  'Danau Paisu Pok',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                // Price tag
                const Text(
                  'Rp 15.000 /org',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Bookmark
                    GestureDetector(
                      onTap: () {}, // TODO: Implement bookmark functionality
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    // CTA Button
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 12),
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.pine700,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: const Center(
                          child: Text(
                            'Jelajahi Sekarang',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
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

// ─── Destinasi Ikonik Section ───────────────────────────────────────────

class _DestinasiIkonikSection extends StatelessWidget {
  const _DestinasiIkonikSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Destinasi Ikonik Sulteng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pine900,
                  letterSpacing: -0.45,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SemuaDestinasiScreen()),
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pine700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Horizontal Scroll
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (ctx, i) {
                final items = [
                  {
                    'kabupaten': 'BANGGAI KEPULAUAN',
                    'nama': 'Kepulauan Sombori',
                    'badge': 'THE SECRET PARADISE',
                    'rating': '4.95',
                    'ulasan': '930 ulasan',
                    'harga': 'Rp 350.000',
                    'satuan': '/tur',
                  },
                  {
                    'kabupaten': 'POSO • TENTENA',
                    'nama': 'Danau Poso & Pasir Emas',
                    'badge': 'PASIR EMAS TENTENA',
                    'rating': '4.88',
                    'ulasan': '2.1k ulasan',
                    'harga': 'Rp 10.000',
                    'satuan': '/orang',
                  },
                  {
                    'kabupaten': 'MOROWALI',
                    'nama': 'Lembah Bada & Besoa',
                    'badge': 'PESONA LEMBAH',
                    'rating': '4.92',
                    'ulasan': '1.2k ulasan',
                    'harga': 'Rp 75.000',
                    'satuan': '/paket',
                  },
                ];
                final item = items[i];
                return GestureDetector(
                  onTap: () {}, // TODO: Navigate to detail
                  child: Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x141D3A30),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image placeholder
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.pine500.withValues(alpha: 0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.landscape,
                                size: 32,
                                color: AppColors.pine500,
                              ),
                            ),
                          ),
                        ),
                        // Info
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Kabupaten badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.pine700.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item['kabupaten']!,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.pine700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Nama destinasi
                                Text(
                                  item['nama']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.pine900,
                                    height: 1.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item['badge']!,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.pine700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Rating
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['rating']!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.pine900,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${item['ulasan']!})',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Price
                                Row(
                                  children: [
                                    const Text(
                                      'Mulai dari',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['harga']!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.pine700,
                                      ),
                                    ),
                                    Text(
                                      item['satuan']!,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Event Promo Card ──────────────────────────────────────────────────────

class _EventPromoCard extends StatelessWidget {
  const _EventPromoCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with countdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      'Festival Danau Poso ke-24',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.pine900,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ],
                ),
                // Countdown badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: const Color(0xCCFDE68A)),
                  ),
                  child: const Text(
                    'H-45 Hari',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Location
            const Row(
              children: [
                Icon(Icons.location_on_rounded, size: 14, color: AppColors.pine500),
                SizedBox(width: 4),
                Text(
                  'Tentena, Poso • 24 Oktober 2025',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description
            const Text(
              'Parade budaya, tari mogele, & lomba perahu naga. '
              'Rasakan keindahan danau purba terbesar ke-3 di Indonesia.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            // CTA Button
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.pine700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Lihat Rincian',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Access Menu: Peta Desa Wisata ──────────────────────────────────

class _QuickAccessMap extends StatelessWidget {
  const _QuickAccessMap();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x141D3A30),
              blurRadius: 12,
              offset: Offset(0, 4),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 8),
            const Text(
              'Temukan 43+ desa wisata di Sulawesi Tengah '
              'dengan filter kabupaten & kategori.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Map placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2EB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 32, color: AppColors.pine500),
                    SizedBox(height: 8),
                    Text(
                      'Peta Desa Wisata',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pine500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // CTA Button
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.pine700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Buka Peta Lengkap',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Statistik Wisman ──────────────────────────────────────────────────────

class _StatistikWisman extends StatelessWidget {
  const _StatistikWisman();

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'rank': '1', 'negara': 'Jerman', 'persen': '28%'},
      {'rank': '2', 'negara': 'Prancis', 'persen': '22%'},
      {'rank': '3', 'negara': 'Australia', 'persen': '15%'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Statistik Wisatawan Mancanegara',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pine900,
                  letterSpacing: -0.45,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SemuaDestinasiScreen()),
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pine700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...stats.map((stat) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x141D3A30),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Row(
              children: [
                // Rank badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: stat['rank'] == '1'
                        ? const Color(0xFFF59E0B)
                        : stat['rank'] == '2'
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFFCD7F32),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      stat['rank']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Country name
                Expanded(
                  child: Text(
                    stat['negara']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.pine900,
                    ),
                  ),
                ),
                // Percentage
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.emerald50,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: AppColors.emerald100),
                  ),
                  child: Text(
                    stat['persen']!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald600,
                    ),
                  ),
                ),
              ],
            ),
          )),
          // View all button
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Lihat Ranking Lengkap',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.pine700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Testimoni Section ─────────────────────────────────────────────────────

class _TestimoniSection extends StatelessWidget {
  const _TestimoniSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Apa Kata Para Penjelajah?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pine900,
                  letterSpacing: -0.45,
                ),
              ),
              Text(
                'Semua Testimoni',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pine700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x141D3A30),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quote icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.pine700.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.format_quote_rounded,
                    size: 24,
                    color: AppColors.pine700,
                  ),
                ),
                const SizedBox(height: 16),
                // Testimoni text
                const Text(
                  '"Sulawesi Tengah benar-benar permata tersembunyi! '
                  'Danau Paisu Pok seperti di dunia impian, airnya jernih '
                  'dan pemandangan gunungnya megah. Wajib dikunjungi!"',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                // Author
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.pine500.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'LW',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pine700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lukas Weber',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pine900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: List.generate(5, (i) => const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          )),
                        ),
                      ],
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

// ─── Concierge WhatsApp Banner ─────────────────────────────────────────────

class _ConciergeWABanner extends StatelessWidget {
  const _ConciergeWABanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.pine800, AppColors.pine700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x331A3A2A),
              blurRadius: 20,
              offset: Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Row(
          children: [
            // WhatsApp icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.chat_bubble_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Text content
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Butuh Bantuan Perjalanan?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tim concierge kami siap bantu 24/7 via WhatsApp',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            // CTA Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Chat WA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          SizedBox(height: 4),
          Text(
            'BBWI • Berani Kamaimo',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
          ),
          SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
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
