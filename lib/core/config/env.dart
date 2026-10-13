/// Konfigurasi environment via --dart-define.
/// Jalankan: flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );
}
