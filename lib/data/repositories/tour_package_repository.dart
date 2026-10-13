import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/api_config.dart';
import 'package:berani_kamaimo/models/tour_package.dart';
import 'package:berani_kamaimo/models/index.dart';

class TourPackageRepository {
  final ApiClient _apiClient;

  TourPackageRepository(this._apiClient);

  Future<List<TourPackage>> getAll() async {
    final jsonList = await _apiClient.get(ApiConfig.tourPackage) as List;
    return jsonList.map((json) => TourPackage.fromJson(json)).toList();
  }

  Future<TourPackage?> getById(int id) async {
    final json = await _apiClient.get('${ApiConfig.tourPackage}/$id');
    if (json.isEmpty) return null;
    return TourPackage.fromJson(json);
  }
}