import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class ShopService {
  Future<Map<String, dynamic>> getShop() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/shops/');
      final data = response.data as List<dynamic>;

      if (data.isEmpty) {
        throw Exception('No shop profile found');
      }

      return data.first as Map<String, dynamic>;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected shop loading error');
    }
  }

  Future<void> updateShop({
    required int id,
    required String name,
    required String phone,
    required String address,
    required String city,
    required String currency,
    required bool isActive,
    required int owner,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.put(
        '/shops/$id/',
        data: {
          'name': name.trim(),
          'phone': phone.trim(),
          'address': address.trim(),
          'city': city.trim(),
          'currency': currency.trim(),
          'is_active': isActive,
          'owner': owner,
        },
        
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected shop update error');
    }
  }
}
