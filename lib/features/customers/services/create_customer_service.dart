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

    await Dio().post(
      '${ApiConstants.baseUrl}/customers/',

      data: {
        'name': name,
        'phone': phone,
        'address': address,
        'notes': notes,
        'is_active': true,
      },

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
