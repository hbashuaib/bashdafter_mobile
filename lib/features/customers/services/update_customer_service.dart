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

    await Dio().put(
      '${ApiConstants.baseUrl}/customers/$customerId/',

      data: {
        'name': name,
        'phone': phone,
        'address': address,
        'notes': notes,
        'is_active': isActive,
      },

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
