import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class CreatePurchaseItemService {
  Future<void> createItem({
    required int purchaseId,
    required int productId,
    required String itemName,
    required String quantity,
    required String unitPrice,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post(
        '/purchase-items/',

        data: {
          'purchase': purchaseId,
          'product': productId,
          'item_name': itemName.trim(),
          'quantity': quantity.trim(),
          'unit_price': unitPrice.trim(),
        },
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected purchase item creation error');
    }
  }
}
