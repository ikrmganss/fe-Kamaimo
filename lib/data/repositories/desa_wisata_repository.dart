import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/api_config.dart';
import 'package:berani_kamaimo/models/desa_wisata.dart';
import 'package:berani_kamaimo/models/index.dart';

class DesaWisataRepository {
  final ApiClient _apiClient;

  DesaWisataRepository(this._apiClient);

  Future<List<DesaWisata>> getAll() async {
    final jsonList = await _apiClient.get(ApiConfig.desaWisata) as List;
    return jsonList.map((json) => DesaWisata.fromJson(json)).toList();
  }

  Future<DesaWisata?> getById(int id) async {
    final json = await _apiClient.get('${ApiConfig.desaWisata}/$id');
    if (json.isEmpty) return null;
    return DesaWisata.fromJson(json);
  }
}
