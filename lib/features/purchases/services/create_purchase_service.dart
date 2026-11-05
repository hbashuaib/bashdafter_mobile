import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class CreatePurchaseService {
  Future<int> createPurchase({
    required int customerId,
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
      final response = await dio.post(
        '${ApiConstants.baseUrl}/purchases/',

        data: {
          'purchase_date': DateTime.now().toIso8601String().split('T').first,

          'notes': notes.trim(),

          'customer': customerId,
        },

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data['id'];
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected purchase creation error');
    }
  }
}
