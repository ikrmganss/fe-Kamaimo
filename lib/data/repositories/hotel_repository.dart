import 'package:berani_kamaimo/core/network/api_client.dart';
import 'package:berani_kamaimo/core/network/api_config.dart';
import 'package:berani_kamaimo/models/hotel.dart';

class HotelRepository {
  final ApiClient _apiClient;

  HotelRepository(this._apiClient);

  Future<List<Hotel>> getAll() async {
    final jsonList = await _apiClient.get(ApiConfig.hotel) as List;
    return jsonList.map((json) => Hotel.fromJson(json)).toList();
  }

  Future<Hotel?> getById(int id) async {
    final json = await _apiClient.get('${ApiConfig.hotel}/$id');
    if (json.isEmpty) return null;
    return Hotel.fromJson(json);
  }
}