import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/api_config.dart';
import 'package:berani_kamaimo/models/jarak_desa.dart';
import 'package:berani_kamaimo/models/index.dart';

class JarakRepository {
  final ApiClient _apiClient;

  JarakRepository(this._apiClient);

  Future<List<JarakDesa>> getAll() async {
    final jsonList = await _apiClient.get(ApiConfig.jarak) as List;
    return jsonList.map((json) => JarakDesa.fromJson(json)).toList();
  }

  Future<List<JarakDesa>> getByDesaId(int desaId) async {
    final all = await getAll();
    return all.where((j) => j.desaId == desaId).toList();
  }
}