import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/api_config.dart';
import 'package:berani_kamaimo/models/kuliner.dart';

class KulinerRepository {
  final ApiClient _apiClient;

  KulinerRepository(this._apiClient);

  Future<List<Kuliner>> getAll() async {
    final jsonList = await _apiClient.get(ApiConfig.kuliner) as List;
    return jsonList.map((json) => Kuliner.fromJson(json)).toList();
  }

  Future<Kuliner?> getById(int id) async {
    final json = await _apiClient.get('${ApiConfig.kuliner}/$id');
    if (json.isEmpty) return null;
    return Kuliner.fromJson(json);
  }
}