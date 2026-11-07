import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class CreateCustomerService {
  Future<void> createCustomer({
    required String name,
    required String phone,
    required String address,
    required String notes,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post(
        '/customers/',
        
        data: {
          'name': name.trim(),
          'phone': phone.trim(),
          'address': address.trim(),
          'notes': notes.trim(),
          'is_active': true,
        },
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected customer creation error');
    }
  }
}
