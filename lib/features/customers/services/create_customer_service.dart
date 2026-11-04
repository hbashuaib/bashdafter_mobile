import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class CreateCustomerService {
  Future<void> createCustomer({
    required String name,
    required String phone,
    required String address,
    required String notes,
  }) async {
    final token = await TokenStorage.getAccessToken();

    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    try {
      await dio.post(
        '${ApiConstants.baseUrl}/customers/',

        data: {
          'name': name.trim(),
          'phone': phone.trim(),
          'address': address.trim(),
          'notes': notes.trim(),
          'is_active': true,
        },

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer creation error');
    }
  }
}
