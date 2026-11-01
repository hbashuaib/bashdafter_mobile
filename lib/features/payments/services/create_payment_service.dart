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

    await Dio().post(
      '${ApiConstants.baseUrl}/payments/',

      data: {
        'amount': amount,

        'payment_date': paymentDate,

        'notes': notes,

        'customer': customerId,
      },

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
