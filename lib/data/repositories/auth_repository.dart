import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/api_config.dart';
import 'package:berani_kamaimo/core/network/token_store.dart';
import 'package:berani_kamaimo/models/admin_user.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStore _tokenStore;

  AuthRepository(this._apiClient, this._tokenStore);

  Future<AdminUser?> login(String username, String password) async {
    final json = await _apiClient.post(
      ApiConfig.login,
      body: {'username': username, 'password': password},
    );
    final data = json['data'] as Map<String, dynamic>;
    final token = data['token'] as String?;
    final user = AdminUser.fromJson(data['user'] as Map<String, dynamic>);
    if (token != null) {
      await _tokenStore.saveToken(token);
    }
    return user;
  }

  Future<void> logout() async {
    await _tokenStore.clearToken();
  }

  Future<bool> get isLoggedIn async {
    final token = await _tokenStore.getToken();
    return token != null;
  }
}