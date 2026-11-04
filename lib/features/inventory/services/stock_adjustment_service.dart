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

    await Dio().post(
      '${ApiConstants.baseUrl}/stock-adjustments/',

      data: {
        'product': productId,
        'adjustment_type': adjustmentType,
        'quantity': quantity,
        'reason': reason,
      },

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
