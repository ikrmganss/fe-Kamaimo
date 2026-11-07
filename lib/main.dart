import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/network/api_client.dart';
import 'core/network/token_store.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/constants.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/kunjungan_turis_repository.dart';
import 'features/admin/login/admin_login_screen.dart';
import 'features/admin/shell/admin_shell.dart';
import 'features/user/sambutan/halaman_sambutan.dart';
import 'features/user/detail_wisata/detail_wisata_screen.dart';
import 'features/user/home/semua_destinasi_screen.dart';
import 'features/user/home/user_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TokenStore>(
          create: (_) => InMemoryTokenStore(),
        ),
        ProxyProvider<TokenStore, ApiClient>(
          update: (_, tokenStore, __) =>
              ApiClient(tokenStore: tokenStore),
        ),
        ProxyProvider2<ApiClient, TokenStore, AuthRepository>(
          update: (_, apiClient, tokenStore, __) =>
              AuthRepository(apiClient, tokenStore),
        ),
        ProxyProvider<ApiClient, KunjunganTurisRepository>(
          update: (_, apiClient, __) =>
              KunjunganTurisRepository(apiClient),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        initialRoute: AppConstants.routeSambutan,
        routes: {
          AppConstants.routeSambutan: (context) => const HalamanSambutan(),
          AppConstants.routeHome: (context) => const UserShell(),
          AppConstants.routePaketWisata: (context) => const SemuaDestinasiScreen(),
          AppConstants.routeAdminLogin: (context) => const AdminLoginScreen(),
          AppConstants.routeAdminDashboard: (context) => const AdminShell(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppConstants.routeDetailDesa) {
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => DetailWisataScreen(
                desaId: args?['desaId'] ?? 1,
                namaDesa: args?['namaDesa'] ?? 'Destinasi',
                lokasi: args?['lokasi'] ?? 'Sulawesi Tengah',
                foto: args?['foto'] ?? '',
              ),
            );
          }
          return null;
        },
        onUnknownRoute: (settings) => PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const _NotFound(),
        ),
      ),
    );
  }
}

/// Halaman 404 sederhana untuk route tidak dikenal.
class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
        child: Text('Halaman "${ModalRoute.of(context)?.settings.name}" tidak ada.',
            style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}