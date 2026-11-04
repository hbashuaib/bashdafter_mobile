import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class UpdateCustomerService {
  Future<void> updateCustomer({
    required int customerId,
    required String name,
    required String phone,
    required String address,
    required String notes,
    required bool isActive,
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
        '${ApiConstants.baseUrl}/customers/$customerId/',

        data: {
          'name': name.trim(),
          'phone': phone.trim(),
          'address': address.trim(),
          'notes': notes.trim(),
          'is_active': isActive,
        },

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer update error');
    }
  }
}
