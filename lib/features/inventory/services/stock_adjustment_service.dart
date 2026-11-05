import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class StockAdjustmentService {
  Future<void> createAdjustment({
    required int productId,
    required String adjustmentType,
    required String quantity,
    required String reason,
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
        '${ApiConstants.baseUrl}/stock-adjustments/',

        data: {
          'product': productId,
          'adjustment_type': adjustmentType,
          'quantity': quantity.trim(),
          'reason': reason.trim(),
        },

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected stock adjustment error');
    }
  }
}
