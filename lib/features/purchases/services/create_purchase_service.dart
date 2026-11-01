import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class CreatePurchaseService {
  Future<int> createPurchase({
    required int customerId,
    required String notes,
  }) async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().post(
      '${ApiConstants.baseUrl}/purchases/',

      data: {
        'purchase_date': DateTime.now().toIso8601String().split('T').first,

        'notes': notes,

        'customer': customerId,
      },

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['id'];
  }
}
