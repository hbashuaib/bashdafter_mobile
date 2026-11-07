import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class CreatePurchaseService {
  Future<int> createPurchase({
    required int customerId,
    required String notes,
  }) async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.post(
        '/purchases/',

        data: {
          'purchase_date': DateTime.now().toIso8601String().split('T').first,
          'notes': notes.trim(),
          'customer': customerId,
        },        
      );

      return response.data['id'];
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected purchase creation error');
    }
  }
}
