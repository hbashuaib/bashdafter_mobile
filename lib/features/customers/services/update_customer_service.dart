import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class UpdateCustomerService {
  Future<void> updateCustomer({
    required int customerId,
    required String name,
    required String phone,
    required String address,
    required String notes,
    required bool isActive,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.put(
        '/customers/$customerId/',

        data: {
          'name': name.trim(),
          'phone': phone.trim(),
          'address': address.trim(),
          'notes': notes.trim(),
          'is_active': isActive,
        },
        
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer update error');
    }
  }
}
