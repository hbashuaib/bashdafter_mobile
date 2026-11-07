import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class StockAdjustmentService {
  Future<void> createAdjustment({
    required int productId,
    required String adjustmentType,
    required String quantity,
    required String reason,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post(
        '/stock-adjustments/',

        data: {
          'product': productId,
          'adjustment_type': adjustmentType,
          'quantity': quantity.trim(),
          'reason': reason.trim(),
        },        
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected stock adjustment error');
    }
  }
}
