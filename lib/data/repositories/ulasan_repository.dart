import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/api_config.dart';
import 'package:berani_kamaimo/models/ulasan.dart';

class UlasanRepository {
  final ApiClient _apiClient;

  UlasanRepository(this._apiClient);

  Future<List<Ulasan>> getAll() async {
    final jsonList = await _apiClient.get(ApiConfig.ulasan) as List;
    return jsonList.map((json) => Ulasan.fromJson(json)).toList();
  }

  Future<Ulasan?> getById(int id) async {
    final json = await _apiClient.get('${ApiConfig.ulasan}/$id');
    if (json.isEmpty) return null;
    return Ulasan.fromJson(json);
  }

  /// POST ulasan baru (publik, tanpa login).
  Future<Map<String, dynamic>> insertUlasan({
    required String nama,
    required int rating,
    required String komentar,
  }) async {
    return _apiClient.post(
      ApiConfig.insertUlasan,
      body: {
        'nama': nama,
        'rating': rating,
        'komentar': komentar,
      },
    );
  }
}