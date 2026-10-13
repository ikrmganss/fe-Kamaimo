import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/api_config.dart';
import 'package:berani_kamaimo/models/rumah_makan.dart';

class RumahMakanRepository {
  final ApiClient _apiClient;

  RumahMakanRepository(this._apiClient);

  Future<List<RumahMakan>> getAll() async {
    final jsonList = await _apiClient.get(ApiConfig.rumahMakan) as List;
    return jsonList.map((json) => RumahMakan.fromJson(json)).toList();
  }

  Future<List<RumahMakan>> getByKulinerId(int kulinerId) async {
    final all = await getAll();
    return all.where((r) => r.kulinerId == kulinerId).toList();
  }
}