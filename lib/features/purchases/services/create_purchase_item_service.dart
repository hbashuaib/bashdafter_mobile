import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class CreatePurchaseItemService {
  Future<void> createItem({
    required int purchaseId,
    required int productId,
    required String itemName,
    required String quantity,
    required String unitPrice,
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
        '${ApiConstants.baseUrl}/purchase-items/',

        data: {
          'purchase': purchaseId,
          'product': productId,
          'item_name': itemName.trim(),
          'quantity': quantity.trim(),
          'unit_price': unitPrice.trim(),
        },

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected purchase item creation error');
    }
  }
}
