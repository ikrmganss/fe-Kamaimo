import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/api_config.dart';
import 'package:berani_kamaimo/models/atraksi.dart';
import 'package:berani_kamaimo/models/index.dart';

class AtraksiRepository {
  final ApiClient _apiClient;

  AtraksiRepository(this._apiClient);

  Future<List<Atraksi>> getAll() async {
    final jsonList = await _apiClient.get(ApiConfig.atraksi) as List;
    return jsonList.map((json) => Atraksi.fromJson(json)).toList();
  }

  Future<Atraksi?> getById(int id) async {
    final json = await _apiClient.get('${ApiConfig.atraksi}/$id');
    if (json.isEmpty) return null;
    return Atraksi.fromJson(json);
  }
}