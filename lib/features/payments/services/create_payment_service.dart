import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class CreatePaymentService {
  Future<void> createPayment({
    required int customerId,
    required String amount,
    required String paymentDate,
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
        '${ApiConstants.baseUrl}/payments/',

        data: {
          'amount': amount.trim(),
          'payment_date': paymentDate,
          'notes': notes.trim(),
          'customer': customerId,
        },

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected payment creation error');
    }
  }
}
