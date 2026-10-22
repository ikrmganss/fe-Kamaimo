import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Halaman detail desa wisata — sesuai Figma Desain 1
class DetailDesaScreen extends StatefulWidget {
  final int desaId;
  final String namaDesa;
  final String lokasi;
  final String foto;

  const DetailDesaScreen({
    super.key,
    required this.desaId,
    required this.namaDesa,
    required this.lokasi,
    required this.foto,
  });

  @override
  State<DetailDesaScreen> createState() => _DetailDesaScreenState();
}

class _DetailDesaScreenState extends State<DetailDesaScreen> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Image + Overlay
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.pine500.withValues(alpha: 0.2),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image placeholder
                  Container(
                    color: AppColors.pine500.withValues(alpha: 0.2),
                    child: widget.foto.isNotEmpty
                        ? Image.network(
                            widget.foto,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Center(
                              child: Icon(
                                Icons.landscape,
                                size: 64,
                                color: AppColors.pine500,
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.landscape,
                              size: 64,
                              color: AppColors.pine500,
                            ),
                          ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Top actions: back + bookmark
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        // Bookmark
                        GestureDetector(
                          onTap: () =>
                              setState(() => _isBookmarked = !_isBookmarked),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom info
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.emerald50,
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(color: AppColors.emerald100),
                              ),
                              child: const Text(
                                'DESA UNGGULAN',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.emerald600,
                                  letterSpacing: 0.225,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppColors.pine500,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '4.9',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '(1.4k ulasan)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.namaDesa,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.lokasi,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info chips row
                  const Row(
                    children: [
                      _InfoChip(
                        icon: Icons.access_time_rounded,
                        label: 'Buka 08:00 - 17:00',
                      ),
                      SizedBox(width: 12),
                      _InfoChip(
                        icon: Icons.directions_walk_rounded,
                        label: '2.4 km dari sini',
                      ),
                      SizedBox(width: 12),
                      _InfoChip(
                        icon: Icons.local_parking_rounded,
                        label: 'Parkir luas',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Deskripsi
                  const Text(
                    'Tentang Destinasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pine900,
                      letterSpacing: -0.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Danau Paisu Pok merupakan danau alami yang terletak di Desa Luk Panenteng, '
                    'Kecamatan Banggai Laut, Kabupaten Banggai Kepulauan. Danau ini memiliki '
                    'air yang sangat jernih seperti kaca, dikelilingi oleh bukit-bukit hijau '
                    'dan hutan tropis yang masih alami. Cocok untuk aktivitas fotografi, '
                    'piknik keluarga, dan bersantai menikmati keindahan alam.\n\n'
                    'Air danau Paisu Pok berasal dari mata air alami yang keluar dari bawah tanah, '
                    'sehingga jernihnya terlihat sampai ke dasar. Wisatawan bisa berenang, '
                    'memanjat bukit sekitar untuk melihat pemandangan panorama, atau sekadar '
                    'menikmati kedamaian alam.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Fasilitas
                  const Text(
                    'Fasilitas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pine900,
                      letterSpacing: -0.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _FacilityItem(
                        icon: Icons.local_parking_rounded,
                        label: 'Area Parkir',
                      ),
                      _FacilityItem(
                        icon: Icons.wc_rounded,
                        label: 'Toilet Umum',
                      ),
                      _FacilityItem(
                        icon: Icons.restaurant_rounded,
                        label: 'Warung Makan',
                      ),
                      _FacilityItem(
                        icon: Icons.wifi_rounded,
                        label: 'WiFi Area',
                      ),
                      _FacilityItem(
                        icon: Icons.directions_bike_rounded,
                        label: 'Sewa Sepeda',
                      ),
                      _FacilityItem(
                        icon: Icons.camera_alt_rounded,
                        label: 'Spot Foto',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Harga tiket
                  const Text(
                    'Harga Tiket Masuk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pine900,
                      letterSpacing: -0.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      children: [
                        _PriceRow(label: 'Dewasa (WNI)', price: 'Rp 15.000'),
                        Divider(height: 16, color: AppColors.borderLight),
                        _PriceRow(label: 'Anak-anak (WNI)', price: 'Rp 7.500'),
                        Divider(height: 16, color: AppColors.borderLight),
                        _PriceRow(
                          label: 'Wisatawan Mancanegara',
                          price: 'Rp 50.000',
                        ),
                        Divider(height: 16, color: AppColors.borderLight),
                        _PriceRow(label: 'Parkir Motor', price: 'Rp 5.000'),
                        Divider(height: 16, color: AppColors.borderLight),
                        _PriceRow(label: 'Parkir Mobil', price: 'Rp 10.000'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Galeri foto
                  const Text(
                    'Galeri Foto',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pine900,
                      letterSpacing: -0.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (ctx, i) => Container(
                        width: 160,
                        decoration: BoxDecoration(
                          color: AppColors.pine500.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image_rounded,
                            size: 32,
                            color: AppColors.pine500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Peta lokasi
                  const Text(
                    'Lokasi di Peta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pine900,
                      letterSpacing: -0.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2EB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 40,
                            color: AppColors.pine500,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Peta Interaktif (flutter_map di M1-2)',
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

                  // Tombol navigasi
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.pine700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.navigation_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Navigasi ke Sini',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // padding untuk floating nav
                ],
              ),
            ),
          ),
        ],
      ),
      // Floating bottom nav tidak ditampilkan di halaman detail
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x141D3A30),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.pine700),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.pine900,
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FacilityItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.pine700),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.pine900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String price;

  const _PriceRow({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          price,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.pine900,
          ),
        ),
      ],
    );
  }
}
