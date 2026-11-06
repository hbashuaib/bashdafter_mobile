import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class ShopService {
  Future<Map<String, dynamic>> getShop() async {
    final token = await TokenStorage.getAccessToken();

    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/shops/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

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
    final token = await TokenStorage.getAccessToken();

    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    try {
      await dio.put(
        '${ApiConstants.baseUrl}/shops/$id/',
        data: {
          'name': name.trim(),
          'phone': phone.trim(),
          'address': address.trim(),
          'city': city.trim(),
          'currency': currency.trim(),
          'is_active': isActive,
          'owner': owner,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected shop update error');
    }
  }
}
