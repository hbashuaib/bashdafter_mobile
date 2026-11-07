import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class CreatePaymentService {
  Future<void> createPayment({
    required int customerId,
    required String amount,
    required String paymentDate,
    required String notes,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post(
        '/payments/',

        data: {
          'amount': amount.trim(),
          'payment_date': paymentDate,
          'notes': notes.trim(),
          'customer': customerId,
        },        
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected payment creation error');
    }
  }
}
