import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Halaman Sambutan (Opening Screen) sesuai PRD v1.1.
/// Tampil tiap kali aplikasi dibuka sebelum masuk Home.
/// Memuat logo, nama Berani Kamaimo, tagline, pilihan bahasa,
/// Ranking Asal Turis (Top 5 Negara), dan tombol besar "Masuk".
class HalamanSambutan extends StatelessWidget {
  const HalamanSambutan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo / Icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.pine900,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.landscape,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // Nama Aplikasi
              const Text(
                'BERANI KAMAIMO',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.pine900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'SULAWESI TENGAH',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.pine500,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              // Tagline
              const Text(
                'Menunggu petualanganmu di jantung indonesia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              // Ranking Asal Turis (Top 5 Negara)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pine900.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dari Mana Tamu Kami Datang?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pine900,
                      ),
                    ),
                    SizedBox(height: 16),
                    _RankingItem(rank: 1, country: 'Jerman', count: '28%'),
                    _RankingItem(rank: 2, country: 'Prancis', count: '22%'),
                    _RankingItem(rank: 3, country: 'Australia', count: '15%'),
                    _RankingItem(rank: 4, country: 'Belanda', count: '12%'),
                    _RankingItem(rank: 5, country: 'Amerika Serikat', count: '10%'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Tombol Masuk
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pine700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Navigasi ke UserShell / Home
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankingItem extends StatelessWidget {
  final int rank;
  final String country;
  final String count;

  const _RankingItem({
    required this.rank,
    required this.country,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor = rank == 1
        ? const Color(0xFFF59E0B)
        : rank == 2
            ? const Color(0xFF9CA3AF)
            : rank == 3
                ? const Color(0xFFCD7F32)
                : AppColors.pine500;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              country,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.pine900,
              ),
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.pine700,
            ),
          ),
        ],
      ),
    );
  }
}
